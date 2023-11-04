import { User, Role } from "@lib/database";
import { f as fail, r as redirect } from "../../../chunks/index.js";
const actions = {
  register: async ({
    locals,
    request,
    cookies
  }) => {
    const form = await request.formData();
    const username = form.get("username");
    const password = form.get("password");
    const email = form.get("email");
    if (!username || !password || !email) {
      return fail(400, {
        username,
        email,
        missingCredentials: true
      });
    }
    const weakPassword = password.length < 8;
    if (weakPassword) {
      return fail(400, {
        username,
        email,
        weakPassword: true
      });
    }
    const existingUser = await locals.em.findOne(User, {
      $or: [{
        username
      }, {
        email
      }]
    });
    if (existingUser) {
      return fail(400, {
        username,
        email,
        userAlreadyExists: true
      });
    }
    const newUser = new User(username, email, password);
    const isFirstUser = await locals.em.count(User) === 0;
    if (isFirstUser) {
      newUser.role = Role.SUPER_ADMIN;
    }
    const sessionToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    newUser.sessionToken = sessionToken;
    cookies.set("user", newUser.sessionToken, {
      path: "/"
    });
    const user = locals.em.create(User, newUser);
    await locals.em.persistAndFlush(user);
    throw redirect(303, "/courses");
  }
};
export {
  actions
};
