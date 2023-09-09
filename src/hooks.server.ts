import type { Handle } from '@sveltejs/kit';
import { config } from './lib/db/micro-orm.config';
import { MikroORM } from '@mikro-orm/core';
import type { SqlEntityManager } from '@mikro-orm/sqlite';

const orm = await MikroORM.init(config);

const migrator = orm.getMigrator()
await migrator.createMigration()
await migrator.up()


export const handle: Handle = async ({ event, resolve }) => {
    event.locals.em = orm.em.fork() as SqlEntityManager;
    return await resolve(event);
};