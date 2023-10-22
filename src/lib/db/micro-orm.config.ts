import { entities } from '$lib/db/entities';
import type { Options } from '@mikro-orm/sqlite';

export const config: Options = {
	type: 'sqlite',
	dbName: './db/prod.db',
	entities,
	discovery: {
		disableDynamicFileAccess: true,
		requireEntitiesArray: true,
	},
	cache: {
		enabled: false,
	},
	debug: true,
	forceUtcTimezone: true,
	validate: true,
	strict: true,
	migrations: {
		emit: 'js'
	}
};
