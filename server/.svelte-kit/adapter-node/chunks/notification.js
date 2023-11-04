var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import webpush from "web-push";
let publicVapidKey;
let privateVapidKey;
function setEnv(env) {
  publicVapidKey = env.VITE_VAPID_PUBLIC;
  privateVapidKey = env.VAPID_PRIVATE;
  if (!publicVapidKey || !privateVapidKey) {
    throw new Error("VAPID keys not set");
  }
  webpush.setVapidDetails("https://volleyballhtwg.netlify.app", publicVapidKey, privateVapidKey);
}
__name(setEnv, "setEnv");
async function sendNotification(user, payload) {
  const subscription = user.subscription;
  if (!subscription) {
    return;
  }
  await webpush.sendNotification(subscription.toJSON(), JSON.stringify({
    title: payload
  }));
}
__name(sendNotification, "sendNotification");
export {
  setEnv as a,
  sendNotification as s
};
