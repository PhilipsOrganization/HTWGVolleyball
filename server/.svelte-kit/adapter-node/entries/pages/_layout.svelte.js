var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { c as create_ssr_component, b as subscribe, v as validate_component } from "../../chunks/ssr.js";
import { Role } from "@lib/database";
import { p as page } from "../../chunks/stores.js";
function client_method(key) {
  {
    if (key === "before_navigate" || key === "after_navigate" || key === "on_navigate") {
      return () => {
      };
    } else {
      const name_lookup = {
        disable_scroll_handling: "disableScrollHandling",
        preload_data: "preloadData",
        preload_code: "preloadCode",
        invalidate_all: "invalidateAll"
      };
      return () => {
        throw new Error(`Cannot call ${name_lookup[key] ?? key}(...) on the server`);
      };
    }
  }
}
__name(client_method, "client_method");
const onNavigate = /* @__PURE__ */ client_method("on_navigate");
const header_svelte_svelte_type_style_lang = "";
const css$1 = {
  code: "header.svelte-1rqdq2g{position:relative;display:flex;flex-direction:column;justify-content:space-between;padding:0 1rem;background-color:#9cc1cf;height:min(30vh, 300px);border-bottom-left-radius:16px;border-bottom-right-radius:16px;overflow:hidden;box-sizing:border-box}h1.svelte-1rqdq2g{display:block;position:relative;max-width:60%;z-index:1;padding:0;font-size:3rem;font-weight:100;color:#000}nav.svelte-1rqdq2g{display:flex;flex-direction:row;justify-content:space-between;width:90vw;margin:0.5rem auto;color:#000;z-index:1;font-weight:400}img.svelte-1rqdq2g{position:absolute;inset:auto -10% 20px auto;width:60vw}",
  map: null
};
const Header = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  $$result.css.add(css$1);
  $$unsubscribe_page();
  return `<header class="svelte-1rqdq2g"><nav class="svelte-1rqdq2g">${$page.data.user ? `<a href="/profile" data-svelte-h="svelte-1okgglh">Profile</a> ${$page.data.user.role !== Role.USER ? `<a href="/admin" data-svelte-h="svelte-mfs7al">Admin</a> <a href="/admin/users" data-svelte-h="svelte-hiu53f">Users</a>` : ``} <a href="/logout" data-svelte-h="svelte-a556kj">Logout</a>` : `<a class="accent" href="/login" data-svelte-h="svelte-ai11xm">Login</a>`}</nav> <a href="/courses"><h1 class="svelte-1rqdq2g">Volleyball HTWG

			${$page.route.id?.includes("/admin") || $page.url.searchParams.has("admin") ? `- Admin` : ``}</h1></a> <img src="/Volleyball_icon.svg" alt="Volleyball" class="svelte-1rqdq2g"> </header>`;
});
const _layout_svelte_svelte_type_style_lang = "";
const css = {
  code: "body{margin:0;padding:0;background:#131313;color:#e0e0e0;font-family:Nono;font-weight:100;min-height:100dvh;font-size:16px;display:flex;flex-direction:column;text-underline-position:under;text-decoration-thickness:0px}@font-face{font-family:Nono;src:local(Nono), url('/fonts/NotoSansMono-VariableFont_wdth,wght.ttf') format('truetype')}:root:view-transition-group(*){animation-duration:700ms}h1,h2,h3,h4,h5,h6{font-weight:400}a{text-decoration:none;color:unset;font-weight:400}button{all:unset;cursor:pointer;font-weight:400}",
  map: null
};
function startViewTransition(callback) {
  return new Promise((resolve) => {
    const transition = document.startViewTransition(() => {
      resolve(transition);
      return callback();
    });
  });
}
__name(startViewTransition, "startViewTransition");
const Layout = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  onNavigate(async (navigation) => {
    if ("startViewTransition" in document) {
      await startViewTransition(() => Promise.race([navigation.complete, new Promise((resolve) => setTimeout(resolve, 200))]));
    }
  });
  $$result.css.add(css);
  return `${validate_component(Header, "Header").$$render($$result, {}, {}, {})} ${slots.default ? slots.default({}) : ``}`;
});
export {
  Layout as default
};
