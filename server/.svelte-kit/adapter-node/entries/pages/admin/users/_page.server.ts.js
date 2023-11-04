var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { Role, User } from "@lib/database";
import { r as redirect } from "../../../../chunks/index.js";
const load = /* @__PURE__ */ __name(async ({
  locals
}) => {
  if (!locals.user || locals.user.role === Role.USER) {
    throw redirect(303, "/courses");
  }
  const users = await locals.em.find(User, {});
  return {
    users: users.map((u) => u.toJSON()),
    user: locals.user.toJSON()
  };
}, "load");
export {
  load
};
