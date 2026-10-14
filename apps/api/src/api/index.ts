import { HttpApi } from "effect/http-api";

import { AcademicUnitsApiGroup } from "./AcademicUnitsApi";
import { CampusesApiGroup } from "./CampusesApi";
import { CoursesApiGroup } from "./CoursesApi";
import { EvaluationsApiGroup } from "./EvaluationsApi";
import { FeedbackApiGroup } from "./FeedbackApi";
import { ModerationApiGroup } from "./ModerationApi";
import { NotificationsApiGroup } from "./NotificationsApi";
import { ProfessorsApiGroup } from "./ProfessorsApi";
import { ReportsApiGroup } from "./ReportsApi";
import { ReviewsApiGroup } from "./ReviewsApi";
import { SchedulesApiGroup } from "./SchedulesApi";
import { StudentsApiGroup } from "./StudentsApi";
import { StudyPlansApiGroup } from "./StudyPlansApi";
import { TermsApiGroup } from "./TermsApi";
import { UniversitiesApiGroup } from "./UniversitiesApi";
import { UsersApiGroup } from "./UsersApi";

export class ClaustrumApi extends HttpApi.make("ClaustrumApi")
  .add(UniversitiesApiGroup)
  .add(CampusesApiGroup)
  .add(AcademicUnitsApiGroup)
  .add(StudyPlansApiGroup)
  .add(TermsApiGroup)
  .add(CoursesApiGroup)
  .add(SchedulesApiGroup)
  .add(ProfessorsApiGroup)
  .add(ReviewsApiGroup)
  .add(StudentsApiGroup)
  .add(EvaluationsApiGroup)
  .add(ModerationApiGroup)
  .add(FeedbackApiGroup)
  .add(ReportsApiGroup)
  .add(UsersApiGroup)
  .add(NotificationsApiGroup)
  .prefix("/api/v1") {}
