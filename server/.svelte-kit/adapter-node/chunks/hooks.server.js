var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { MikroORM } from "@mikro-orm/core";
import { d as building } from "./internal.js";
import { a as setEnv$1 } from "./notification.js";
import { setEnv, config, User } from "@lib/database";
let orm;
if (!building) {
  setEnv(process.env);
  setEnv$1(process.env);
  orm = await MikroORM.init(config);
  const migrator = orm.getMigrator();
  await migrator.createMigration();
  await migrator.up();
}
const handle = /* @__PURE__ */ __name(async ({
  event,
  resolve
}) => {
  if (building) {
    return await resolve(event);
  }
  event.locals.em = orm.em.fork();
  const session = event.cookies.get("user");
  if (session) {
    const user = await event.locals.em.findOne(User, {
      sessionToken: session
    }, {
      populate: ["courses"]
    });
    if (user) {
      event.locals.user = user;
    }
  }
  return await resolve(event);
}, "handle");
export {
  handle
};
