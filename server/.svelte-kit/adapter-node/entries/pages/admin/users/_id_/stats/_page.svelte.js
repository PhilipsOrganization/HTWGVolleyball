import { c as create_ssr_component, e as escape, f as each, d as add_attribute } from "../../../../../../chunks/ssr.js";
import { Role } from "@lib/database";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "section.svelte-vl3rw1{display:flex;flex-direction:column;padding:1rem;gap:0px}p.svelte-vl3rw1{margin:0}div.svelte-vl3rw1{display:flex;justify-content:center;align-items:center;margin:1rem;width:80%;height:200px}svg.svelte-vl3rw1{width:100%;height:100%}button.svelte-vl3rw1{padding:20px;background:#9cc1cf;margin:10px;color:black}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { data } = $$props;
  const user = data.user;
  if ($$props.data === void 0 && $$bindings.data && data !== void 0)
    $$bindings.data(data);
  $$result.css.add(css);
  return `<section class="svelte-vl3rw1"><h1>Stats for ${escape(user.username)}</h1> ${user.role === Role.ADMIN ? `<form action="?/demote" method="post" data-svelte-h="svelte-13aa0i3"><button class="svelte-vl3rw1">demote to user</button></form>` : `${user.role === Role.USER ? `<form action="?/promote" method="post" data-svelte-h="svelte-xikdr9"><button class="svelte-vl3rw1">promote to admin</button></form>` : ``}`} <p class="svelte-vl3rw1">Registered for ${escape(data.totalRegistrations)} courses</p> ${data.stats.length ? each(data.stats, (course) => {
    return `<p class="svelte-vl3rw1">${escape(course.courseName)}: ${escape(course.count)}</p>`;
  }) : `<p class="svelte-vl3rw1" data-svelte-h="svelte-16dpfrj">No courses registered</p>`}</section> <div class="svelte-vl3rw1"><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" class="svelte-vl3rw1"><path fill="none" stroke="grey"${add_attribute("d", data.svg, 0)}></path></svg> </div>`;
});
export {
  Page as default
};
