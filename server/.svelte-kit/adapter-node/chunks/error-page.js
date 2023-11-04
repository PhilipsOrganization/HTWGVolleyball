import { c as create_ssr_component, b as subscribe, e as escape } from "./ssr.js";
import { p as page } from "./stores.js";
const errorPage_svelte_svelte_type_style_lang = "";
const css = {
  code: "section.svelte-pwy254{padding:20px;display:flex;flex-direction:column;align-items:center}h1.svelte-pwy254{margin:-10px -20px 20px -20px;width:100%;text-align:center;padding-bottom:10px}p.svelte-pwy254{font-size:18px}",
  map: null
};
const Error_page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let { title = "Error" } = $$props;
  if ($$props.title === void 0 && $$bindings.title && title !== void 0)
    $$bindings.title(title);
  $$result.css.add(css);
  $$unsubscribe_page();
  return `<section class="svelte-pwy254"><h1 class="svelte-pwy254">${escape(title)}</h1> ${$page.error ? `<p class="svelte-pwy254">Error: ${escape($page.error?.message)}</p>` : ``} ${slots.default ? slots.default({}) : ``} </section>`;
});
export {
  Error_page as E
};
