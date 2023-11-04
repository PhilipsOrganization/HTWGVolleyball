var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { r as redirect } from "../../../chunks/index.js";
const load = /* @__PURE__ */ __name(async ({
  cookies
}) => {
  cookies.delete("user", {
    path: "/"
  });
  throw redirect(300, "/login");
}, "load");
export {
  load
};
