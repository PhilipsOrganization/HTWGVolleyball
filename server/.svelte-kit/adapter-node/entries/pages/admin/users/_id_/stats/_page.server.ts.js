var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { Role, User, UserStats, Course } from "@lib/database";
import { g as getPath } from "../../../../../../chunks/stats.js";
import { r as redirect, e as error } from "../../../../../../chunks/index.js";
const load = /* @__PURE__ */ __name(async ({
  locals,
  params
}) => {
  if (!locals.user || locals.user.role === Role.USER) {
    throw redirect(303, "/courses");
  }
  const user = await locals.em.findOneOrFail(User, {
    id: parseInt(params.id)
  });
  const stats = await locals.em.find(UserStats, {
    userId: parseInt(params.id)
  });
  const totalRegistrations = await locals.em.find(Course, {
    users: user
  }, {
    populate: [],
    fields: ["date"],
    orderBy: {
      date: "ASC"
    }
  });
  return {
    user: user.toJSON(),
    stats: stats.map((s) => s.toJSON()),
    totalRegistrations: totalRegistrations.length,
    svg: getPath(totalRegistrations)
  };
}, "load");
const actions = {
  demote: async ({
    locals,
    params
  }) => {
    if (!locals.user || locals.user.role === Role.USER) {
      throw redirect(303, "/login");
    }
    const userIdString = params.id;
    if (!userIdString) {
      throw error(400, "No userId provided");
    }
    const userId = parseInt(userIdString);
    const user = await locals.em.findOne(User, {
      id: userId
    });
    if (!user) {
      throw error(400, "User not found");
    }
    if (user.role === Role.SUPER_ADMIN) {
      throw error(400, "Cannot demote super admin");
    }
    user.role = Role.USER;
    user.sessionToken = void 0;
    await locals.em.persistAndFlush(user);
  },
  promote: async ({
    locals,
    params
  }) => {
    if (locals.user?.role !== Role.ADMIN && locals.user?.role !== Role.SUPER_ADMIN) {
      throw redirect(303, "/login");
    }
    const userIdString = params.id;
    if (!userIdString) {
      throw error(400, "No userId provided");
    }
    const userId = parseInt(userIdString);
    const user = await locals.em.findOne(User, {
      id: userId
    });
    if (!user) {
      throw error(400, "User not found");
    }
    if (user.role === Role.SUPER_ADMIN) {
      throw error(400, "Cannot promote super admin");
    }
    user.role = Role.ADMIN;
    user.sessionToken = void 0;
    await locals.em.persistAndFlush(user);
  }
};
export {
  actions,
  load
};
