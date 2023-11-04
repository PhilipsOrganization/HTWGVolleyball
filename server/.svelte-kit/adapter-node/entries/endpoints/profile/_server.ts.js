var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { Subscription } from "@lib/database";
import { s as sendNotification } from "../../../chunks/notification.js";
import { r as redirect } from "../../../chunks/index.js";
import { z } from "zod";
const POST = /* @__PURE__ */ __name(async ({
  request,
  locals
}) => {
  if (!locals.user) {
    throw redirect(303, "/login");
  }
  const body = await request.json();
  const safeSubscription = z.object({
    subscription: z.object({
      endpoint: z.string(),
      expirationTime: z.union([z.string(), z.undefined()]),
      keys: z.object({
        p256dh: z.string(),
        auth: z.string()
      })
    })
  }).parse(body);
  const subscription = new Subscription(safeSubscription);
  locals.user.subscription = subscription;
  try {
    await sendNotification(locals.user, "test notification");
  } catch (e) {
    locals.user.subscription = void 0;
  }
  await locals.em.persistAndFlush(locals.user);
  return new Response(JSON.stringify(locals.user.toJSON()));
}, "POST");
const DELETE = /* @__PURE__ */ __name(async ({
  locals
}) => {
  if (!locals.user) {
    throw redirect(303, "/login");
  }
  locals.user.subscription = void 0;
  await locals.em.persistAndFlush(locals.user);
  return new Response(JSON.stringify(locals.user.toJSON()));
}, "DELETE");
export {
  DELETE,
  POST
};
