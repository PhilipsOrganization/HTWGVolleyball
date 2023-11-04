// src/notification.ts
import webpush from "web-push";
var publicVapidKey;
var privateVapidKey;
function setEnv(env) {
  publicVapidKey = env.VITE_VAPID_PUBLIC;
  privateVapidKey = env.VAPID_PRIVATE;
  if (!publicVapidKey || !privateVapidKey) {
    throw new Error("VAPID keys not set");
  }
  webpush.setVapidDetails("https://volleyballhtwg.netlify.app", publicVapidKey, privateVapidKey);
}
async function sendNotification(user, payload) {
  const subscription = user.subscription;
  if (!subscription) {
    return;
  }
  await webpush.sendNotification(subscription.toJSON(), JSON.stringify({ title: payload }));
}
export {
  sendNotification,
  setEnv
};
//# sourceMappingURL=index.js.map