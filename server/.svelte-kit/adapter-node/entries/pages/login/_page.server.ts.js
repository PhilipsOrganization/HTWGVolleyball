var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { User } from "@lib/database";
import { r as redirect, f as fail } from "../../../chunks/index.js";
const load = /* @__PURE__ */ __name(async ({
  locals
}) => {
  if (locals.user) {
    throw redirect(303, "/courses");
  }
}, "load");
const actions = {
  login: async ({
    locals,
    request,
    cookies
  }) => {
    const form = await request.formData();
    const username = form.get("username");
    const password = form.get("password");
    if (!username || !password) {
      return fail(400, {
        missingCredentials: true
      });
    }
    const user = await locals.em.findOne(User, {
      username
    });
    if (!user) {
      return fail(400, {
        username,
        userNotFound: true
      });
    }
    if (!user.isPasswordCorrect(password)) {
      return fail(400, {
        username,
        wrongPassword: true
      });
    }
    const sessionToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    user.sessionToken = sessionToken;
    await locals.em.persistAndFlush(user);
    cookies.set("user", sessionToken, {
      path: "/"
    });
    throw redirect(303, "/courses");
  }
};
export {
  actions,
  load
};
