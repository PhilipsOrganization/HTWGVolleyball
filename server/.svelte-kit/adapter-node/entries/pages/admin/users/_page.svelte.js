import { c as create_ssr_component, f as each, e as escape } from "../../../../chunks/ssr.js";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "section.svelte-151c4ai{display:flex;flex-direction:column;gap:1rem;max-width:min(1000px, 90%);margin:0 auto;align-items:center}p.svelte-151c4ai{display:flex;justify-content:space-between;align-items:center;width:80vw;border-bottom:1px solid #7d7d7d;padding:0.5rem 0}a.svelte-151c4ai{text-decoration:underline}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { data } = $$props;
  if ($$props.data === void 0 && $$bindings.data && data !== void 0)
    $$bindings.data(data);
  $$result.css.add(css);
  return `<section class="svelte-151c4ai"><h1 data-svelte-h="svelte-1apdn4a">Users</h1> <div id="users">${each(data.users, (user) => {
    return `<p class="svelte-151c4ai"><span>${escape(user.username)}</span> <span>${escape(user.role)}</span> <a href="${"/admin/users/" + escape(user.id, true) + "/stats"}" class="svelte-151c4ai">info</a> </p>`;
  })}</div> </section>`;
});
export {
  Page as default
};
