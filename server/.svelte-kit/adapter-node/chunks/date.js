var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { c as create_ssr_component, d as add_attribute, g as add_styles, e as escape } from "./ssr.js";
import { isSameDay, differenceInCalendarDays, isAfter, differenceInCalendarISOWeeks } from "date-fns";
const course_svelte_svelte_type_style_lang = "";
const css = {
  code: "div.svelte-1glm4wv.svelte-1glm4wv{display:grid;grid-template-columns:1fr 1fr 1fr;padding:1rem 2rem;border-bottom:1px solid #5d5d5d;view-transition-name:var(--course-transition)}div.first.svelte-1glm4wv.svelte-1glm4wv{border-top:1px solid #5d5d5d}span.svelte-1glm4wv.svelte-1glm4wv{font-weight:200}span.svelte-1glm4wv.svelte-1glm4wv:nth-child(2){text-align:center}a.right.svelte-1glm4wv.svelte-1glm4wv{display:flex;justify-content:flex-end}p.svelte-1glm4wv.svelte-1glm4wv{all:unset;min-width:8ch;text-align:center}.underline.svelte-1glm4wv.svelte-1glm4wv{text-decoration:underline}.enlisted.svelte-1glm4wv.svelte-1glm4wv{background-color:#9cc1cf;color:#000}.enlisted.svelte-1glm4wv span.svelte-1glm4wv{font-weight:bold}.isPast.svelte-1glm4wv.svelte-1glm4wv{opacity:0.7}.on-waitlist.svelte-1glm4wv.svelte-1glm4wv{background-color:#eb714f}",
  map: null
};
const Course = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { course } = $$props;
  let { isFirst = false } = $$props;
  let { admin = false } = $$props;
  const spot = course.spot + 1;
  const waitlistSpot = spot - course.maxParticipants;
  const href = `courses/${course.id}${admin ? "?admin" : ""}`;
  if ($$props.course === void 0 && $$bindings.course && course !== void 0)
    $$bindings.course(course);
  if ($$props.isFirst === void 0 && $$bindings.isFirst && isFirst !== void 0)
    $$bindings.isFirst(isFirst);
  if ($$props.admin === void 0 && $$bindings.admin && admin !== void 0)
    $$bindings.admin(admin);
  $$result.css.add(css);
  return `<a${add_attribute("href", href, 0)}><div aria-roledescription="course" class="${[
    "svelte-1glm4wv",
    (course.isEnrolled ? "enlisted" : "") + " " + (waitlistSpot > 0 ? "on-waitlist" : "") + " " + (isFirst ? "first" : "") + " " + (course.isPast ? "isPast" : "")
  ].join(" ").trim()}"${add_styles({
    "--course-transition": `course-${course.id}`
  })}><span class="svelte-1glm4wv">${escape(course.name)}</span> ${course.isEnrolled ? `${waitlistSpot > 0 ? `<span class="svelte-1glm4wv">waitlist: #${escape(waitlistSpot)}</span>` : `<span class="svelte-1glm4wv">#${escape(spot)}</span>`}` : `<span class="svelte-1glm4wv">${escape(course.signupCount)}/${escape(course.maxParticipants)}</span>`} <a class="underline right svelte-1glm4wv"${add_attribute("href", href, 0)}><p class="svelte-1glm4wv">${admin || course.isPast ? `details` : `${escape(course.isEnrolled ? "drop " : "enlist")}`}</p></a></div> </a>`;
});
function humanReadableDate(date) {
  if (!date) {
    return "no date";
  }
  const comp = new Date(date);
  const today = /* @__PURE__ */ new Date();
  if (isSameDay(comp, today)) {
    return "today";
  }
  const days = differenceInCalendarDays(comp, today);
  if (days === 1) {
    return "tomorrow";
  }
  if (days === -1) {
    return "yesterday";
  }
  const weekday = Intl.DateTimeFormat("en-US", {
    weekday: "long"
  }).format(comp);
  if (Math.abs(days) < 4) {
    const past = isAfter(today, comp);
    return `${weekday}, ${past ? "" : "in"} ${Math.abs(days)} days ${past ? "ago" : ""}`;
  }
  const weeks = differenceInCalendarISOWeeks(comp, today);
  if (weeks === 0) {
    let modifier = "";
    if (isAfter(today, comp)) {
      modifier = "last";
    } else {
      modifier = "on";
    }
    return `${modifier} ${weekday}`;
  }
  if (weeks === -1) {
    return "last week on " + weekday;
  }
  if (weeks === 1) {
    return "next week on " + weekday;
  }
  if (Math.abs(weeks) < 4) {
    const day = comp.toLocaleDateString("en-US", {
      month: "short",
      day: "numeric"
    });
    return `on ${day}`;
  }
  return comp.toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric"
  });
}
__name(humanReadableDate, "humanReadableDate");
export {
  Course as C,
  humanReadableDate as h
};
