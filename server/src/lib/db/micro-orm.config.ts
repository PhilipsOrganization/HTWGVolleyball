import { entities } from '$lib/db/entities';
import type { Options } from '@mikro-orm/postgresql';

const env = process.env;

export const config: Options = {
	type: 'postgresql',
	entities,
	discovery: {
		disableDynamicFileAccess: true,
		requireEntitiesArray: true
	},
	host: env.MIKRO_ORM_HOST ?? 'localhost',
	port: parseInt(env.MIKRO_ORM_PORT ?? '5433'),
	user: env.MIKRO_ORM_USER ?? 'postgres',
	password: env.MIKRO_ORM_PASSWORD ?? 'password',
	dbName: env.MIKRO_ORM_DB_NAME ?? 'volleyball',
	cache: {
		enabled: false
	},
	debug: true,
	forceUtcTimezone: true,
	validate: true,
	strict: true,
	migrations: {
		path: './src/lib/db/migrations',
		emit: 'js'
	}
};
