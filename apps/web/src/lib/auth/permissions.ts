import { createAccessControl } from "better-auth/plugins/access";
import { defaultStatements, adminAc } from "better-auth/plugins/admin/access";

export const statement = {
  ...defaultStatements,
  moderation: ["reviews", "evaluations", "reports", "feedback"],
} as const;

export const ac = createAccessControl(statement);

export const adminRole = ac.newRole({
  ...adminAc.statements,
  moderation: ["reviews", "evaluations", "reports", "feedback"],
});

export const moderatorRole = ac.newRole({
  user: ["get", "list"],
  moderation: ["reviews", "evaluations", "reports", "feedback"],
});

export const userRole = ac.newRole({});

export const roles = {
  admin: adminRole,
  moderator: moderatorRole,
  user: userRole,
};

export type AppRole = keyof typeof roles;
