import type { User } from '@lib/database';
import webpush from 'web-push';

let publicVapidKey: string;
let privateVapidKey: string;

export function setEnv(env: any) {
	publicVapidKey = env.VITE_VAPID_PUBLIC;
	privateVapidKey = env.VAPID_PRIVATE;

	if (!publicVapidKey || !privateVapidKey) {
		throw new Error('VAPID keys not set');
	}

	webpush.setVapidDetails('https://volleyballhtwg.netlify.app', publicVapidKey, privateVapidKey);
}


export async function sendNotification(user: User, payload: string) {
	const subscription = user.subscription;

	if (!subscription) {
		return;
	}

	await webpush.sendNotification(subscription.toJSON(), JSON.stringify({ title: payload }));
}
