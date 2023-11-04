import { c as create_ssr_component, v as validate_component } from "../../../chunks/ssr.js";
import { E as Error_page } from "../../../chunks/error-page.js";
const _error_svelte_svelte_type_style_lang = "";
const css = {
  code: "a.svelte-1xomdh6{font-size:18px;font-weight:bold;color:var(--cAccent)}",
  map: null
};
const Error = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  $$result.css.add(css);
  return `${validate_component(Error_page, "ErrorPage").$$render($$result, { title: "Login Failed" }, {}, {
    default: () => {
      return `<a href="/login" class="svelte-1xomdh6" data-svelte-h="svelte-1ezyosd">Try again</a>`;
    }
  })}`;
});
export {
  Error as default
};
