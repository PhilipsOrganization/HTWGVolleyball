var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { Role, Course, User } from "@lib/database";
import { assign } from "@mikro-orm/core";
import { r as redirect, f as fail, e as error } from "../../../chunks/index.js";
import { startOfYesterday } from "date-fns";
import { zonedTimeToUtc } from "date-fns-tz";
import { z } from "zod";
const load = /* @__PURE__ */ __name(async ({
  locals,
  url
}) => {
  if (!locals.user || locals.user.role === Role.USER) {
    throw redirect(303, "/courses");
  }
  const showArchived = url.searchParams.has("archived");
  const courses = await locals.em.find(Course, showArchived ? {} : {
    date: {
      $gte: startOfYesterday()
    }
  }, {
    orderBy: {
      date: "DESC"
    }
  });
  const dates = {};
  for (const course2 of courses) {
    const date = course2.date.toISOString().substr(0, 10);
    if (!dates[date]) {
      dates[date] = [];
    }
    dates[date].push(course2);
  }
  const users = await locals.em.find(User, {});
  let course = null;
  if (url.searchParams.has("course")) {
    const courseId = parseInt(url.searchParams.get("course") ?? "");
    course = await locals.em.findOne(Course, {
      id: courseId
    });
  }
  return {
    users: users.map((u) => u.toJSON()),
    dates: Object.entries(dates).map(([date, courses2]) => ({
      date,
      courses: courses2.map((c) => c.toJSON(locals.user))
    })),
    user: locals.user.toJSON(),
    course: course?.toJSON(locals.user)
  };
}, "load");
const courseValidation = z.object({
  name: z.string().min(3).max(100),
  location: z.string().min(3).max(100),
  date: z.string().length("YYYY-MM-DD".length),
  time: z.string().length("HH:MM".length).regex(/^\d\d:\d\d$/),
  maxParticipants: z.string().min(1).max(3).regex(/^\d+$/),
  publishOn: z.string().length("YYYY-MM-DDTHH:MM".length)
});
const actions = {
  "create-course": async ({
    locals,
    request
  }) => {
    if (!locals.user || locals.user.role === Role.USER) {
      throw redirect(303, "/login");
    }
    const form = await request.formData();
    let dto;
    try {
      dto = courseValidation.parse(Object.fromEntries(form.entries()));
    } catch (e) {
      const error2 = e;
      const obj = {};
      for (const issue of error2.issues) {
        obj[issue.path.join(".")] = issue.message;
      }
      return fail(400, obj);
    }
    const publishOn = new Date(dto.publishOn);
    const data = {
      ...dto,
      date: new Date(dto.date),
      publishOn: zonedTimeToUtc(publishOn, "Europe/Berlin"),
      maxParticipants: parseInt(dto.maxParticipants)
    };
    const course = new Course();
    assign(course, data);
    await locals.em.persistAndFlush(course);
    return;
  },
  "update-course": async ({
    locals,
    request
  }) => {
    if (!locals.user || locals.user.role === Role.USER) {
      throw redirect(303, "/login");
    }
    const form = await request.formData();
    const courseIdString = form.get("courseId");
    const name = form.get("title");
    if (!courseIdString || !name) {
      throw error(400, "No courseId or title provided");
    }
    const courseId = parseInt(courseIdString);
    const course = await locals.em.findOne(Course, {
      id: courseId
    });
    if (!course) {
      throw error(400, "Course not found");
    }
    assign(course, {
      name
    });
    await locals.em.persistAndFlush(course);
  }
};
export {
  actions,
  load
};
