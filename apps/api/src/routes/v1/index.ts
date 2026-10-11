import { Hono } from "hono";

import type { HonoEnv } from "../../types";

import catalogsRoutes from "./catalogs";
import coursesRoutes from "./courses";
import evaluationsRoutes from "./evaluations";
import feedbackRoutes from "./feedback";
import moderationRoutes from "./moderation";
import notificationsRoutes from "./notifications";
import professorsRoutes from "./professors";
import reportsRoutes from "./reports";
import reviewsRoutes from "./reviews";
import schedulesRoutes from "./schedules";
import studentsRoutes from "./students";
import usersRoutes from "./users";

const v1 = new Hono<HonoEnv>();

v1.route("/", catalogsRoutes);
v1.route("/", coursesRoutes);
v1.route("/", schedulesRoutes);
v1.route("/", studentsRoutes);
v1.route("/", usersRoutes);
v1.route("/", professorsRoutes);
v1.route("/", reviewsRoutes);
v1.route("/", evaluationsRoutes);
v1.route("/", reportsRoutes);
v1.route("/", feedbackRoutes);
v1.route("/", moderationRoutes);
v1.route("/", notificationsRoutes);

export default v1;
