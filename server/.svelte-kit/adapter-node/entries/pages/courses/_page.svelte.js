import { c as create_ssr_component, f as each, e as escape, v as validate_component } from "../../../chunks/ssr.js";
import { h as humanReadableDate, C as Course } from "../../../chunks/date.js";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "#list.svelte-1s4wg7z{flex:1;display:flex;flex-direction:column}#block.svelte-1s4wg7z{flex:1;display:flex;flex-direction:column;margin-bottom:6rem}main.svelte-1s4wg7z{display:flex;flex-direction:column;margin:5dvh auto 15dvh;width:90vw;max-width:700px;box-sizing:border-box}h2.svelte-1s4wg7z{text-align:center;margin:0 0 2rem;text-transform:capitalize}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { data } = $$props;
  if ($$props.data === void 0 && $$bindings.data && data !== void 0)
    $$bindings.data(data);
  $$result.css.add(css);
  return `<main class="svelte-1s4wg7z"><div id="list" class="svelte-1s4wg7z">${each(data.dates ?? [], (block) => {
    return `<div id="block" class="svelte-1s4wg7z"><h2 class="svelte-1s4wg7z">${escape(humanReadableDate(block.date))}</h2> ${each(block.courses, (course, i) => {
      return `${validate_component(Course, "Course").$$render($$result, { course, isFirst: i === 0 }, {}, {})}`;
    })} </div>`;
  })}</div> </main>`;
});
export {
  Page as default
};
