var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { c as create_ssr_component, e as escape, f as each, d as add_attribute } from "../../../chunks/ssr.js";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "section.svelte-gydgbb{padding:20px}h3.svelte-gydgbb{margin:40px 0 10px 0;font-weight:bold}p.svelte-gydgbb{margin:0;max-width:500px}div#stats.svelte-gydgbb{display:flex;justify-content:center;align-items:center;margin:1rem;width:100%;height:200px}button.svelte-gydgbb{background:#ecfbc7;color:#000;padding:0.5rem 1rem;margin:1rem 0}svg.svelte-gydgbb{width:100%;height:100%}",
  map: null
};
function approximatelyFormatTime(time) {
  const days = Math.floor(time / 60 / 60 / 24);
  const hours = Math.floor(time / 60 / 60) - days * 24;
  const minutes = Math.floor(time / 60) - hours * 60 - days * 24 * 60;
  const seconds = Math.floor(time) - minutes * 60 - hours * 60 * 60 - days * 24 * 60 * 60;
  let result = "";
  if (days > 0) {
    result += `${days} days `;
  }
  if (hours > 0) {
    result += `${hours} hours `;
  }
  if (minutes > 0) {
    result += `${minutes} minutes `;
  }
  result += `${seconds} seconds`;
  return result;
}
__name(approximatelyFormatTime, "approximatelyFormatTime");
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { data } = $$props;
  if ($$props.data === void 0 && $$bindings.data && data !== void 0)
    $$bindings.data(data);
  $$result.css.add(css);
  return `<section class="svelte-gydgbb"><h1 data-svelte-h="svelte-12yu42p">Profile</h1> <h3 class="svelte-gydgbb" data-svelte-h="svelte-4prx8y">Notifications</h3> <p class="svelte-gydgbb" data-svelte-h="svelte-j1ykim">Notifications make it easier to keep up to date. You&#39;ll get a notification when something happens that you might want to know about. You
		can turn them off any time from your profile.</p> ${data.user.hasNotificationsEnabled ? `<button class="svelte-gydgbb" data-svelte-h="svelte-6ftcb7">Disable notifications</button>` : `<button class="svelte-gydgbb" data-svelte-h="svelte-xhaelj">Enable notifications</button>`} <h3 class="svelte-gydgbb" data-svelte-h="svelte-5zwsxb">Stats</h3> <p class="svelte-gydgbb">Registered for ${escape(data.totalRegistrations)} courses</p> ${data.stats.length ? each(data.stats, (course) => {
    return `<p class="svelte-gydgbb">${escape(course.courseName)}: ${escape(course.count)}</p>`;
  }) : `<p class="svelte-gydgbb" data-svelte-h="svelte-16dpfrj">No courses registered</p>`} ${data.registrationStats ? `<p class="svelte-gydgbb">Average Registration time: ${escape(approximatelyFormatTime(data.registrationStats.averageTime))}</p> <p class="svelte-gydgbb">Fastest Registration time: ${escape(approximatelyFormatTime(data.registrationStats.minTime))}</p>` : ``} <div id="stats" class="svelte-gydgbb"><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" class="svelte-gydgbb"><path fill="none" stroke="grey"${add_attribute("d", data.svg, 0)}></path></svg></div> </section>`;
});
export {
  Page as default
};
