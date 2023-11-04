import { c as create_ssr_component } from "../../../chunks/ssr.js";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "div.svelte-fptk26.svelte-fptk26{margin:2rem auto 0}h1.svelte-fptk26.svelte-fptk26{border-bottom:2px solid var(--cAccent);margin:-10px -20px 20px -20px;width:100%;text-align:center;padding-bottom:10px}span.svelte-fptk26.svelte-fptk26{view-transition-name:login-header}a.svelte-fptk26.svelte-fptk26{view-transition-name:register-header}input.svelte-fptk26.svelte-fptk26{border:1px solid var(--cAccent);padding:1em;border-radius:8px;border:1px solid #9cc1cf;background:black;color:#e0e0e0}label.svelte-fptk26.svelte-fptk26{color:rgb(182, 182, 182)}form.svelte-fptk26.svelte-fptk26{display:flex;flex-direction:column;gap:20px}a.svelte-fptk26.svelte-fptk26{font-size:18px}form.svelte-fptk26 field.svelte-fptk26{display:flex;flex-direction:column;border:none;padding:2px}div.svelte-fptk26.svelte-fptk26{display:flex;flex-direction:column;align-items:center}button.svelte-fptk26.svelte-fptk26{display:flex;flex-direction:row;justify-content:flex-end;width:80vw;background:#ecfbc7;color:black;border:none;padding:1.5rem 3rem;margin-top:2rem;box-sizing:border-box;color:black;border:none;font-size:20px;view-transition-name:action-button}.error.svelte-fptk26.svelte-fptk26{color:#eb714f;margin:5px 1rem}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { form } = $$props;
  if ($$props.form === void 0 && $$bindings.form && form !== void 0)
    $$bindings.form(form);
  $$result.css.add(css);
  return `<div class="svelte-fptk26"><h1 class="svelte-fptk26" data-svelte-h="svelte-zxij83"><span class="svelte-fptk26">login /</span> <a href="/register" class="svelte-fptk26">register</a></h1> <form action="?/login" method="post" class="svelte-fptk26"><field class="svelte-fptk26"><label for="username" class="svelte-fptk26">username
				${form?.missingCredentials ? `<small class="error svelte-fptk26" data-svelte-h="svelte-h2c78g">required</small>` : ``} ${form?.userNotFound ? `<small class="error svelte-fptk26" data-svelte-h="svelte-1mgi1e9">user not found</small>` : ``}</label> <input type="text" name="username" id="username" autocomplete="username" class="svelte-fptk26"></field> <field class="svelte-fptk26"><label for="password" class="svelte-fptk26">password

				${form?.missingCredentials ? `<small class="error svelte-fptk26" data-svelte-h="svelte-h2c78g">required</small>` : ``} ${form?.wrongPassword ? `<small class="error svelte-fptk26" data-svelte-h="svelte-1udcg35">wrong password</small>` : ``}</label> <input type="password" name="password" id="password" autocomplete="current-password" class="svelte-fptk26"></field> <button class="svelte-fptk26" data-svelte-h="svelte-1wtvw5p">login</button></form> </div>`;
});
export {
  Page as default
};
