from __future__ import annotations

import json
import os
import re
from collections import Counter
from typing import Any

import requests
from rapidfuzz import fuzz, process
from unidecode import unidecode

from reviews.text import normalize_course_text

OPENROUTER_URL = os.getenv("OPENROUTER_API_URL", "https://openrouter.ai/api/v1/chat/completions")
# Comma-separated list of models, tried in order. Override with COURSE_MATCH_MODELS.
DEFAULT_MODEL = os.getenv(
    "COURSE_MATCH_MODELS",
    "nvidia/nemotron-3-ultra-550b-a55b:free, baidu/ernie-5.5-flash-preview:free, particle-ai/particle-1:free, nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free",
)

COURSE_MATCH_PROMPT_VERSION = 7
COURSE_FAMILY_PROMPT_VERSION = 3
CONFIDENCE_ORDER = {"none": 0, "low": 1, "medium": 2, "high": 3}
TRANSIENT_UNMATCHED_METHODS = {"unmatched", "openrouter_limit_reached", "openrouter_error"}

LEVEL_EQUIVALENTS = {
    "1": {"1", "I"},
    "2": {"2", "II"},
    "3": {"3", "III"},
    "4": {"4", "IV"},
    "5": {"5", "V"},
    "I": {"1", "I"},
    "II": {"2", "II"},
    "III": {"3", "III"},
    "IV": {"4", "IV"},
    "V": {"5", "V"},
    "L": {"1", "I", "L"},
    "LL": {"2", "II", "LL"},
}
COURSE_TOKEN_STOPWORDS = {"A", "AL", "DE", "DEL", "E", "EL", "EN", "LA", "LAS", "LOS", "Y"}
GENERIC_SINGLE_COURSE_HINTS = {"BASE", "BASES", "CONTA", "CONTABILIDAD", "DATOS", "PROGRAMACION"}
GENERIC_GLOBAL_COURSE_NAMES = {"BASES DE DATOS", "CONTABILIDAD", "PROYECTO", "PRACTICA", "SEMINARIO", "TALLER"}


def decision_key(professor_id: int, class_name: object) -> str:
    return f"{professor_id}:{normalize_course_text(class_name)}"


def family_decision_key(professor_id: int, family: str, ambiguity_kind: str) -> str:
    return f"{professor_id}:{family}:{ambiguity_kind}"


def course_family(class_name: object) -> str | None:
    base_tokens = tokens_without_levels(meaningful_course_tokens(class_name))
    if not base_tokens:
        return None
    return normalize_course_text(" ".join(base_tokens))


def course_ambiguity_kind(class_name: object) -> str | None:
    if has_explicit_course_separator(class_name):
        return None
    tokens = meaningful_course_tokens(class_name)
    if not tokens or course_levels(tokens):
        return None
    base_tokens = tokens_without_levels(tokens)
    raw_acronym = re.sub(r"[^A-Za-z]", "", unidecode(str(class_name or "")).strip())
    if len(base_tokens) == 1:
        if 2 <= len(raw_acronym) <= 4 and raw_acronym.isupper():
            base = normalize_course_text(base_tokens[0])
            return f"acronym:{base}" if base else None
        return None
    base = normalize_course_text(" ".join(base_tokens))
    return f"generic:{base}" if base else None


def course_base_signature(course: dict[str, Any]) -> str:
    return normalize_course_text(" ".join(tokens_without_levels(meaningful_course_tokens(course.get("name")))))


def family_candidate_courses(class_name: object, courses: list[dict[str, Any]], *, match_scope: str, dominant_prefix_set: set[str], variation_course_ids: set[int], course_prefix_affinity: dict[int, Counter[str]]) -> list[dict[str, Any]]:
    class_tokens = meaningful_course_tokens(class_name)
    if not class_tokens:
        return []
    class_levels = course_levels(class_tokens)
    class_base_tokens = tokens_without_levels(class_tokens)
    candidates: list[tuple[float, dict[str, Any]]] = []
    for course in courses:
        target_tokens = meaningful_course_tokens(course.get("name"))
        target_level = course_level(target_tokens)
        target_base_tokens = tokens_without_levels(target_tokens)
        if class_levels and target_level is not None and target_level not in class_levels:
            continue
        if token_overlap_count(class_base_tokens, target_base_tokens) < max(1, min(2, len(class_base_tokens))):
            continue
        score, _ = course_contextual_score(
            class_name,
            course,
            match_scope=match_scope,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        )
        if score >= 82 or token_sets_equivalent(class_base_tokens, target_base_tokens):
            candidates.append((score, course))
    candidates.sort(key=lambda item: (item[0], str(item[1].get("code") or "")), reverse=True)
    unique: dict[int, dict[str, Any]] = {}
    for _, course in candidates[:20]:
        course_id = parse_course_id(course.get("course_id"))
        if course_id is not None:
            unique[course_id] = course
    return sorted(unique.values(), key=lambda course: str(course.get("code") or ""))


def course_decision(
    course: dict[str, Any],
    confidence: str,
    method: str,
    reason: str,
    *,
    match_scope: str,
    requires_offering_backfill: bool,
) -> dict[str, Any]:
    return {
        "course_id": int(course["course_id"]),
        "course_code": str(course["code"]),
        "course_name": str(course["name"]),
        "match_scope": match_scope,
        "requires_offering_backfill": requires_offering_backfill,
        "confidence": confidence,
        "method": method,
        "reason": reason,
    }


def is_course_confidence_accepted(decision: dict[str, Any], minimum_confidence: str) -> bool:
    if decision.get("course_id") is None:
        return False
    return CONFIDENCE_ORDER.get(str(decision.get("confidence") or "none"), 0) >= CONFIDENCE_ORDER[minimum_confidence]


def parse_course_id(value: object) -> int | None:
    try:
        return int(value) if value is not None else None
    except (TypeError, ValueError):
        return None


def course_tokens(value: object) -> list[str]:
    normalized = normalize_course_text(value)
    normalized = re.sub(r"\b(\d+)Y\s+(\d+)\b", r"\1 Y \2", normalized)
    normalized = re.sub(r"\b([IVXL]+)Y\s+([IVXL]+)\b", r"\1 Y \2", normalized)
    return re.findall(r"[A-Z0-9]+", normalized)


def meaningful_course_tokens(value: object) -> list[str]:
    return [token for token in course_tokens(value) if token not in COURSE_TOKEN_STOPWORDS]


def class_name_segments(value: object) -> list[list[str]]:
    raw = unidecode(str(value or "")).upper().strip()
    if not raw:
        return []
    parts = re.split(r"\s+(?:Y|O)\s+|[/,;&+|]|-", raw)
    return [course_tokens(part) for part in parts if course_tokens(part)]


def has_explicit_course_separator(value: object) -> bool:
    return len(class_name_segments(value)) > 1


def segment_text(segment_tokens: list[str]) -> str:
    return " ".join(segment_tokens)


def contextual_segments(value: object) -> list[list[str]]:
    segments = class_name_segments(value)
    contextualized: list[list[str]] = []
    previous_base_tokens: list[str] = []
    for segment_tokens in segments:
        levels = course_levels(segment_tokens)
        base_tokens = tokens_without_levels(segment_tokens)
        if levels and not base_tokens and previous_base_tokens:
            segment_tokens = [*previous_base_tokens, *segment_tokens]
            base_tokens = previous_base_tokens
        if base_tokens:
            previous_base_tokens = base_tokens
        contextualized.append(segment_tokens)
    return contextualized


def course_prefix(course: dict[str, Any]) -> str:
    match = re.match(r"[A-Z]+", str(course.get("code") or ""))
    return match.group(0) if match else ""


def course_prefix_affinity_score(course: dict[str, Any], *, dominant_prefix_set: set[str], course_prefix_affinity: dict[int, Counter[str]]) -> tuple[float, list[str]]:
    course_id = parse_course_id(course.get("course_id"))
    if course_id is None or not dominant_prefix_set:
        return 0, []
    affinity = course_prefix_affinity.get(course_id, Counter())
    matching_count = sum(affinity.get(prefix, 0) for prefix in dominant_prefix_set)
    if matching_count <= 0:
        return 0, []
    boost = min(18.0, 8.0 + matching_count)
    prefixes = "/".join(sorted(dominant_prefix_set))
    return boost, [f"course taught by professors with {prefixes} context"]


def dominant_prefixes(professor_courses: list[dict[str, Any]], decisions: dict[str, dict[str, Any]], professor_id: int) -> set[str]:
    counts: Counter[str] = Counter(course_prefix(course) for course in professor_courses if course_prefix(course))
    if not counts:
        return set()
    total = sum(counts.values())
    most_common_count = counts.most_common(1)[0][1]
    strong = {prefix for prefix, count in counts.items() if count == most_common_count or count / total >= 0.45}
    return strong


def normalized_course_name_without_generic_suffix(value: object) -> str:
    normalized = normalize_course_text(value)
    normalized = re.sub(r"\bVERANO\b", "", normalized)
    return re.sub(r"\s+", " ", normalized).strip()


def course_initials(tokens: list[str]) -> str:
    return "".join(token[0] for token in tokens if token and token not in COURSE_TOKEN_STOPWORDS)


def acronym_matches_with_stopword_initials(acronym: str, target_tokens: list[str]) -> bool:
    if len(acronym) < 3 or len(target_tokens) < 2:
        return False
    stopword_initials = {word[0] for word in COURSE_TOKEN_STOPWORDS if word}
    target_initials = "".join(token[0] for token in target_tokens if token)
    if acronym == target_initials:
        return True
    if acronym[0] != target_initials[0] or acronym[-1] != target_initials[-1]:
        return False
    middle = acronym[1:-1]
    return bool(middle) and all(char in stopword_initials for char in middle)


def compact_acronym_level(token: str) -> tuple[str, str] | None:
    match = re.fullmatch(r"([A-Z]{2,})([0-9IVXL]+)", token)
    if match is None:
        return None
    return match.group(1), match.group(2)


def token_matches_course_acronym(token: str, target_tokens: list[str]) -> bool:
    initials = course_initials(target_tokens)
    if len(token) >= 2 and initials.startswith(token):
        return True
    if acronym_matches_with_stopword_initials(token, target_tokens):
        return True
    compact = compact_acronym_level(token)
    if compact is None:
        return False
    acronym, level = compact
    if not initials.startswith(acronym):
        return False
    target_levels = {variant for target_token in target_tokens for variant in token_variants(target_token)}
    return bool(token_variants(level).intersection(target_levels))


def token_sets_equivalent(left_tokens: list[str], right_tokens: list[str]) -> bool:
    if not left_tokens or not right_tokens:
        return False
    return all(token_is_related(token, right_tokens) for token in left_tokens) and all(token_is_related(token, left_tokens) for token in right_tokens)


def token_level_value(token: str) -> str | None:
    variants = token_variants(token)
    if variants.intersection({"1", "I", "L"}):
        return "1"
    if variants.intersection({"2", "II", "LL"}):
        return "2"
    if variants.intersection({"3", "III"}):
        return "3"
    if variants.intersection({"4", "IV"}):
        return "4"
    if variants.intersection({"5", "V"}):
        return "5"
    return None


def course_level(tokens: list[str]) -> str | None:
    for token in reversed(tokens):
        level = token_level_value(token)
        if level is not None:
            return level
    return None


def course_levels(tokens: list[str]) -> set[str]:
    return {level for token in tokens if (level := token_level_value(token)) is not None}


def tokens_without_levels(tokens: list[str]) -> list[str]:
    return [token for token in tokens if token_level_value(token) is None]


def modifier_tokens(tokens: list[str]) -> list[str]:
    for marker in ("PARA", "EN"):
        if marker not in tokens:
            continue
        marker_index = tokens.index(marker)
        return [token for token in tokens[marker_index + 1 :] if token_level_value(token) is None and token not in COURSE_TOKEN_STOPWORDS]
    return []


def tokens_preserve_modifier(class_tokens: list[str], target_tokens: list[str]) -> bool:
    modifiers = modifier_tokens(class_tokens)
    if not modifiers:
        return True
    target_without_levels = tokens_without_levels(target_tokens)
    return all(token_is_related(token, target_without_levels) for token in modifiers)


def tokens_preserve_specific_base(class_tokens: list[str], target_tokens: list[str]) -> bool:
    if not modifier_tokens(class_tokens):
        return True
    class_without_levels = tokens_without_levels(class_tokens)
    target_without_levels = tokens_without_levels(target_tokens)
    if not class_without_levels or not target_without_levels:
        return True
    return token_sets_equivalent(class_without_levels, target_without_levels)


def target_preserves_class_base(class_tokens: list[str], target_tokens: list[str]) -> bool:
    class_without_levels = tokens_without_levels(class_tokens)
    target_without_levels = tokens_without_levels(target_tokens)
    if not class_without_levels or not target_without_levels:
        return True
    return all(token_is_related(token, target_without_levels) or token_matches_course_acronym(token, target_without_levels) for token in class_without_levels)


def targets_share_base_for_ambiguous_class(class_tokens: list[str], target_tokens: list[str]) -> bool:
    class_without_levels = tokens_without_levels(class_tokens)
    target_without_levels = tokens_without_levels(target_tokens)
    if not class_without_levels or not target_without_levels:
        return False
    if has_extra_prefix_before_class_base(class_tokens, target_tokens):
        return False
    if len(class_without_levels) == 1:
        token = class_without_levels[0]
        return token_matches_course_acronym(token, target_without_levels) or any(token_is_related(token, [target_token]) for target_token in target_without_levels)
    return all(token_is_related(token, target_without_levels) or token_matches_course_acronym(token, target_without_levels) for token in class_without_levels)


def has_extra_prefix_before_class_base(class_tokens: list[str], target_tokens: list[str]) -> bool:
    class_without_levels = tokens_without_levels(class_tokens)
    target_without_levels = tokens_without_levels(target_tokens)
    if not class_without_levels or not target_without_levels:
        return False
    first_class_token = class_without_levels[0]
    for index, target_token in enumerate(target_without_levels):
        if token_is_related(first_class_token, [target_token]):
            return index > 0
    return False


def token_overlap_count(left_tokens: list[str], right_tokens: list[str], allow_acronyms: bool = True) -> int:
    return sum(1 for token in left_tokens if token_is_related(token, right_tokens) or (allow_acronyms and token_matches_course_acronym(token, right_tokens)))


def token_variants(token: str) -> set[str]:
    variants = {token}
    variants.update(LEVEL_EQUIVALENTS.get(token, set()))
    if len(token) > 4 and token.endswith("S"):
        variants.add(token[:-1])
    elif len(token) > 4:
        variants.add(f"{token}S")
    return variants


def token_is_related(token: str, tokens: list[str]) -> bool:
    variants = token_variants(token)
    for candidate in tokens:
        candidate_variants = token_variants(candidate)
        if variants.intersection(candidate_variants):
            return True
        if len(token) >= 5 and len(candidate) >= 5 and fuzz.ratio(token, candidate) >= 88:
            return True
        if len(token) >= 6 and len(candidate) >= 6 and token[0] == candidate[0] and fuzz.ratio(token, candidate) >= 82:
            return True
        if len(token) >= 4 and any(candidate_variant.startswith(token) for candidate_variant in candidate_variants):
            return True
        if any(len(candidate_variant) >= 4 and token.startswith(candidate_variant) for candidate_variant in candidate_variants):
            return True
    return False


def token_is_abbreviation_or_typo_for(token: str, target_token: str) -> bool:
    if len(token) < 4 or len(target_token) < 6 or token == target_token:
        return False
    return target_token.startswith(token) or fuzz.ratio(token, target_token) >= 88


def token_is_distinctive_course_hint(token: str, target_token: str) -> bool:
    return len(token) >= 6 and token == target_token and token not in GENERIC_SINGLE_COURSE_HINTS


def segment_is_course_acronym(segment_tokens: list[str], target_tokens: list[str]) -> bool:
    if len(segment_tokens) != 1:
        return False
    acronym = segment_tokens[0]
    if len(acronym) < 2 or not acronym.isalpha():
        return False
    return acronym == "".join(token[0] for token in target_tokens if token)


def segment_mentions_course(segment_tokens: list[str], target_tokens: list[str]) -> bool:
    if not segment_tokens or not target_tokens:
        return False
    if not tokens_without_levels(segment_tokens):
        return False
    if segment_is_course_acronym(segment_tokens, target_tokens):
        return True
    if len(segment_tokens) == 1 and token_matches_course_acronym(segment_tokens[0], target_tokens):
        return True
    if any(segment_is_course_acronym([token], target_tokens) for token in segment_tokens):
        return True
    if any(token_matches_course_acronym(token, target_tokens) for token in segment_tokens):
        return True
    meaningful_segment_tokens = [token for token in segment_tokens if token not in COURSE_TOKEN_STOPWORDS or len(token) == 1]
    if len(meaningful_segment_tokens) >= 2 and target_tokens:
        first_segment_token = meaningful_segment_tokens[0]
        if (
            len(first_segment_token) == 1
            and first_segment_token == target_tokens[0][0]
            and all(token_is_related(token, target_tokens[1:]) for token in meaningful_segment_tokens[1:])
        ):
            return True
    if any(
        len(token) >= 4
        and any(
            token_is_abbreviation_or_typo_for(token, target_token)
            or token_is_distinctive_course_hint(token, target_token)
            for target_token in target_tokens
        )
        for token in meaningful_segment_tokens
    ):
        return True
    return all(token_is_related(token, target_tokens) for token in segment_tokens)


def class_name_mentions_course(class_name: object, course: dict[str, Any]) -> bool:
    class_tokens = course_tokens(class_name)
    target_tokens = meaningful_course_tokens(course["name"])
    if not class_tokens or not target_tokens:
        return False
    if all(token_is_related(token, class_tokens) for token in target_tokens):
        return True
    return any(segment_mentions_course(segment_tokens, target_tokens) for segment_tokens in class_name_segments(class_name))


def class_name_mentions_course_acronym(class_name: object, course: dict[str, Any]) -> bool:
    target_tokens = meaningful_course_tokens(course["name"])
    return any(segment_is_course_acronym([token], target_tokens) for token in meaningful_course_tokens(class_name))


def related_course_matches_from_class_name(
    class_name: object,
    courses: list[dict[str, Any]],
    *,
    match_scope: str,
    requires_offering_backfill: bool,
    method: str,
    reason: str,
) -> list[dict[str, Any]]:
    matches: list[dict[str, Any]] = []
    class_tokens = meaningful_course_tokens(class_name)
    for course in courses:
        target_tokens = meaningful_course_tokens(course["name"])
        if not target_preserves_class_base(class_tokens, target_tokens):
            continue
        if not class_name_mentions_course(class_name, course):
            continue
        match = course_decision(course, "high", method, reason, match_scope=match_scope, requires_offering_backfill=requires_offering_backfill)
        match["is_primary"] = False
        matches.append(match)
    return matches


def fallback_decision_from_related_matches(matches: list[dict[str, Any]], *, match_scope: str, requires_offering_backfill: bool) -> dict[str, Any] | None:
    if not matches:
        return None
    if len(matches) == 1:
        only_match = dict(matches[0])
        only_match.pop("is_primary", None)
        only_match["method"] = "deterministic_related"
        only_match["reason"] = "Class name clearly names a single course."
        return only_match
    return {
        "course_id": None,
        "course_code": None,
        "course_name": None,
        "match_scope": match_scope,
        "requires_offering_backfill": requires_offering_backfill,
        "confidence": "none",
        "method": "deterministic_ambiguous",
        "reason": "Class name clearly names multiple courses.",
        "related_course_matches": matches,
    }


def courses_without_professor_history(courses: list[dict[str, Any]], professor_courses: list[dict[str, Any]]) -> list[dict[str, Any]]:
    professor_course_ids = {int(course["course_id"]) for course in professor_courses}
    return [course for course in courses if int(course["course_id"]) not in professor_course_ids]


def variation_course_ids_for_class_name(variations: dict[str, dict[str, Any]], class_name: object, professor_id: int) -> set[int]:
    normalized_class = normalize_course_text(class_name)
    if not normalized_class:
        return set()
    course_ids: set[int] = set()
    for raw_course_id, entry in variations.items():
        raw_variations = entry.get("variations")
        if not isinstance(raw_variations, dict) or normalized_class not in raw_variations:
            continue
        variation = raw_variations[normalized_class]
        professor_ids = variation.get("professor_ids") if isinstance(variation, dict) else []
        if professor_id in professor_ids:
            if is_unsupported_variation(normalized_class, entry.get("course_name")):
                continue
            course_id = parse_course_id(raw_course_id)
            if course_id is not None:
                course_ids.add(course_id)
    return course_ids


def is_unsupported_variation(normalized_variation: str, course_name: object) -> bool:
    tokens = meaningful_course_tokens(normalized_variation)
    if len(tokens) != 1:
        return False
    target_tokens = meaningful_course_tokens(course_name)
    token = tokens[0]
    return not token_matches_course_acronym(token, target_tokens) and not token_is_related(token, target_tokens)


def course_contextual_score(
    class_name: object,
    course: dict[str, Any],
    *,
    match_scope: str,
    dominant_prefix_set: set[str],
    variation_course_ids: set[int],
    course_prefix_affinity: dict[int, Counter[str]],
) -> tuple[float, list[str]]:
    normalized_class = normalized_course_name_without_generic_suffix(class_name)
    normalized_name = normalize_course_text(course["name"])
    class_tokens = meaningful_course_tokens(class_name)
    target_tokens = meaningful_course_tokens(course["name"])
    reasons: list[str] = []
    if not normalized_class or not target_tokens:
        return 0, reasons

    score = max(
        fuzz.token_sort_ratio(normalized_class, normalized_name),
        fuzz.partial_ratio(normalized_class, normalized_name) if len(normalized_class) > 5 else 0,
    )
    if normalized_class == normalized_name:
        score = max(score, 100)
        reasons.append("exact normalized name")
    if token_sets_equivalent(class_tokens, target_tokens):
        score = max(score, 100)
        reasons.append("equivalent course tokens")
    if class_name_mentions_course(class_name, course):
        reasons.append("class tokens mention course")
        if class_name_mentions_course_acronym(class_name, course):
            if match_scope == "global_catalog":
                reasons.append("ignored acronym match in global catalog")
            else:
                score = max(score, 95)
                reasons.append("class token matches course acronym")
    
    if len(normalized_class) > 5 and fuzz.partial_ratio(normalized_class, normalized_name) >= 95:
        reasons.append("strong partial name match")
    if class_tokens and tokens_without_levels(class_tokens) and all(token_is_related(token, target_tokens) or (match_scope != "global_catalog" and token_matches_course_acronym(token, target_tokens)) for token in class_tokens):
        score = max(score, 88)
        reasons.append("all class tokens are explained by course name")
    if class_tokens and target_tokens[: len(class_tokens)] and all(token_is_related(token, target_tokens[index:index + 1]) for index, token in enumerate(class_tokens[: len(target_tokens)])):
        score += 8
        reasons.append("class name is a course-name prefix")
    if modifier_tokens(class_tokens):
        if not tokens_preserve_modifier(class_tokens, target_tokens):
            return 0, ["candidate does not preserve class-name modifier"]
        if not tokens_preserve_specific_base(class_tokens, target_tokens):
            if has_extra_prefix_before_class_base(class_tokens, target_tokens):
                score -= 45
                reasons.append("candidate has extra leading base tokens")
            else:
                score -= 10
                reasons.append("candidate has compatible extra descriptor tokens")
        else:
            score += 12
            reasons.append("candidate preserves class-name modifier")
    class_level = course_level(class_tokens)
    target_level = course_level(target_tokens)
    if class_level is not None and target_level is not None:
        if class_level == target_level:
            score += 10
            reasons.append(f"matching level {class_level}")
        else:
            return 0, [f"mismatched level {class_level} vs {target_level}"]
    if parse_course_id(course.get("course_id")) in variation_course_ids:
        score = max(score, 118)
        reasons.append("learned professor variation")
    text_signal_reasons = {
        "exact normalized name",
        "equivalent course tokens",
        "all class tokens are explained by course name",
        "class name is a course-name prefix",
        "class token matches course acronym",
        "learned professor variation",
    }
    has_text_signal = any(reason in text_signal_reasons or reason.startswith("matching level ") for reason in reasons)
    if not has_text_signal:
        return 0, reasons
    prefix = course_prefix(course)
    if prefix in dominant_prefix_set:
        score += 10 if match_scope == "global_catalog" else 5
        reasons.append(f"dominant prefix {prefix}")
    affinity_boost, affinity_reasons = course_prefix_affinity_score(course, dominant_prefix_set=dominant_prefix_set, course_prefix_affinity=course_prefix_affinity)
    if affinity_boost:
        score += affinity_boost
        reasons.extend(affinity_reasons)
    if match_scope == "professor_history":
        score += 8
        reasons.append("professor history")
    if course.get("has_offerings"):
        score += 10
        reasons.append("has active offerings")
    if normalized_name in GENERIC_GLOBAL_COURSE_NAMES and match_scope == "global_catalog":
        score -= 25
        reasons.append("generic global name penalty")
    return score, reasons


def contextual_course_match(
    class_name: object,
    courses: list[dict[str, Any]],
    *,
    match_scope: str,
    requires_offering_backfill: bool,
    dominant_prefix_set: set[str],
    variation_course_ids: set[int],
    course_prefix_affinity: dict[int, Counter[str]],
    minimum_score: float,
    minimum_gap: float,
) -> dict[str, Any] | None:
    scored: list[tuple[float, dict[str, Any], list[str]]] = []
    for course in courses:
        score, reasons = course_contextual_score(
            class_name,
            course,
            match_scope=match_scope,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        )
        if score >= 60:
            scored.append((score, course, reasons))
    if not scored:
        return None
    scored.sort(key=lambda item: (item[0], course_prefix(item[1]), str(item[1]["code"])), reverse=True)
    best_score, best_course, best_reasons = scored[0]
    second_score = scored[1][0] if len(scored) > 1 else 0
    if best_score < minimum_score or best_score - second_score < minimum_gap:
        return None
    decision = course_decision(
        best_course,
        "high",
        "contextual_deterministic",
        f"Contextual score {best_score:.1f} vs {second_score:.1f}: {', '.join(best_reasons)}.",
        match_scope=match_scope,
        requires_offering_backfill=requires_offering_backfill,
    )
    return decision


def segment_course_match(
    segment_tokens: list[str],
    courses: list[dict[str, Any]],
    *,
    match_scope: str,
    requires_offering_backfill: bool,
    dominant_prefix_set: set[str],
    variation_course_ids: set[int],
    course_prefix_affinity: dict[int, Counter[str]],
    preferred_course_ids: set[int],
) -> dict[str, Any] | None:
    segment = segment_text(segment_tokens)
    segment_levels = course_levels(segment_tokens)
    scored: list[tuple[float, dict[str, Any], list[str]]] = []
    for course in courses:
        target_tokens = meaningful_course_tokens(course["name"])
        target_level = course_level(target_tokens)
        if segment_levels and target_level is not None and target_level not in segment_levels:
            continue
        score, reasons = course_contextual_score(
            segment,
            course,
            match_scope=match_scope,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=set(),
            course_prefix_affinity=course_prefix_affinity,
        )
        if parse_course_id(course.get("course_id")) in preferred_course_ids:
            score += 14
            reasons.append("professor history segment preference")
        if score >= 82:
            scored.append((score, course, reasons))
    if not scored:
        return None
    scored.sort(key=lambda item: (item[0], course_prefix(item[1]), str(item[1]["code"])), reverse=True)
    best_score, best_course, best_reasons = scored[0]
    second_score = scored[1][0] if len(scored) > 1 else 0
    if best_score < 92 or best_score - second_score < 3:
        return None
    return course_decision(
        best_course,
        "high",
        "segment_deterministic",
        f"Segment '{segment}' matched with contextual score {best_score:.1f} vs {second_score:.1f}: {', '.join(best_reasons)}.",
        match_scope=match_scope,
        requires_offering_backfill=requires_offering_backfill,
    )


def explicit_segment_course_matches(
    class_name: object,
    courses: list[dict[str, Any]],
    *,
    match_scope: str,
    requires_offering_backfill: bool,
    dominant_prefix_set: set[str],
    variation_course_ids: set[int],
    course_prefix_affinity: dict[int, Counter[str]],
    preferred_course_ids: set[int] | None = None,
) -> dict[str, Any] | None:
    if not has_explicit_course_separator(class_name):
        return None
    normalized_class = normalize_course_text(class_name)
    if any(normalize_course_text(course.get("name")) == normalized_class for course in courses):
        return None
    matches: list[dict[str, Any]] = []
    seen_course_ids: set[int] = set()
    preferred_ids = preferred_course_ids or set()
    for segment_tokens in contextual_segments(class_name):
        match = segment_course_match(
            segment_tokens,
            courses,
            match_scope=match_scope,
            requires_offering_backfill=requires_offering_backfill,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
            preferred_course_ids=preferred_ids,
        )
        if match is None:
            continue
        course_id = parse_course_id(match.get("course_id"))
        if course_id is None or course_id in seen_course_ids:
            continue
        match["is_primary"] = False
        matches.append(match)
        seen_course_ids.add(course_id)
    if len(matches) < 2:
        return None
    return {
        "course_id": None,
        "course_code": None,
        "course_name": None,
        "match_scope": match_scope,
        "requires_offering_backfill": any(match["requires_offering_backfill"] for match in matches),
        "confidence": "none",
        "method": "segment_deterministic",
        "reason": "Class name contains explicit course segments that matched multiple courses.",
        "related_course_matches": matches,
    }


def contextual_related_course_matches(
    class_name: object,
    courses: list[dict[str, Any]],
    *,
    match_scope: str,
    requires_offering_backfill: bool,
    dominant_prefix_set: set[str],
    variation_course_ids: set[int],
    course_prefix_affinity: dict[int, Counter[str]],
) -> dict[str, Any] | None:
    class_tokens = meaningful_course_tokens(class_name)
    if not class_tokens:
        return None
    class_level_set = course_levels(class_tokens)
    class_base_tokens = tokens_without_levels(class_tokens)
    scored: list[tuple[float, dict[str, Any], list[str]]] = []
    for course in courses:
        prefix = course_prefix(course)
        if dominant_prefix_set and prefix not in dominant_prefix_set and parse_course_id(course.get("course_id")) not in variation_course_ids:
            continue
        target_tokens = meaningful_course_tokens(course["name"])
        target_level = course_level(target_tokens)
        target_base_tokens = tokens_without_levels(target_tokens)
        if not targets_share_base_for_ambiguous_class(class_tokens, target_tokens):
            continue
        score, reasons = course_contextual_score(
            class_name,
            course,
            match_scope=match_scope,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        )
        base_overlap = token_overlap_count(class_base_tokens, target_base_tokens, allow_acronyms=match_scope != "global_catalog")
        if class_level_set:
            if target_level in class_level_set and base_overlap >= 1:
                score = max(score, 95)
                reasons.append(f"requested level {target_level}")
            elif target_level is None and base_overlap >= 2 and normalize_course_text(course["name"]) not in GENERIC_GLOBAL_COURSE_NAMES:
                score = max(score, 95)
                reasons.append("additional non-leveled contextual course")
            elif score < 108:
                continue
        elif target_level is not None and base_overlap >= max(1, min(2, len(class_base_tokens))):
            score = max(score, 92)
            reasons.append("ambiguous base course with level")
        if score >= 92:
            scored.append((score, course, reasons))
    if len(scored) < 2:
        return None
    scored.sort(key=lambda item: (item[0], str(item[1]["code"])), reverse=True)
    if class_level_set:
        wanted_levels = set(class_level_set)
        selected: list[tuple[float, dict[str, Any], list[str]]] = []
        seen_levels: set[str] = set()
        for item in scored:
            level = course_level(meaningful_course_tokens(item[1]["name"]))
            if level in wanted_levels and level not in seen_levels:
                selected.append(item)
                seen_levels.add(level)
        selected.extend(item for item in scored if item not in selected and course_level(meaningful_course_tokens(item[1]["name"])) is None and item[0] >= 92)
    else:
        selected = [item for item in scored if course_level(meaningful_course_tokens(item[1]["name"])) is not None]
        if not selected:
            selected = scored[:3]
    if len(selected) < 2:
        return None
    matches: list[dict[str, Any]] = []
    seen_course_ids: set[int] = set()
    for score, course, reasons in selected:
        course_id = int(course["course_id"])
        if course_id in seen_course_ids:
            continue
        seen_course_ids.add(course_id)
        match = course_decision(
            course,
            "high",
            "contextual_related",
            f"Contextual related score {score:.1f}: {', '.join(reasons)}.",
            match_scope=match_scope,
            requires_offering_backfill=requires_offering_backfill,
        )
        match["is_primary"] = False
        matches.append(match)
    if len(matches) < 2:
        return None
    return {
        "course_id": None,
        "course_code": None,
        "course_name": None,
        "match_scope": match_scope,
        "requires_offering_backfill": requires_offering_backfill,
        "confidence": "none",
        "method": "contextual_related",
        "reason": "Class name maps to multiple contextual courses.",
        "related_course_matches": matches,
    }


def ambiguous_course_matches_from_class_name(class_name: object, courses: list[dict[str, Any]], *, match_scope: str, requires_offering_backfill: bool) -> dict[str, Any] | None:
    if not course_tokens(class_name):
        return None
    has_explicit_separators = has_explicit_course_separator(class_name)
    class_tokens = meaningful_course_tokens(class_name)
    related_matches: list[dict[str, Any]] = []
    for course in courses:
        target_tokens = meaningful_course_tokens(course["name"])
        if not target_preserves_class_base(class_tokens, target_tokens):
            continue
        if not class_name_mentions_course(class_name, course):
            continue
        confidence = "high" if has_explicit_separators else "low"
        reason = "Class name clearly names multiple courses." if has_explicit_separators else "Class name is generic and matches multiple historical courses."
        match = course_decision(course, confidence, "deterministic_ambiguous", reason, match_scope=match_scope, requires_offering_backfill=requires_offering_backfill)
        match["is_primary"] = False
        related_matches.append(match)
    if len(related_matches) < 2:
        return None
    return {
        "course_id": None,
        "course_code": None,
        "course_name": None,
        "match_scope": match_scope,
        "requires_offering_backfill": any(match["requires_offering_backfill"] for match in related_matches),
        "confidence": "none",
        "method": "deterministic_ambiguous",
        "reason": related_matches[0]["reason"],
        "related_course_matches": related_matches,
    }


def deterministic_course_match(class_name: object, courses: list[dict[str, Any]], *, match_scope: str, requires_offering_backfill: bool, allow_ambiguous: bool = True) -> dict[str, Any] | None:
    normalized_class = normalize_course_text(class_name)
    if not normalized_class or normalized_class == "---":
        return {"course_id": None, "course_code": None, "course_name": None, "match_scope": match_scope, "requires_offering_backfill": False, "confidence": "none", "method": "deterministic", "reason": "Missing or unusable class name."}
    if not courses:
        return None

    by_name: dict[str, list[dict[str, Any]]] = {}
    for course in courses:
        by_name.setdefault(normalize_course_text(course["name"]), []).append(course)
    exact = by_name.get(normalized_class, [])
    if len(exact) == 1:
        return course_decision(exact[0], "high", "deterministic", "Exact normalized course name match.", match_scope=match_scope, requires_offering_backfill=requires_offering_backfill)
    if len(exact) > 1 and allow_ambiguous and not (match_scope == "global_catalog" and normalized_class in GENERIC_GLOBAL_COURSE_NAMES):
        matches = [course_decision(course, "high", "deterministic_ambiguous", "Exact class name matches multiple courses.", match_scope=match_scope, requires_offering_backfill=requires_offering_backfill) for course in exact]
        for match in matches:
            match["is_primary"] = False
        return {"course_id": None, "course_code": None, "course_name": None, "match_scope": match_scope, "requires_offering_backfill": requires_offering_backfill, "confidence": "none", "method": "deterministic_ambiguous", "reason": "Exact class name matches multiple courses.", "related_course_matches": matches}
    if len(exact) > 1:
        return None

    if match_scope == "professor_history" and allow_ambiguous:
        ambiguous = ambiguous_course_matches_from_class_name(class_name, courses, match_scope=match_scope, requires_offering_backfill=requires_offering_backfill)
        if ambiguous is not None:
            return ambiguous

    class_level_set = course_levels(meaningful_course_tokens(class_name))
    if class_level_set:
        choices = []
        for name, name_courses in by_name.items():
            name_levels = {level for course in name_courses if (level := course_level(meaningful_course_tokens(course.get("name")))) is not None}
            if not name_levels or name_levels.intersection(class_level_set):
                choices.append(name)
    else:
        choices = list(by_name)
    fuzzy_matches = process.extract(normalized_class, choices, scorer=fuzz.token_sort_ratio, limit=2)
    if not fuzzy_matches:
        return None
    best_name, score, _ = fuzzy_matches[0]
    second_score = fuzzy_matches[1][1] if len(fuzzy_matches) > 1 else 0
    if score >= 96 and score - second_score >= 3 and len(by_name[best_name]) == 1:
        best_course = by_name[best_name][0]
        class_levels = course_levels(meaningful_course_tokens(class_name))
        best_level = course_level(meaningful_course_tokens(best_course.get("name")))
        if not class_levels and best_level is not None and normalize_course_text(class_name) != normalize_course_text(best_course.get("name")):
            return None
        return course_decision(best_course, "high", "deterministic", f"Very high fuzzy match ({score:.1f}) with clear separation from second candidate ({second_score:.1f}).", match_scope=match_scope, requires_offering_backfill=requires_offering_backfill)
    if score >= 96 and score - second_score >= 5 and len(by_name[best_name]) > 1 and allow_ambiguous:
        matches = [course_decision(course, "high", "deterministic_ambiguous", f"Very high fuzzy match ({score:.1f}) to multiple courses with the same normalized name.", match_scope=match_scope, requires_offering_backfill=requires_offering_backfill) for course in by_name[best_name]]
        for match in matches:
            match["is_primary"] = False
        return {"course_id": None, "course_code": None, "course_name": None, "match_scope": match_scope, "requires_offering_backfill": requires_offering_backfill, "confidence": "none", "method": "deterministic_ambiguous", "reason": f"Very high fuzzy match ({score:.1f}) to multiple courses with the same normalized name.", "related_course_matches": matches}
    return None


def select_global_course_candidates(class_name: object, *, professor_courses: list[dict[str, Any]], all_courses: list[dict[str, Any]], dominant_prefix_set: set[str], course_prefix_affinity: dict[int, Counter[str]], limit: int = 30) -> list[dict[str, Any]]:
    normalized_class = normalize_course_text(class_name)
    if not normalized_class or normalized_class == "---":
        return []
    professor_course_ids = {int(course["course_id"]) for course in professor_courses}
    class_tokens = meaningful_course_tokens(class_name)
    candidates: list[tuple[float, dict[str, Any]]] = []
    for course in all_courses:
        course_id = int(course["course_id"])
        if course_id in professor_course_ids:
            continue
        target_tokens = meaningful_course_tokens(course["name"])
        if modifier_tokens(class_tokens) and not tokens_preserve_modifier(class_tokens, target_tokens):
            continue
        normalized_course = normalize_course_text(course["name"])
        score = max(fuzz.token_sort_ratio(normalized_class, normalized_course), fuzz.partial_ratio(normalized_class, normalized_course))
        if class_name_mentions_course(class_name, course):
            score = max(score, 95)
        if course_prefix(course) in dominant_prefix_set:
            score += 12
        affinity_boost, _ = course_prefix_affinity_score(course, dominant_prefix_set=dominant_prefix_set, course_prefix_affinity=course_prefix_affinity)
        score += affinity_boost
        if score >= 60:
            candidates.append((float(score), course))
    candidates.sort(key=lambda item: (item[0], str(item[1]["code"])), reverse=True)
    return [course for _, course in candidates[:limit]]


def split_primary_and_related_course_matches(course_match: dict[str, Any]) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    related = course_match.get("related_course_matches")
    related_matches = [dict(item) for item in related if isinstance(item, dict)] if isinstance(related, list) else []
    primary_match = {key: value for key, value in course_match.items() if key != "related_course_matches"}
    course_matches: list[dict[str, Any]] = []
    seen_course_ids: set[int] = set()
    primary_course_id = parse_course_id(primary_match.get("course_id"))
    if primary_course_id is not None:
        primary_with_role = dict(primary_match)
        primary_with_role["is_primary"] = True
        course_matches.append(primary_with_role)
        seen_course_ids.add(primary_course_id)
    for related_match in related_matches:
        course_id = parse_course_id(related_match.get("course_id"))
        if course_id is None or course_id in seen_course_ids:
            continue
        related_match["is_primary"] = False
        course_matches.append(related_match)
        seen_course_ids.add(course_id)

    # Filter out global_catalog if any professor_history match exists
    if len(course_matches) > 1 and not primary_course_id:
        has_history = any(m.get("match_scope") == "professor_history" for m in course_matches)
        if has_history:
            course_matches = [m for m in course_matches if m.get("match_scope") == "professor_history"]

    return primary_match, course_matches


def format_course_output(decision: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": decision.get("course_id"),
        "code": decision.get("course_code"),
        "name": decision.get("course_name"),
        "match_scope": decision.get("match_scope"),
        "requires_offering_backfill": decision.get("requires_offering_backfill"),
        "confidence": decision.get("confidence"),
        "method": decision.get("method"),
        "reason": decision.get("reason"),
        **({"prompt_version": decision["prompt_version"]} if "prompt_version" in decision else {}),
        **({"recognized_variation": decision["recognized_variation"]} if "recognized_variation" in decision else {}),
        **({"is_primary": decision["is_primary"]} if "is_primary" in decision else {}),
    }


def parse_json_content(content: str) -> dict[str, Any]:
    cleaned = content.strip()
    if cleaned.startswith("```"):
        cleaned = re.sub(r"^```(?:json)?", "", cleaned).strip()
        cleaned = re.sub(r"```$", "", cleaned).strip()
    data = json.loads(cleaned)
    if not isinstance(data, dict):
        raise ValueError("Model response is not a JSON object")
    return data


def call_openrouter_for_course(*, api_key: str, model: str, professor_id: int, class_name: object, comment: str, raw_tags: list[Any], course_options: list[dict[str, Any]]) -> dict[str, Any]:
    prompt = {
        "task": "Match a raw professor review class name to course_options.",
        "rules": [
            "Only choose course IDs that appear in course_options.",
            "Prefer professor_history options when plausible.",
            "global_catalog options are allowed for old reviews and require offering backfill later.",
            "Accept abbreviations, acronyms, typos, missing accents, shortened names, and slash-separated multi-course names.",
            "If no primary course is clear but class_name clearly names multiple courses, return primary_course_id null and include every clearly named course in related_course_ids.",
            "For explicit separators such as '/', ',', '-', or 'y', resolve each course segment independently.",
            "Respect levels: 'Contabilidad II' means level II only; do not include Contabilidad I or III unless the class_name explicitly mentions them.",
            "For generic names without level such as 'Contabilidad', prefer courses from professor_history that share the exact base name and exclude variants such as Contabilidad Básica, Contabilidad de Costos, or Contabilidad Financiera unless the class_name says those words.",
            "Prefer options marked with dominant_prefix_match or prefix_affinity unless class_name explicitly points to another prefix.",
            "If class_name has modifier_tokens, do not choose options that omit those modifier tokens.",
            "If class_name has modifier_tokens and levels, keep the same modifier while resolving every requested level.",
            "Do not return multiple homonyms with the same name; choose the best contextual homonym or return none.",
            "Translate common English acronyms to their Spanish equivalents (e.g., DB to Bases de Datos, OS to Sistemas Operativos).",
            "Do not include vague or merely similar courses.",
        ],
        "response_schema": {
            "primary_course_id": "integer or null",
            "related_course_ids": "array of integer course ids, excluding primary_course_id when there is one",
            "confidence": "high | medium | low | none",
            "recognized_variation": "string or null",
            "reason": "short Spanish explanation",
        },
        "professor_id": professor_id,
        "class_name": class_name,
        "modifier_tokens": modifier_tokens(meaningful_course_tokens(class_name)),
        "requested_levels": sorted(course_levels(meaningful_course_tokens(class_name))),
        "comment": comment,
        "raw_tags": raw_tags,
        "course_options": course_options,
    }
    models_list = [m.strip() for m in model.split(",") if m.strip()] or [model]
    timeout_seconds = float(os.getenv("OPENROUTER_TIMEOUT_SECONDS", "20"))
    configured_attempts = int(os.getenv("OPENROUTER_ATTEMPTS", "0") or "0")
    attempts = max(configured_attempts, len(models_list), 1)

    parsed = None
    last_error = None
    for attempt in range(attempts):
        current_model = models_list[attempt % len(models_list)]
        payload = {
            "model": current_model,
            "messages": [
                {"role": "system", "content": "You are a strict data-normalization assistant. Return only valid JSON, with no markdown."},
                {"role": "user", "content": json.dumps(prompt, ensure_ascii=False)}
            ],
            "temperature": 0
        }
        try:
            response = requests.post(
                OPENROUTER_URL,
                headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
                json=payload,
                timeout=timeout_seconds,
            )
            response.raise_for_status()
            parsed = parse_json_content(response.json()["choices"][0]["message"]["content"])
            break
        except Exception as e:
            last_error = e
            
    if parsed is None:
        raise last_error or Exception("All OpenRouter attempts failed.")
    course_id = parse_course_id(parsed.get("primary_course_id", parsed.get("course_id")))
    confidence = str(parsed.get("confidence") or "medium")
    if confidence not in {"high", "medium", "low", "none"}:
        confidence = "medium"

    related_course_matches: list[dict[str, Any]] = []
    raw_related_course_ids = parsed.get("related_course_ids")
    if isinstance(raw_related_course_ids, list):
        seen_related_course_ids: set[int] = set()
        for raw_related_course_id in raw_related_course_ids:
            related_course_id = parse_course_id(raw_related_course_id)
            if related_course_id is None or related_course_id == course_id or related_course_id in seen_related_course_ids:
                continue
            seen_related_course_ids.add(related_course_id)
            related_course = next((course for course in course_options if int(course["course_id"]) == related_course_id), None)
            if related_course is None:
                continue
            related_decision = course_decision(related_course, confidence, "openrouter", str(parsed.get("reason") or "Model matched related course."), match_scope=str(related_course.get("match_scope") or "professor_history"), requires_offering_backfill=bool(related_course.get("requires_offering_backfill")))
            related_decision["prompt_version"] = COURSE_MATCH_PROMPT_VERSION
            related_decision["recognized_variation"] = parsed.get("recognized_variation")
            related_decision["is_primary"] = False
            related_course_matches.append(related_decision)
    if course_id is None:
        return {"course_id": None, "course_code": None, "course_name": None, "match_scope": None, "requires_offering_backfill": False, "confidence": parsed.get("confidence") or "none", "method": "openrouter", "prompt_version": COURSE_MATCH_PROMPT_VERSION, "recognized_variation": parsed.get("recognized_variation"), "reason": parsed.get("reason") or "Model returned no course.", "related_course_matches": related_course_matches}
    matching_course = next((course for course in course_options if int(course["course_id"]) == course_id), None)
    if matching_course is None:
        return {"course_id": None, "course_code": None, "course_name": None, "match_scope": None, "requires_offering_backfill": False, "confidence": "none", "method": "openrouter", "prompt_version": COURSE_MATCH_PROMPT_VERSION, "recognized_variation": parsed.get("recognized_variation"), "reason": f"Model returned course_id {course_id}, which is not in the allowed options."}
    decision = course_decision(matching_course, confidence, "openrouter", str(parsed.get("reason") or "Model matched course."), match_scope=str(matching_course.get("match_scope") or "professor_history"), requires_offering_backfill=bool(matching_course.get("requires_offering_backfill")))
    decision["prompt_version"] = COURSE_MATCH_PROMPT_VERSION
    decision["recognized_variation"] = parsed.get("recognized_variation")
    decision["related_course_matches"] = related_course_matches
    return decision


def course_options_for_family(*, class_name: object, professor_courses: list[dict[str, Any]], all_courses: list[dict[str, Any]], dominant_prefix_set: set[str], variation_course_ids: set[int], course_prefix_affinity: dict[int, Counter[str]]) -> list[dict[str, Any]]:
    professor_course_ids = {int(course["course_id"]) for course in professor_courses}
    by_id: dict[int, dict[str, Any]] = {}
    candidate_courses = [
        *family_candidate_courses(
            class_name,
            professor_courses,
            match_scope="professor_history",
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        ),
        *family_candidate_courses(
            class_name,
            all_courses,
            match_scope="global_catalog",
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        ),
    ]
    for course in candidate_courses:
        course_id = int(course["course_id"])
        by_id[course_id] = {
            "course_id": course_id,
            "code": str(course["code"]),
            "name": str(course["name"]),
            "base_signature": course_base_signature(course),
            "level": course_level(meaningful_course_tokens(course.get("name"))),
            "match_scope": "professor_history" if course_id in professor_course_ids else "global_catalog",
            "requires_offering_backfill": course_id not in professor_course_ids,
            "dominant_prefix_match": course_prefix(course) in dominant_prefix_set,
            "prefix_affinity": dict(course_prefix_affinity.get(course_id, Counter())),
        }
    return sorted(by_id.values(), key=lambda item: str(item["code"]))


def call_openrouter_for_course_family(*, api_key: str, model: str, professor_id: int, family: str, class_name: object, comment: str, raw_tags: list[Any], course_options: list[dict[str, Any]]) -> dict[str, Any]:
    prompt = {
        "task": "Resolve an ambiguous course family for one professor. Choose the course id(s) that future similar reviews for this same professor should prefer.",
        "rules": [
            "Only choose course IDs from course_options.",
            "This is scoped to this professor only; do not make a global rule.",
            "Use the raw class_name and comment as evidence, but also compare exact course titles, prefixes, and historical context.",
            "Do not blindly prefer professor_history if a global_catalog course title is a more exact semantic match.",
            "Do not blindly prefer exact text if there are several homonyms/equivalent courses with different prefixes.",
            "If class_name has an explicit level/number/roman numeral, choose only options with that requested level unless a non-leveled course is clearly the exact intended course.",
            "If class_name has no level and options contain multiple leveled variants of the same base course, you may return multiple related course ids when the review cannot distinguish the level.",
            "If you return leveled variants of a base course, do not also return a non-leveled generic course with the same base unless it is clearly a separate offered course.",
            "For short aliases, choose the family decision implied by stronger explicit variants when possible.",
            "Return confidence high only when the choice should be reused for similar reviews of this professor.",
            "Translate common English acronyms to their Spanish equivalents (e.g., DB to Bases de Datos, OS to Sistemas Operativos).",
        ],
        "response_schema": {
            "preferred_course_ids": "array of integer course ids",
            "confidence": "high | medium | low | none",
            "recognized_family": "string",
            "reason": "short Spanish explanation",
        },
        "professor_id": professor_id,
        "family": family,
        "class_name": class_name,
        "comment": comment,
        "raw_tags": raw_tags,
        "course_options": course_options,
    }
    models_list = [m.strip() for m in model.split(",") if m.strip()] or [model]
    timeout_seconds = float(os.getenv("OPENROUTER_TIMEOUT_SECONDS", "20"))
    configured_attempts = int(os.getenv("OPENROUTER_ATTEMPTS", "0") or "0")
    attempts = max(configured_attempts, len(models_list), 1)

    parsed = None
    last_error = None
    for attempt in range(attempts):
        current_model = models_list[attempt % len(models_list)]
        payload = {
            "model": current_model,
            "messages": [
                {"role": "system", "content": "You are a strict data-normalization assistant. Return only valid JSON, with no markdown."},
                {"role": "user", "content": json.dumps(prompt, ensure_ascii=False)}
            ],
            "temperature": 0
        }
        try:
            response = requests.post(
                OPENROUTER_URL,
                headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
                json=payload,
                timeout=timeout_seconds,
            )
            response.raise_for_status()
            parsed = parse_json_content(response.json()["choices"][0]["message"]["content"])
            break
        except Exception as e:
            last_error = e
            
    if parsed is None:
        raise last_error or Exception("All OpenRouter attempts failed.")
    raw_ids = parsed.get("preferred_course_ids")
    preferred_ids = [course_id for value in raw_ids for course_id in [parse_course_id(value)] if course_id is not None] if isinstance(raw_ids, list) else []
    allowed_ids = {int(course["course_id"]) for course in course_options}
    preferred_ids = [course_id for course_id in preferred_ids if course_id in allowed_ids]
    confidence = str(parsed.get("confidence") or "none")
    if confidence not in {"high", "medium", "low", "none"}:
        confidence = "none"
    return {
        "family": family,
        "preferred_course_ids": preferred_ids,
        "confidence": confidence,
        "method": "openrouter_family",
        "prompt_version": COURSE_FAMILY_PROMPT_VERSION,
        "recognized_variation": parsed.get("recognized_family") or family,
        "reason": parsed.get("reason") or "LLM resolved ambiguous course family.",
    }


def filtered_family_preferred_ids(class_name: object, preferred_ids: list[int], course_options: list[dict[str, Any]]) -> list[int]:
    if not preferred_ids:
        return []
    class_levels = course_levels(meaningful_course_tokens(class_name))
    by_id = {int(course["course_id"]): course for course in course_options}
    filtered = [course_id for course_id in preferred_ids if course_id in by_id]
    if class_levels:
        level_filtered = [course_id for course_id in filtered if by_id[course_id].get("level") in class_levels or by_id[course_id].get("level") is None]
        if level_filtered:
            filtered = level_filtered
        dominant_level_filtered = [course_id for course_id in filtered if by_id[course_id].get("level") in class_levels and by_id[course_id].get("dominant_prefix_match")]
        if dominant_level_filtered:
            filtered = dominant_level_filtered
    else:
        selected_base_signatures = {str(by_id[course_id].get("base_signature") or "") for course_id in filtered if by_id[course_id].get("level") is not None}
        if selected_base_signatures:
            without_generic_same_base = [course_id for course_id in filtered if by_id[course_id].get("level") is not None or str(by_id[course_id].get("base_signature") or "") not in selected_base_signatures]
            if without_generic_same_base:
                filtered = without_generic_same_base
    deduped: list[int] = []
    for course_id in filtered:
        if course_id not in deduped:
            deduped.append(course_id)
    return deduped


def decision_from_family_resolution(resolution: dict[str, Any], course_options: list[dict[str, Any]], *, class_name: object) -> dict[str, Any] | None:
    preferred_ids = [course_id for value in resolution.get("preferred_course_ids") or [] for course_id in [parse_course_id(value)] if course_id is not None]
    preferred_ids = filtered_family_preferred_ids(class_name, preferred_ids, course_options)
    if not preferred_ids or resolution.get("confidence") == "none":
        return None
    by_id = {int(course["course_id"]): course for course in course_options}
    matches: list[dict[str, Any]] = []
    for index, course_id in enumerate(preferred_ids):
        course = by_id.get(course_id)
        if course is None:
            continue
        decision = course_decision(
            course,
            str(resolution.get("confidence") or "medium"),
            "openrouter_family",
            str(resolution.get("reason") or "LLM resolved ambiguous course family."),
            match_scope=str(course.get("match_scope") or "global_catalog"),
            requires_offering_backfill=bool(course.get("requires_offering_backfill")),
        )
        decision["prompt_version"] = COURSE_FAMILY_PROMPT_VERSION
        decision["recognized_variation"] = resolution.get("recognized_variation")
        decision["is_primary"] = index == 0 if len(preferred_ids) > 1 else True
        matches.append(decision)
    if not matches:
        return None
    if len(matches) == 1:
        matches[0].pop("is_primary", None)
        return matches[0]
    primary = next((match for match in matches if match.get("is_primary")), matches[0])
    return {
        **primary,
        "related_course_matches": [match for match in matches if match is not primary],
    }


def should_reuse_cached_decision(decision: dict[str, Any], *, use_openrouter: bool, api_key: str | None) -> bool:
    if decision.get("method") == "openrouter" and decision.get("prompt_version") != COURSE_MATCH_PROMPT_VERSION:
        return False
    if decision.get("method") == "openrouter_family" and decision.get("prompt_version") != COURSE_FAMILY_PROMPT_VERSION:
        return False
    if decision.get("course_id") is not None:
        return True
    if decision.get("method") in TRANSIENT_UNMATCHED_METHODS and use_openrouter and api_key:
        return False
    return True


def should_refresh_cached_decision(decision: dict[str, Any], class_name: object) -> bool:
    if has_explicit_course_separator(class_name) and decision.get("method") != "segment_deterministic":
        return True
    if has_explicit_course_separator(class_name) and decision.get("course_id") is not None and not decision.get("related_course_matches"):
        return True
    if is_generic_variation(class_name) and decision.get("match_scope") == "global_catalog":
        return True
    if decision.get("method") == "deterministic_ambiguous" and decision.get("match_scope") == "global_catalog":
        return True
    if "learned professor variation" in str(decision.get("reason") or "") and is_unsupported_variation(normalize_course_text(class_name), decision.get("course_name")):
        return True
    class_tokens = meaningful_course_tokens(class_name)
    if modifier_tokens(class_tokens):
        primary_course_name = decision.get("course_name")
        if primary_course_name is not None and not tokens_preserve_specific_base(class_tokens, meaningful_course_tokens(primary_course_name)):
            return True
        for related in decision.get("related_course_matches") or []:
            if isinstance(related, dict) and not tokens_preserve_specific_base(class_tokens, meaningful_course_tokens(related.get("course_name"))):
                return True
    if len(decision.get("related_course_matches") or []) > 6:
        return True
    if decision.get("method") == "openrouter" and CONFIDENCE_ORDER.get(str(decision.get("confidence") or "none"), 0) < CONFIDENCE_ORDER["high"]:
        return True
    return False


def should_persist_decision(decision: dict[str, Any]) -> bool:
    return decision.get("course_id") is not None or decision.get("method") not in TRANSIENT_UNMATCHED_METHODS


def is_generic_variation(value: object) -> bool:
    tokens = meaningful_course_tokens(value)
    if not tokens:
        return True
    if has_explicit_course_separator(value):
        return True
    if course_levels(tokens):
        return False
    normalized = normalize_course_text(value)
    if normalized in GENERIC_GLOBAL_COURSE_NAMES:
        return True
    return len(tokens) == 1 and tokens[0] in GENERIC_SINGLE_COURSE_HINTS


def add_course_variation(variations: dict[str, dict[str, Any]], *, professor_id: int, class_name: object, decision: dict[str, Any]) -> None:
    course_id = decision.get("course_id")
    raw_class_name = str(class_name or "").strip()
    recognized_variation = str(decision.get("recognized_variation") or "").strip()
    variation_source = recognized_variation or raw_class_name
    normalized_class_name = normalize_course_text(variation_source)
    if course_id is None or not variation_source or not normalized_class_name or normalized_class_name == "---":
        return
    if is_generic_variation(variation_source):
        return
    if is_unsupported_variation(normalized_class_name, decision.get("course_name")):
        return
    if normalized_class_name == normalize_course_text(decision.get("course_name")):
        return
    entry = variations.setdefault(str(course_id), {"course_id": int(course_id), "course_code": decision.get("course_code"), "course_name": decision.get("course_name"), "variations": {}})
    variation = entry.setdefault("variations", {}).setdefault(normalized_class_name, {"raw_examples": [], "professor_ids": [], "count": 0, "last_method": decision.get("method"), "last_confidence": decision.get("confidence"), "last_reason": decision.get("reason")})
    variation["count"] = int(variation.get("count", 0)) + 1
    if raw_class_name and raw_class_name not in variation["raw_examples"]:
        variation["raw_examples"].append(raw_class_name)
    if recognized_variation and recognized_variation not in variation["raw_examples"]:
        variation["raw_examples"].append(recognized_variation)
    if professor_id not in variation["professor_ids"]:
        variation["professor_ids"].append(professor_id)
    variation["last_method"] = decision.get("method")
    variation["last_confidence"] = decision.get("confidence")
    variation["last_reason"] = decision.get("reason")


def add_course_variations_for_match(variations: dict[str, dict[str, Any]], *, professor_id: int, class_name: object, decision: dict[str, Any]) -> None:
    _, course_matches = split_primary_and_related_course_matches(decision)
    if not course_matches:
        add_course_variation(variations, professor_id=professor_id, class_name=class_name, decision=decision)
        return
    if len(course_matches) > 1:
        return
    for course_match in course_matches:
        add_course_variation(variations, professor_id=professor_id, class_name=class_name, decision=course_match)


def add_comment_alias_variations_for_match(
    variations: dict[str, dict[str, Any]],
    *,
    professor_id: int,
    review: dict[str, Any],
    decision: dict[str, Any],
) -> None:
    _, course_matches = split_primary_and_related_course_matches(decision)
    accepted_matches = [match for match in course_matches if match.get("course_id") is not None and match.get("confidence") == "high"]
    if len(accepted_matches) != 1:
        return
    comment = str(review.get("comment") or "")
    aliases = set(re.findall(r"\b(?:curso|clase)\s+de\s+([A-Z]{2,5})\b", comment))
    class_name_tokens = meaningful_course_tokens(review.get("class_name"))
    if not course_levels(class_name_tokens):
        aliases.update(re.findall(r"\b([A-Z]{2,5})\b", str(review.get("class_name") or "")))
    for alias in aliases:
        if alias in {"TEC", "GAAP", "SQL", "UCR", "UNED"}:
            continue
        add_course_variation(variations, professor_id=professor_id, class_name=alias, decision=accepted_matches[0])


def add_class_token_variations_for_match(
    variations: dict[str, dict[str, Any]],
    *,
    professor_id: int,
    class_name: object,
    decision: dict[str, Any],
) -> None:
    if has_explicit_course_separator(class_name):
        return
    _, course_matches = split_primary_and_related_course_matches(decision)
    accepted_matches = [match for match in course_matches if match.get("course_id") is not None and match.get("confidence") == "high"]
    if len(accepted_matches) != 1:
        return
    target_tokens = meaningful_course_tokens(accepted_matches[0].get("course_name"))
    for token in meaningful_course_tokens(class_name):
        if len(token) < 6 or token in GENERIC_SINGLE_COURSE_HINTS or token in GENERIC_GLOBAL_COURSE_NAMES:
            continue
        if not token_is_related(token, target_tokens) and not token_matches_course_acronym(token, target_tokens):
            continue
        add_course_variation(variations, professor_id=professor_id, class_name=token, decision=accepted_matches[0])


def get_course_match(*, professor_id: int, review: dict[str, Any], courses_by_professor: dict[int, list[dict[str, Any]]], course_prefix_affinity: dict[int, Counter[str]], all_courses: list[dict[str, Any]], decisions: dict[str, dict[str, Any]], api_key: str | None, model: str, use_openrouter: bool, max_openrouter_calls: int | None, variations: dict[str, dict[str, Any]], family_decisions: dict[str, dict[str, Any]], counters: Counter[str]) -> dict[str, Any]:
    key = decision_key(professor_id, review.get("class_name"))
    if (
        key in decisions
        and should_reuse_cached_decision(decisions[key], use_openrouter=use_openrouter, api_key=api_key)
        and not should_refresh_cached_decision(decisions[key], review.get("class_name"))
    ):
        counters["course_decision_cache_hit"] += 1
        add_course_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=decisions[key])
        if decisions[key].get("method") != "openrouter_family":
            add_comment_alias_variations_for_match(variations, professor_id=professor_id, review=review, decision=decisions[key])
            add_class_token_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=decisions[key])
        return decisions[key]

    professor_courses = courses_by_professor.get(professor_id, [])
    professor_course_ids = {int(course["course_id"]) for course in professor_courses}
    allow_ambiguous = has_explicit_course_separator(review.get("class_name"))
    dominant_prefix_set = dominant_prefixes(professor_courses, decisions, professor_id)
    variation_course_ids = variation_course_ids_for_class_name(variations, review.get("class_name"), professor_id)
    family = course_family(review.get("class_name"))
    ambiguity_kind = course_ambiguity_kind(review.get("class_name"))
    for candidate in (
        explicit_segment_course_matches(
            review.get("class_name"),
            professor_courses,
            match_scope="professor_history",
            requires_offering_backfill=False,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
            preferred_course_ids=professor_course_ids,
        ),
        explicit_segment_course_matches(
            review.get("class_name"),
            all_courses,
            match_scope="global_catalog",
            requires_offering_backfill=True,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
            preferred_course_ids=professor_course_ids,
        ),
        deterministic_course_match(review.get("class_name"), professor_courses, match_scope="professor_history", requires_offering_backfill=False, allow_ambiguous=allow_ambiguous),
        contextual_related_course_matches(
            review.get("class_name"),
            professor_courses,
            match_scope="professor_history",
            requires_offering_backfill=False,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        ),
        contextual_course_match(
            review.get("class_name"),
            professor_courses,
            match_scope="professor_history",
            requires_offering_backfill=False,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
            minimum_score=82,
            minimum_gap=3,
        ),
    ):
        if candidate is None:
            continue
        counters[f"course_match_{candidate['confidence']}"] += 1
        if candidate.get("requires_offering_backfill"):
            counters["course_match_requires_offering_backfill"] += 1
        decisions[key] = candidate
        add_course_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=candidate)
        add_comment_alias_variations_for_match(variations, professor_id=professor_id, review=review, decision=candidate)
        add_class_token_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=candidate)
        return candidate

    if family is not None and ambiguity_kind is not None and use_openrouter and api_key:
        family_key = family_decision_key(professor_id, family, ambiguity_kind)
        family_options = course_options_for_family(
            class_name=review.get("class_name"),
            professor_courses=professor_courses,
            all_courses=all_courses,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        )
        if len(family_options) > 1:
            had_cached_family_resolution = family_key in family_decisions
            resolution = family_decisions.get(family_key)
            if resolution is None or resolution.get("prompt_version") != COURSE_FAMILY_PROMPT_VERSION or not resolution.get("preferred_course_ids"):
                if max_openrouter_calls is None or counters["openrouter_calls"] < max_openrouter_calls:
                    counters["openrouter_calls"] += 1
                    try:
                        resolution = call_openrouter_for_course_family(
                            api_key=api_key,
                            model=model,
                            professor_id=professor_id,
                            family=family,
                            class_name=review.get("class_name"),
                            comment=str(review.get("comment") or ""),
                            raw_tags=review.get("tags") if isinstance(review.get("tags"), list) else [],
                            course_options=family_options,
                        )
                        family_decisions[family_key] = resolution
                    except Exception as error:  # noqa: BLE001
                        resolution = {"family": family, "preferred_course_ids": [], "confidence": "none", "method": "openrouter_family_error", "prompt_version": COURSE_FAMILY_PROMPT_VERSION, "reason": str(error)}
            if resolution is not None and CONFIDENCE_ORDER.get(str(resolution.get("confidence") or "none"), 0) >= CONFIDENCE_ORDER["high"]:
                family_decision = decision_from_family_resolution(resolution, family_options, class_name=review.get("class_name"))
                if family_decision is not None:
                    counters["course_family_cache_hit" if had_cached_family_resolution else "course_family_llm_match"] += 1
                    counters[f"course_match_{family_decision['confidence']}"] += 1
                    if family_decision.get("requires_offering_backfill"):
                        counters["course_match_requires_offering_backfill"] += 1
                    decisions[key] = family_decision
                    add_course_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=family_decision)
                    return family_decision

    for candidate in (
        contextual_course_match(
            review.get("class_name"),
            all_courses,
            match_scope="global_catalog",
            requires_offering_backfill=True,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
            minimum_score=92,
            minimum_gap=8,
        ),
        contextual_related_course_matches(
            review.get("class_name"),
            all_courses,
            match_scope="global_catalog",
            requires_offering_backfill=True,
            dominant_prefix_set=dominant_prefix_set,
            variation_course_ids=variation_course_ids,
            course_prefix_affinity=course_prefix_affinity,
        ),
        deterministic_course_match(review.get("class_name"), all_courses, match_scope="global_catalog", requires_offering_backfill=True),
    ):
        if candidate is None:
            continue
        counters[f"course_match_{candidate['confidence']}"] += 1
        if candidate.get("requires_offering_backfill"):
            counters["course_match_requires_offering_backfill"] += 1
        decisions[key] = candidate
        add_course_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=candidate)
        add_comment_alias_variations_for_match(variations, professor_id=professor_id, review=review, decision=candidate)
        add_class_token_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=candidate)
        return candidate

    if not use_openrouter or not api_key:
        decision = {"course_id": None, "course_code": None, "course_name": None, "match_scope": None, "requires_offering_backfill": False, "confidence": "none", "method": "unmatched", "reason": "No deterministic match and OpenRouter matching is disabled or missing OPENROUTER_API_KEY."}
        counters["course_match_none"] += 1
        if should_persist_decision(decision):
            decisions[key] = decision
        return decision
    if max_openrouter_calls is not None and counters["openrouter_calls"] >= max_openrouter_calls:
        decision = {"course_id": None, "course_code": None, "course_name": None, "match_scope": None, "requires_offering_backfill": False, "confidence": "none", "method": "openrouter_limit_reached", "reason": f"OpenRouter call limit reached ({max_openrouter_calls})."}
        counters["course_match_none"] += 1
        return decision

    try:
        professor_options = [{"course_id": int(course["course_id"]), "code": str(course["code"]), "name": str(course["name"]), "match_scope": "professor_history", "requires_offering_backfill": False, "dominant_prefix_match": course_prefix(course) in dominant_prefix_set, "prefix_affinity": dict(course_prefix_affinity.get(int(course["course_id"]), Counter()))} for course in professor_courses]
        global_options = [{"course_id": int(course["course_id"]), "code": str(course["code"]), "name": str(course["name"]), "match_scope": "global_catalog", "requires_offering_backfill": True, "dominant_prefix_match": course_prefix(course) in dominant_prefix_set, "prefix_affinity": dict(course_prefix_affinity.get(int(course["course_id"]), Counter()))} for course in select_global_course_candidates(review.get("class_name"), professor_courses=professor_courses, all_courses=all_courses, dominant_prefix_set=dominant_prefix_set, course_prefix_affinity=course_prefix_affinity)]
        counters["openrouter_calls"] += 1
        decision = call_openrouter_for_course(api_key=api_key, model=model, professor_id=professor_id, class_name=review.get("class_name"), comment=str(review.get("comment") or ""), raw_tags=review.get("tags") if isinstance(review.get("tags"), list) else [], course_options=[*professor_options, *global_options])
    except Exception as error:  # noqa: BLE001 - process the rest of the batch even when one LLM call fails.
        decision = {"course_id": None, "course_code": None, "course_name": None, "match_scope": None, "requires_offering_backfill": False, "confidence": "none", "method": "openrouter_error", "reason": str(error)}

    if decision.get("course_id") is None and not decision.get("related_course_matches"):
        fallback = fallback_decision_from_related_matches(related_course_matches_from_class_name(review.get("class_name"), professor_courses, match_scope="professor_history", requires_offering_backfill=False, method="deterministic_related", reason="Class name clearly names this course, but no primary course was identifiable."), match_scope="professor_history", requires_offering_backfill=False)
        if fallback is not None:
            decision = fallback
    counters[f"course_match_{decision['confidence']}"] += 1
    if should_persist_decision(decision):
        decisions[key] = decision
    add_course_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=decision)
    add_comment_alias_variations_for_match(variations, professor_id=professor_id, review=review, decision=decision)
    add_class_token_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=decision)
    return decision
