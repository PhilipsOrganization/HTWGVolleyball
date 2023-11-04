var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { g as getPath } from "../../../chunks/stats.js";
import { UserStats, RegistrationStats, Course } from "@lib/database";
import { r as redirect } from "../../../chunks/index.js";
const load = /* @__PURE__ */ __name(async ({
  locals
}) => {
  if (!locals.user) {
    throw redirect(303, "/login");
  }
  const stats = await locals.em.find(UserStats, {
    userId: locals.user.id
  });
  const registrationStats = await locals.em.findOne(RegistrationStats, {
    userId: locals.user.id
  });
  const totalRegistrations = await locals.em.find(Course, {
    users: locals.user
  }, {
    populate: [],
    fields: ["date"],
    orderBy: {
      date: "ASC"
    }
  });
  return {
    user: locals.user.toJSON(),
    stats: stats.map((s) => s.toJSON()),
    registrationStats: registrationStats?.toJSON(),
    totalRegistrations: totalRegistrations.length,
    svg: getPath(totalRegistrations)
  };
}, "load");
export {
  load
};
