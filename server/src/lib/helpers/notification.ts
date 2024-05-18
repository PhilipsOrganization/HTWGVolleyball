import { env } from '$env/dynamic/private';
import webpush from 'web-push';
import { building } from '$app/environment';
import type { Account } from '$lib/db/schema.js';

const publicVapidKey = env.VITE_VAPID_PUBLIC;
const privateVapidKey = env.VAPID_PRIVATE;

if (!building) {
	if (!publicVapidKey || !privateVapidKey) {
		throw new Error('VAPID keys not set');
	}

	webpush.setVapidDetails('https://volleyballhtwg.netlify.app', publicVapidKey, privateVapidKey);
}


interface NotificationAction {
	action: string;
	title: string;
}

export class BasicAction implements NotificationAction {
	public openUrl?: string;
	constructor(public action: string, public title: string) { }
}

export class OpenCourseAction extends BasicAction {
	constructor(courseId: number) {
		super('open-course', 'Open Course');

		this.openUrl = `/courses/${courseId}`;
	}
}

export class OpenAppAction extends BasicAction {
	constructor() {
		super('open-app', 'Open');
		this.openUrl = '/';
	}
}

export class OpenProfileAction extends BasicAction {
	constructor() {
		super('open-profile', 'Profile');
		this.openUrl = '/profile';
	}
}

export class DropCourseAction extends BasicAction {
	constructor(courseId: number) {
		super('drop-course', 'Drop Course');

		this.openUrl = `/courses/${courseId}`;
	}
}

export async function sendNotification(user: Account, payload: string, actions: NotificationAction[] = []) {
	if (!user.subscriptionEndpoint || !user.subscriptionAuth || !user.subscriptionP256Dh) {
		return;
	}

	const subscription = {
		endpoint: user.subscriptionEndpoint,
		expirationTime: user.subscriptionExpirationTime,
		keys: {
			auth: user.subscriptionAuth,
			p256dh: user.subscriptionP256Dh
		},
	};

	await webpush.sendNotification(subscription, JSON.stringify({ title: payload, actions }));
}
