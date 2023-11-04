var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { r as redirect } from "../../chunks/index.js";
const load = /* @__PURE__ */ __name(async ({
  locals
}) => {
  if (locals.user) {
    throw redirect(303, "/courses");
  }
  throw redirect(303, "/login");
}, "load");
export {
  load
};
