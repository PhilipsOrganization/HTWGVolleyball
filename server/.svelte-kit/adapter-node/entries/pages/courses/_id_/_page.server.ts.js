var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { s as sendNotification } from "../../../../chunks/notification.js";
import { Course, Role, User } from "@lib/database";
import { r as redirect, e as error } from "../../../../chunks/index.js";
const load = /* @__PURE__ */ __name(async ({
  locals,
  params
}) => {
  if (!locals.user) {
    throw redirect(303, "/login");
  }
  const id = parseInt(params.id);
  const course = await locals.em.findOneOrFail(Course, {
    id
  });
  if (course.publishOn < /* @__PURE__ */ new Date() && locals.user.role === Role.USER) {
    throw error(400, "Course not jet published");
  }
  return {
    course: course.toJSON(locals.user),
    user: locals.user.toJSON()
  };
}, "load");
function notifyNextUser(course) {
  const spots = course.maxParticipants;
  const users = course.users.getItems();
  if (users.length <= spots) {
    return;
  }
  const userOnWaitlist = users.at(spots - 1);
  if (!userOnWaitlist) {
    return;
  }
  return sendNotification(userOnWaitlist, `A spot in ${course.name} Course has opened up for you!`);
}
__name(notifyNextUser, "notifyNextUser");
const actions = {
  enlist: async ({
    locals,
    params
  }) => {
    if (!locals.user) {
      throw redirect(303, "/login");
    }
    const courseIdString = params.id;
    if (!courseIdString) {
      throw error(400, "No courseId provided");
    }
    const courseId = parseInt(courseIdString);
    const course = await locals.em.findOne(Course, {
      id: courseId
    });
    if (!course) {
      throw error(400, "Course not found");
    }
    if (locals.user.courses.contains(course)) {
      throw error(400, "Already enrolled");
    }
    locals.user.courses.add(course);
    course.users.add(locals.user);
    await locals.em.persistAndFlush([locals.user, course]);
    return {
      course: course.toJSON(locals.user)
    };
  },
  drop: async ({
    locals,
    params
  }) => {
    if (!locals.user) {
      throw redirect(303, "/login");
    }
    const courseIdString = params.id;
    if (!courseIdString) {
      throw error(400, "No courseId provided");
    }
    const courseId = parseInt(courseIdString);
    const course = await locals.em.findOne(Course, {
      id: courseId
    });
    if (!course) {
      throw error(400, "Course not found");
    }
    if (!locals.user.courses.contains(course)) {
      throw error(400, "Not enrolled");
    }
    locals.user.courses.remove(course);
    course.users.remove(locals.user);
    await locals.em.persistAndFlush([locals.user, course]);
    notifyNextUser(course);
    return {
      course: course.toJSON(locals.user)
    };
  },
  "delete-course": async ({
    locals,
    params
  }) => {
    if (!locals.user || locals.user.role === Role.USER) {
      throw redirect(303, "/login");
    }
    const courseIdString = params.id;
    if (!courseIdString) {
      throw error(400, "No courseId provided");
    }
    const courseId = parseInt(courseIdString);
    const course = await locals.em.findOne(Course, {
      id: courseId
    });
    if (!course) {
      throw error(400, "Course not found");
    }
    await locals.em.transactional(async (em) => {
      course.users.removeAll();
      await em.persistAndFlush(course);
      await em.removeAndFlush(course);
    });
    throw redirect(303, `/admin`);
  },
  cancel: async ({
    locals,
    request,
    params
  }) => {
    if (!locals.user || locals.user.role === Role.USER) {
      throw redirect(303, "/login");
    }
    const form = await request.formData();
    const courseId = parseInt(params.id);
    const course = await locals.em.findOneOrFail(Course, {
      id: courseId
    });
    const userIdString = form.get("userId");
    if (!userIdString) {
      throw error(400, "No userId provided");
    }
    const userId = parseInt(userIdString);
    const user = await locals.em.findOneOrFail(User, {
      id: userId
    });
    course.users.remove(user);
    await locals.em.persistAndFlush(course);
    notifyNextUser(course);
    return {
      course: course.toJSON(locals.user)
    };
  }
};
export {
  actions,
  load
};
