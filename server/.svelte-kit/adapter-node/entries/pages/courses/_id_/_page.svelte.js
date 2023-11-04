import { c as create_ssr_component, b as subscribe, e as escape, g as add_styles, d as add_attribute, f as each } from "../../../../chunks/ssr.js";
import { p as page } from "../../../../chunks/stores.js";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "main.svelte-1yt5khl,section.svelte-1yt5khl{flex:1;display:flex;flex-direction:column}section.svelte-1yt5khl{justify-content:center;max-height:400px;padding-top:2rem}h2.svelte-1yt5khl,p.svelte-1yt5khl{text-align:center}h2.svelte-1yt5khl{margin:0 0 2rem}p.svelte-1yt5khl{margin-bottom:0.4rem}.isSignedUp.svelte-1yt5khl{color:#9cc1cf;font-weight:800}.waitList.svelte-1yt5khl{color:#eb714f}div.actions.svelte-1yt5khl{view-transition-name:var(--course-transition);display:flex;flex-direction:row;justify-content:space-between;background:#ecfbc7;padding:1rem 2rem;width:min(80%, 450px);max-width:60vw;margin:2rem auto 4rem;color:black}button.svelte-1yt5khl:disabled{opacity:0.5;cursor:not-allowed}div.actions.waitList.svelte-1yt5khl{background:#eb714f}#users.svelte-1yt5khl{display:flex;flex-direction:column;margin:0 auto;width:min(80%, 450px)}.user.svelte-1yt5khl{display:flex;flex-direction:row;justify-content:space-between;align-items:center;margin-bottom:0.5rem}.underline.svelte-1yt5khl{text-decoration:underline}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let { data } = $$props;
  let course = data.course;
  const intl = new Intl.DateTimeFormat(
    "de-DE",
    {
      weekday: "long",
      year: "numeric",
      month: "numeric",
      day: "numeric"
    }
  );
  const admin = $page.url.searchParams.has("admin");
  const waitList = course.signupCount > course.maxParticipants;
  if ($$props.data === void 0 && $$bindings.data && data !== void 0)
    $$bindings.data(data);
  $$result.css.add(css);
  $$unsubscribe_page();
  return `<main class="svelte-1yt5khl"><section class="svelte-1yt5khl"><h2 class="svelte-1yt5khl">${escape(course.name)} ${course.isEnrolled ? `<small class="isSignedUp svelte-1yt5khl" data-svelte-h="svelte-1vw8xnf">- registered</small>` : ``}</h2> <p class="bold svelte-1yt5khl">${escape(course.time)}</p> <p class="svelte-1yt5khl">${escape(intl.format(course.date))}</p> <p class="svelte-1yt5khl">${escape(course.location)}</p> ${admin ? (() => {
    let intlAdmin = new Intl.DateTimeFormat(
      "de-DE",
      {
        weekday: "long",
        year: "numeric",
        month: "numeric",
        day: "numeric",
        hour: "numeric",
        minute: "numeric"
      }
    );
    return ` <p class="svelte-1yt5khl">Is published on: ${escape(intlAdmin.format(course.publishOn))}</p>`;
  })() : ``} <p class="${["svelte-1yt5khl", waitList ? "waitList" : ""].join(" ").trim()}">${escape(course.signupCount)}/${escape(course.maxParticipants)} Registrations</p></section> <div class="${["actions svelte-1yt5khl", waitList ? "waitList" : ""].join(" ").trim()}"${add_styles({
    "--course-transition": `course-${course.id}`
  })}><a${add_attribute("href", admin ? "/admin" : "/courses", 0)}>back</a> ${admin ? `<form class="waitlist" action="?/delete-course" method="post" data-svelte-h="svelte-d1j4ao"><button type="submit" class="svelte-1yt5khl">delete</button></form>` : ``} <form${add_attribute("action", `?/${course.isEnrolled ? "drop" : "enlist"}${admin ? "&admin" : ""}`, 0)} method="post"><button type="submit" ${course.isPast ? "disabled" : ""} class="svelte-1yt5khl">${course.isEnrolled ? `drop` : `enlist`}</button></form></div> ${admin ? `<div id="users" class="svelte-1yt5khl"><h2 class="svelte-1yt5khl" data-svelte-h="svelte-7f4q50">Participants</h2> ${(course.participants ?? []).length ? each(course.participants ?? [], (participant) => {
    return `<div class="user svelte-1yt5khl"><span>${escape(participant.username)}</span> <a href="${"/admin/users/" + escape(participant.id, true) + "/stats"}">ⓘ</a> <form action="?/cancel" method="post"><input type="hidden" name="userId"${add_attribute("value", participant.id, 0)}> <button class="underline svelte-1yt5khl" data-svelte-h="svelte-1y6edcr">cancel</button></form> </div>`;
  }) : `<p class="svelte-1yt5khl" data-svelte-h="svelte-1btjsou">There are currently no participants. ☹</p>`}</div>` : ``} </main>`;
});
export {
  Page as default
};
