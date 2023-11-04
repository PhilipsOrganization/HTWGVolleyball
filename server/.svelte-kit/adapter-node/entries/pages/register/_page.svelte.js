import { c as create_ssr_component } from "../../../chunks/ssr.js";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "div.svelte-1inxlce.svelte-1inxlce{margin:2rem auto 0}h1.svelte-1inxlce.svelte-1inxlce{border-bottom:2px solid var(--cAccent);margin:-10px -20px 20px -20px;width:100%;text-align:center;padding-bottom:10px}span.svelte-1inxlce.svelte-1inxlce{view-transition-name:register-header}a.svelte-1inxlce.svelte-1inxlce{view-transition-name:login-header}input.svelte-1inxlce.svelte-1inxlce{border:1px solid var(--cAccent);padding:1em;border-radius:8px;border:1px solid #9cc1cf;background:black;color:#e0e0e0}label.svelte-1inxlce.svelte-1inxlce{color:rgb(182, 182, 182)}form.svelte-1inxlce.svelte-1inxlce{display:flex;flex-direction:column;gap:20px}a.svelte-1inxlce.svelte-1inxlce{font-size:18px}form.svelte-1inxlce field.svelte-1inxlce{display:flex;flex-direction:column;border:none;padding:2px}div.svelte-1inxlce.svelte-1inxlce{display:flex;flex-direction:column;align-items:center}button.svelte-1inxlce.svelte-1inxlce{display:flex;flex-direction:row;justify-content:flex-end;width:80vw;background:#ecfbc7;color:black;border:none;padding:1.5rem 3rem;margin-top:2rem;box-sizing:border-box;color:black;border:none;font-size:20px;view-transition-name:action-button}.error.svelte-1inxlce.svelte-1inxlce{color:#eb714f;margin:5px 1rem}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { form } = $$props;
  if ($$props.form === void 0 && $$bindings.form && form !== void 0)
    $$bindings.form(form);
  $$result.css.add(css);
  return `<div class="svelte-1inxlce"><h1 class="svelte-1inxlce" data-svelte-h="svelte-1gr1yfp"><span class="svelte-1inxlce">register /</span> <a href="/login" class="svelte-1inxlce">login</a></h1> <form action="?/register" method="post" class="svelte-1inxlce"><field class="svelte-1inxlce"><label for="username" class="svelte-1inxlce">username

				${form?.missingCredentials ? `<small class="error svelte-1inxlce" data-svelte-h="svelte-h2c78g">required</small>` : ``} ${form?.userAlreadyExists ? `<small class="error svelte-1inxlce" data-svelte-h="svelte-1mgi1e9">user not found</small>` : ``}</label> <input type="text" name="username" id="username" autocomplete="username" class="svelte-1inxlce"></field> <field class="svelte-1inxlce"><label for="email" class="svelte-1inxlce">email

				${form?.missingCredentials ? `<small class="error svelte-1inxlce" data-svelte-h="svelte-h2c78g">required</small>` : ``} ${form?.userAlreadyExists ? `<small class="error svelte-1inxlce" data-svelte-h="svelte-1mgi1e9">user not found</small>` : ``}</label> <input type="email" name="email" id="email" autocomplete="email" class="svelte-1inxlce"></field> <field class="svelte-1inxlce"><label for="password" class="svelte-1inxlce">password

				${form?.missingCredentials ? `<small class="error svelte-1inxlce" data-svelte-h="svelte-h2c78g">required</small>` : ``} ${form?.weakPassword ? `<small class="error svelte-1inxlce" data-svelte-h="svelte-1dyivlo">weak password</small>` : ``}</label> <input type="password" name="password" id="password" autocomplete="new-password" class="svelte-1inxlce"></field> <button class="svelte-1inxlce" data-svelte-h="svelte-16wbn1j">register</button></form> </div>`;
});
export {
  Page as default
};
