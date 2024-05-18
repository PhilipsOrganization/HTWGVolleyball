import { sequence } from '@sveltejs/kit/hooks';
import * as Sentry from '@sentry/sveltekit';
import type { Handle, HandleServerError } from '@sveltejs/kit';
import { POSTGRES_CONNECTION_STRING } from '$env/static/private';
import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';
import { building, dev } from '$app/environment';
import { accounts, type DB } from '$lib/db/schema.js';
import { eq } from 'drizzle-orm';

Sentry.init({
	dsn: "https://be81ce9ae21bfe95942756c397f31dfe@o4505130185261056.ingest.sentry.io/4506236862988288",
	tracesSampleRate: 1
})

let db: DB;
if (!building) {
	const client = postgres(POSTGRES_CONNECTION_STRING);
	
	db = drizzle(client, { logger: false });
}

export const handle: Handle = sequence(Sentry.sentryHandle(), async ({ event, resolve }) => {
	if (building) {
		return await resolve(event);
	}

	event.locals.db = db;
	const session = event.cookies.get('user');

	if (session) {
		const [user] = await db
			.select()
			.from(accounts)
			.where(eq(accounts.sessionToken, session))
			.limit(1)

		if (user) {
			event.locals.user = user;
		}
	}

	return await resolve(event);
});

const sentry = Sentry.handleErrorWithSentry();

export const handleError: HandleServerError = async (errorEvent) => {
	const { error, event, status, message } = errorEvent;

	console.info(
		new Date().toLocaleDateString(),
		new Date().toLocaleTimeString(),
		`--- ${message.toUpperCase()}: on ${event.request.method.toUpperCase()} ${event.route.id}`
	);

	console.error(error);

	if (dev) {
		return {
			status,
			stack: (error as Error).stack,
			message: message,
		};
	}

	return sentry(errorEvent);
};
