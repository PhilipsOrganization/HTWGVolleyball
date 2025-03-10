import { sql } from 'drizzle-orm';
import { pgTable, serial, varchar, timestamp, index, integer, boolean, primaryKey } from 'drizzle-orm/pg-core';
import type { PostgresJsDatabase } from 'drizzle-orm/postgres-js';

export type DB = PostgresJsDatabase<Record<string, never>>;

export const accounts = pgTable(
	'accounts',
	{
		id: serial('id').primaryKey().notNull(),
		username: varchar('username', { length: 255 }).notNull(),
		email: varchar('email', { length: 255 }).notNull(),
		password: varchar('password', { length: 255 }),
		sessionToken: varchar('session_token', { length: 255 }),
		role: varchar('role', { length: 255 }).default('user').notNull(),
		strikes: integer('strikes').default(0).notNull(),
		notes: varchar('notes', { length: 255 }),
		subscriptionEndpoint: varchar('subscription_endpoint', { length: 255 }),
		subscriptionExpirationTime: varchar('subscription_expiration_time', { length: 255 }),
		subscriptionP256Dh: varchar('subscription_p256dh', { length: 255 }),
		subscriptionAuth: varchar('subscription_auth', { length: 255 }),
		createdAt: timestamp('created_at', { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
		resetToken: varchar('reset_token', { length: 255 }),
		resetTokenExpires: timestamp('reset_token_expires', { withTimezone: true, mode: 'string' }),
		lastLogin: timestamp('last_login', { withTimezone: true, mode: 'string' }),
		emailVerificationToken: varchar('email_verification_token', { length: 255 }),
		emailVerified: boolean('email_verified').default(false).notNull()
	},
	(table) => {
		return {
			sessionTokenIdx: index().on(table.sessionToken),
			emailIdx: index().on(table.email),
			usernameIdx: index().on(table.username)
		};
	}
);

export type Account = typeof accounts.$inferSelect & { canceledAt?: Date | null };

export const courseTemplateTable = pgTable(
	'course_template',
	{
		id: serial('id').primaryKey().notNull(),
		name: varchar('name', { length: 255 }).notNull(),
		maxParticipants: integer('max_participants').notNull(),
		location: varchar('location', { length: 255 }).notNull(),
		time: varchar('time', { length: 255 }).notNull(),
		groupId: integer('group_id').references(() => groups.id, { onUpdate: 'cascade' }),
		// monday is 0, tuesday is 1, ...
		day: integer('day').notNull(),
		publishDay: integer('publish_day').notNull(),
		publishHour: integer('publish_hour').notNull(),
		allowDoubleBookings: boolean('allow_double_bookings').default(false).notNull(),
		autoCreate: boolean('auto_create').default(false).notNull(),
		maxStrikes: integer('max_strikes').default(0).notNull(),
		trainer: integer('trainer').references(() => accounts.id, { onUpdate: 'cascade' })
	},
	(table) => {
		return {
			nameIdx: index().on(table.name)
		};
	}
);

export type CourseTemplate = typeof courseTemplateTable.$inferSelect & {
	date?: Date;
	publishOn?: Date;
	group?: Group;
	trainerName?: string;
};

export const courses = pgTable(
	'courses',
	{
		id: serial('id').primaryKey().notNull(),
		name: varchar('name', { length: 255 }).notNull(),
		date: timestamp('date', { precision: 3, withTimezone: true, mode: 'date' }).notNull(),
		publishOn: timestamp('publish_on', { precision: 3, withTimezone: true, mode: 'date' }).notNull(),
		maxParticipants: integer('max_participants').notNull(),
		location: varchar('location', { length: 255 }).notNull(),
		time: varchar('time', { length: 255 }).notNull(),
		createdAt: timestamp('created_at', { withTimezone: true, mode: 'string' }).notNull(),
		updatedAt: timestamp('updated_at', { withTimezone: true, mode: 'string' }).notNull(),
		notificationSent: boolean('notification_sent').default(false).notNull(),
		allowDoubleBookings: boolean('allow_double_bookings').default(true).notNull(),
		groupId: integer('group_id').references(() => groups.id, { onUpdate: 'cascade' }),
		maxStrikes: integer('max_strikes').default(10).notNull(),
		deletedAt: timestamp('deleted_at', { withTimezone: true, mode: 'string' }),
		fromTemplate: integer('from_template').references(() => courseTemplateTable.id, { onUpdate: 'cascade', onDelete: 'set null' })
	},
	(table) => {
		return {
			nameDateIdx: index().on(table.name, table.date)
		};
	}
);
export type Course = typeof courses.$inferSelect;

export const courseSpots = pgTable(
	'course_spots',
	{
		courseId: integer('course_id')
			.notNull()
			.references(() => courses.id, { onUpdate: 'cascade' }),
		userId: integer('user_id')
			.notNull()
			.references(() => accounts.id, { onUpdate: 'cascade' }),
		createdAt: timestamp('created_at', { withTimezone: true, mode: 'date' }).defaultNow().notNull(),
		deletedAt: timestamp('deleted_at', { withTimezone: true, mode: 'date' })
	},
	(table) => {
		return {
			courseSpotsPkey: primaryKey({ columns: [table.courseId, table.userId], name: 'course_spots_pkey' })
		};
	}
);

export const groups = pgTable(
	'groups',
	{
		id: serial('id').primaryKey().notNull(),
		name: varchar('name', { length: 255 }).notNull()
	},
	(table) => {
		return {
			groupNameIdx: index().on(table.name)
		};
	}
);
export type Group = typeof groups.$inferSelect;

export const groupMembers = pgTable(
	'group_members',
	{
		groupId: integer('group_id')
			.notNull()
			.references(() => groups.id, { onUpdate: 'cascade' }),
		userId: integer('user_id')
			.notNull()
			.references(() => accounts.id, { onUpdate: 'cascade' }),
		createdAt: timestamp('created_at', { withTimezone: true, mode: 'string' }).defaultNow().notNull()
	},
	(table) => {
		return {
			groupMembersPkey: primaryKey({ columns: [table.groupId, table.userId], name: 'group_members_pkey' })
		};
	}
);
