var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { c as create_ssr_component, b as subscribe, d as add_attribute, f as each, e as escape, v as validate_component } from "../../../chunks/ssr.js";
import { p as page } from "../../../chunks/stores.js";
import { h as humanReadableDate, C as Course } from "../../../chunks/date.js";
import { nextMonday, nextThursday, nextWednesday, nextSaturday, addDays, setMinutes, setHours } from "date-fns";
const createCourse_svelte_svelte_type_style_lang = "";
const css$1 = {
  code: "dialog.svelte-17s4yd7.svelte-17s4yd7{position:relative;padding:12px 3em 30px;width:min(90vw, 400px);max-width:calc(100vw - 9em);background:#383838;color:rgb(182, 182, 182);border-radius:8px}h1.svelte-17s4yd7.svelte-17s4yd7{color:#e0e0e0}#open.svelte-17s4yd7.svelte-17s4yd7{position:fixed;bottom:1em;right:1em;z-index:100}#close.svelte-17s4yd7.svelte-17s4yd7{position:absolute;inset:10px 10px auto auto;padding:0.5em 0.75em;background:rgb(19, 19, 19);border:none;border-radius:50%;font-size:1.5em;line-height:1;cursor:pointer}#submit.svelte-17s4yd7.svelte-17s4yd7{min-width:60%}form.svelte-17s4yd7.svelte-17s4yd7{display:flex;flex-direction:column}form.svelte-17s4yd7 field.svelte-17s4yd7{display:flex;flex-direction:column;margin-bottom:1rem}form.svelte-17s4yd7 field label.svelte-17s4yd7{margin-bottom:0.5rem}form.svelte-17s4yd7 field input.svelte-17s4yd7,form.svelte-17s4yd7 field select.svelte-17s4yd7{padding:0.5rem;border:1px solid #ccc;border-radius:0.25rem;color:#e0e0e0}input.svelte-17s4yd7.svelte-17s4yd7,select.svelte-17s4yd7.svelte-17s4yd7,option.svelte-17s4yd7.svelte-17s4yd7{background:#1f1f1f;color:#fff;font-size:16px}form.svelte-17s4yd7 field input.svelte-17s4yd7:focus{outline:none;border-color:#000}#submit.svelte-17s4yd7.svelte-17s4yd7{background:#9cc1cf;color:#000;padding:1rem 2rem;text-align:center}",
  map: null
};
function padNumberToTwoDigits(number) {
  return number.toString().padStart(2, "0");
}
__name(padNumberToTwoDigits, "padNumberToTwoDigits");
function dateTimeToDateString(date) {
  if (!date)
    return "";
  const components = [
    date.getFullYear(),
    padNumberToTwoDigits(date.getMonth() + 1),
    padNumberToTwoDigits(date.getDate())
  ];
  return components.join("-");
}
__name(dateTimeToDateString, "dateTimeToDateString");
function dateTimeToString(date) {
  if (!date)
    return "";
  const components = [
    dateTimeToDateString(date),
    "T",
    padNumberToTwoDigits(date.getHours()),
    ":",
    padNumberToTwoDigits(date.getMinutes())
  ];
  return components.join("");
}
__name(dateTimeToString, "dateTimeToString");
const CreateCourse = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let form;
  let defaults;
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  const difficulties = [
    "Beginner",
    "Advanced",
    "Actives",
    "Beach Course",
    "Actives - 5:1 System",
    "Free Game",
    "Christmas Special🎄"
  ];
  let name = "Beginner";
  let dialogEl;
  let courses = [];
  reset();
  function reset() {
    courses = [
      {
        name: difficulties[0],
        settings: {
          name: difficulties[0],
          location: "Ellenrieder Sporthalle",
          maxParticipants: 18,
          time: "17:30",
          duration: 1.5,
          date: nextMonday(/* @__PURE__ */ new Date()),
          publishOn: setTo12(nextThursday(/* @__PURE__ */ new Date()))
        }
      },
      {
        name: difficulties[1],
        settings: {
          name: difficulties[1],
          location: "Ellenrieder Sporthalle",
          maxParticipants: 18,
          time: "19:00",
          duration: 1.5,
          date: nextMonday(/* @__PURE__ */ new Date()),
          publishOn: setTo12(nextThursday(/* @__PURE__ */ new Date()))
        }
      },
      {
        name: difficulties[2],
        settings: {
          name: difficulties[2],
          location: "Ellenrieder Sporthalle",
          maxParticipants: 18,
          time: "20:30",
          duration: 1.5,
          date: nextMonday(/* @__PURE__ */ new Date()),
          publishOn: setTo12(nextThursday(/* @__PURE__ */ new Date()))
        }
      },
      {
        name: difficulties[4],
        settings: {
          name: difficulties[4],
          location: "Ellenrieder Sporthalle",
          maxParticipants: 18,
          time: "20:30",
          duration: 1.5,
          date: nextWednesday(/* @__PURE__ */ new Date()),
          publishOn: setTo12(nextThursday(/* @__PURE__ */ new Date()))
        }
      },
      {
        name: difficulties[5],
        settings: {
          name: difficulties[5],
          location: "Petershausener Sporthalle",
          maxParticipants: 36,
          time: "12:00",
          duration: 1.5,
          date: nextSaturday(addDays(/* @__PURE__ */ new Date(), 7)),
          publishOn: setTo12(nextThursday(/* @__PURE__ */ new Date()))
        }
      }
    ];
  }
  __name(reset, "reset");
  function setTo12(date) {
    return setMinutes(setHours(date, 12), 0);
  }
  __name(setTo12, "setTo12");
  $$result.css.add(css$1);
  form = $page.form;
  defaults = courses.find((c) => c.name === name)?.settings;
  $$unsubscribe_page();
  return `<button class="highlight svelte-17s4yd7" id="open" data-svelte-h="svelte-gn4zkc">Create Course</button> <dialog class="svelte-17s4yd7"${add_attribute("this", dialogEl, 0)}><h1 class="svelte-17s4yd7" data-svelte-h="svelte-1rzav2z">New Course</h1> <form method="POST" action="?/create-course" class="svelte-17s4yd7"><button id="close" value="cancel" formmethod="dialog" class="svelte-17s4yd7" data-svelte-h="svelte-1en8m32">x</button> <field class="svelte-17s4yd7"><label for="name" class="svelte-17s4yd7" data-svelte-h="svelte-bs9sy6">Name</label> <select name="name" class="svelte-17s4yd7">${each(difficulties, (difficulty) => {
    return `<option${add_attribute("value", difficulty, 0)} class="svelte-17s4yd7">${escape(difficulty)}</option>`;
  })}</select> <small class="error">${escape(form?.name ?? "")}</small></field> <field class="svelte-17s4yd7"><label for="location" class="svelte-17s4yd7" data-svelte-h="svelte-xq6d6e">Location</label> <input${add_attribute("value", defaults?.location ?? "", 0)} type="text" name="location" placeholder="Location" class="svelte-17s4yd7"> <small class="error">${escape(form?.location ?? "")}</small></field> <field class="svelte-17s4yd7"><label for="date" class="svelte-17s4yd7" data-svelte-h="svelte-mio0sa">Date</label> <input${add_attribute("value", dateTimeToDateString(defaults?.date), 0)} type="date" name="date" placeholder="Date" class="svelte-17s4yd7"> <small class="error">${escape(form?.date ?? "")}</small></field> <field class="svelte-17s4yd7"><label for="time" class="svelte-17s4yd7" data-svelte-h="svelte-unupva">Time</label> <input${add_attribute("value", defaults?.time ?? "", 0)} type="time" name="time" placeholder="Time" class="svelte-17s4yd7"> <small class="error">${escape(form?.time ?? "")}</small></field> <field class="svelte-17s4yd7"><label for="maxParticipants" class="svelte-17s4yd7" data-svelte-h="svelte-uutuni">Max Participants</label> <input${add_attribute("value", defaults?.maxParticipants ?? "", 0)} type="number" name="maxParticipants" placeholder="Max Participants" class="svelte-17s4yd7"> <small class="error">${escape(form?.maxParticipants ?? "")}</small></field> <field class="svelte-17s4yd7"><label for="publishOn" class="svelte-17s4yd7" data-svelte-h="svelte-17634d8">Publish On</label> <input${add_attribute("value", dateTimeToString(defaults?.publishOn), 0)} type="datetime-local" name="publishOn" placeholder="Publish On" class="svelte-17s4yd7"> <small class="error">${escape(form?.publishOn ?? "")}</small></field> <button id="submit" class="svelte-17s4yd7" data-svelte-h="svelte-19wxm4m">Submit</button></form> </dialog>`;
});
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: "main.svelte-8e4acl{display:flex;flex-direction:column;margin:0 auto 15dvh;width:90vw;max-width:700px;box-sizing:border-box}#list.svelte-8e4acl{margin-top:2rem;flex:1;display:flex;flex-direction:column}#block.svelte-8e4acl{flex:1;display:flex;flex-direction:column;margin-bottom:6rem}h2.svelte-8e4acl{text-align:center;margin:0 0 2rem;text-transform:capitalize}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => value);
  let { data } = $$props;
  if ($$props.data === void 0 && $$bindings.data && data !== void 0)
    $$bindings.data(data);
  $$result.css.add(css);
  $$unsubscribe_page();
  return `${validate_component(CreateCourse, "CreateCourse").$$render($$result, {}, {}, {})} <main class="svelte-8e4acl"><div><label for="archived" data-svelte-h="svelte-czcojv">Show archived</label> <input type="checkbox" id="archived"></div> <div id="list" class="svelte-8e4acl">${each(data.dates ?? [], (block) => {
    return `<div id="block" class="svelte-8e4acl"><h2 class="svelte-8e4acl">${escape(humanReadableDate(block.date))}</h2> ${each(block.courses, (course, i) => {
      return `${validate_component(Course, "Course").$$render($$result, { course, admin: true, isFirst: i === 0 }, {}, {})}`;
    })} </div>`;
  })} ${data.dates?.length === 0 ? `There are currently no courses. ☹` : ``}</div> </main>`;
});
export {
  Page as default
};
