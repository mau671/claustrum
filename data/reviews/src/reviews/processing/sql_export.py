from __future__ import annotations

import hashlib
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from reviews.text import sql_bool, sql_literal, sql_numeric, sql_text_array


def review_import_key(professor_id: int, review: dict[str, Any]) -> str:
    course_ids = sorted(str(course.get("id")) for course in review.get("courses", []) if isinstance(course, dict) and course.get("id") is not None)
    payload = "|".join(
        [
            str(professor_id),
            str(review.get("created_at") or ""),
            str(review.get("comment") or ""),
            str(review.get("quality_score") or ""),
            str(review.get("ease_score") or ""),
            str(review.get("grade_received") or ""),
            ",".join(str(tag) for tag in review.get("tags", [])),
            ",".join(course_ids),
        ]
    )
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def ready_reviews_from_file(data: dict[str, Any]) -> list[dict[str, Any]]:
    return [
        review
        for review in data.get("reviews", [])
        if isinstance(review, dict)
        and review.get("processing_status") == "ready"
        and any(isinstance(course, dict) and course.get("id") is not None for course in review.get("courses", []))
    ]


def get_review_values(professor_id: int, review: dict[str, Any]) -> str:
    import_key = review_import_key(professor_id, review)
    course_ids = [int(course["id"]) for course in review.get("courses", []) if isinstance(course, dict) and course.get("id") is not None]
    
    values = {
        "professor_id": f"{professor_id}::BIGINT",
        "comment": f"{sql_literal(review.get('comment'))}::TEXT",
        "ease_score": f"{sql_numeric(review.get('ease_score'))}::NUMERIC(3,1)",
        "quality_score": f"{sql_numeric(review.get('quality_score'))}::NUMERIC(3,1)",
        "clarity_score": f"{sql_numeric(review.get('clarity_score'))}::NUMERIC(3,1)",
        "fairness_score": f"{sql_numeric(review.get('fairness_score'))}::NUMERIC(3,1)",
        "attendance_required": f"{sql_bool(review.get('attendance_required'))}::BOOLEAN",
        "grade_received": (
            "NULLIF("
            f"{sql_literal(review.get('grade_received'))}"
            ",'')::SMALLINT"
        ),
        "engagement_level": f"{sql_numeric(review.get('engagement_level'))}::SMALLINT",
        "tags": f"{sql_text_array(review.get('tags') if isinstance(review.get('tags'), list) else [])}",
        "created_at": f"{sql_literal(review.get('created_at'))}::TIMESTAMPTZ",
        "import_key": f"{sql_literal(import_key)}::TEXT",
        "course_ids": f"ARRAY[{', '.join(str(cid) for cid in course_ids)}]::BIGINT[]"
    }
    
    return f"({values['professor_id']}, {values['comment']}, {values['ease_score']}, {values['quality_score']}, {values['clarity_score']}, {values['fairness_score']}, {values['attendance_required']}, {values['grade_received']}, {values['engagement_level']}, {values['tags']}, {values['created_at']}, {values['import_key']}, {values['course_ids']})"

def write_professor_sql(professor_id: int, page_data: list[dict[str, Any]], output_path: Path, existing_keys: set[str] | None = None) -> int:
    reviews = []
    for data in page_data:
        for review in ready_reviews_from_file(data):
            if existing_keys is not None:
                key = review_import_key(professor_id, review)
                if key in existing_keys:
                    continue
            reviews.append(review)
            
    if not reviews:
        return 0
        
    generated_at = datetime.now(timezone.utc).isoformat()
    header = "\n".join(
        [
            "-- ============================================================================",
            "-- REVIEWS DELTA SEED",
            "-- ============================================================================",
            "-- TEC-DATA-META scope=reviews",
            f"-- TEC-DATA-META professor_id={professor_id}",
            "-- TEC-DATA-META years="
            + ",".join(
                sorted(
                    {
                        str(review.get("created_at"))[:4]
                        for review in reviews
                        if review.get("created_at")
                    }
                )
            ),
            "-- TEC-DATA-META term_external_keys=",
            f"-- TEC-DATA-META generated_at_utc={generated_at}",
            "",
            "BEGIN;",
            "SET LOCAL search_path = public;",
        ]
    )
    statements: list[str] = []
    
    # Process reviews in batches of 1000 to avoid overly massive queries
    batch_size = 1000
    for i in range(0, len(reviews), batch_size):
        batch = reviews[i:i + batch_size]
        values_list = [get_review_values(professor_id, r) for r in batch]
        values_str = ",\n    ".join(values_list)
        
        batch_sql = f"""WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    {values_str}
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
    attendance_required, grade_received, engagement_level, tags, status, reviewed_at, created_at, updated_at, import_key
  )
  SELECT 
    professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
    attendance_required, grade_received, engagement_level, tags, 'approved'::public.professor_review_status, now(), created_at, created_at, import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1 FROM public.professor_review pr WHERE pr.import_key = ri.import_key
  )
  RETURNING id, import_key
), target_review AS (
  SELECT id, import_key FROM inserted_review
  UNION ALL
  SELECT pr.id, pr.import_key
  FROM public.professor_review pr
  JOIN review_input ri ON ri.import_key = pr.import_key
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
JOIN review_input ri ON ri.import_key = tr.import_key
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT DO NOTHING;"""
        statements.append(batch_sql)
        
    statements.append("COMMIT;")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(header + "\n\n" + "\n\n".join(statements) + "\n")
    return len(reviews)

