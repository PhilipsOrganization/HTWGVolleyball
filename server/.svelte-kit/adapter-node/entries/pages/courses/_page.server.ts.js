var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { r as redirect } from "../../../chunks/index.js";
import { Course } from "@lib/database";
const load = /* @__PURE__ */ __name(async ({
  locals
}) => {
  if (!locals.user) {
    throw redirect(303, "/login");
  }
  const courses = await locals.em.find(Course, {
    shouldPublish: true
  }, {
    orderBy: {
      date: "DESC"
    }
  });
  const dates = {};
  for (const course of courses) {
    const date = course.date.toISOString().substr(0, 10);
    if (!dates[date]) {
      dates[date] = [];
    }
    dates[date].push(course);
  }
  return {
    courses: locals.user.courses.getItems().map((c) => c.toJSON()),
    dates: Object.entries(dates).map(([date, courses2]) => ({
      date,
      courses: courses2.map((c) => c.toJSON(locals.user))
    })),
    user: locals.user.toJSON()
  };
}, "load");
export {
  load
};
