import type { Handle } from '@sveltejs/kit';
import { config } from './lib/db/micro-orm.config';
import { MikroORM } from '@mikro-orm/core';
import type { SqlEntityManager } from '@mikro-orm/postgresql';
import { User } from '$lib/db/entities';
import { building } from '$app/environment';

let orm: MikroORM;
if (!building) {
	orm = await MikroORM.init(config);

	const migrator = orm.getMigrator();
	await migrator.createMigration();
	await migrator.up();
}

export const handle: Handle = async ({ event, resolve }) => {
	if (building) {
		return await resolve(event);
	}

	event.locals.em = orm.em.fork() as SqlEntityManager;
	const session = event.cookies.get('user');

	if (session) {
		const user = await event.locals.em.findOne(
			User,
			{ sessionToken: session },
			{ populate: ['courses'] }
		);
		if (user) {
			event.locals.user = user;
		}
	}

	return await resolve(event);
};
