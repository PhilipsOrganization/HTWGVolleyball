import { Role } from '$lib/db/role';
import { accounts, courseSpots, courses, groupMembers, groups } from '$lib/db/schema';
import { sendEmail } from '$lib/email';
import AdminEmail from '$lib/email/templates/admin-email.svelte';
import ResetPassword from '$lib/email/templates/reset-password.svelte';
import { generateRandomToken, serializeUser } from '$lib/helpers/account';
import { error, fail, redirect, type Actions } from '@sveltejs/kit';
import { count, eq, exists, sql } from 'drizzle-orm';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals, params }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/login');
	}

	const userIdString = params.id as string | undefined;
	if (!userIdString) {
		error(400, 'No userId provided');
	}

	const userId = parseInt(userIdString);
	const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

	if (!user) {
		error(400, 'User not found');
	}

	const stats = await locals.db
		.select({ courseName: courses.name, count: count(courses.name) })
		.from(courseSpots)
		.innerJoin(courses, eq(courseSpots.courseId, courses.id))
		.where(eq(courseSpots.userId, userId))
		.groupBy(courses.name)
		.limit(10);

	const timeDiff = sql`least(extract(epoch from ${courseSpots.createdAt}) - extract(epoch from ${courses.publishOn}), 0)`;
	const [registrationStats] = await locals.db
		.select({
			avg: sql<number>`avg(${timeDiff})`.as('avg'),
			min: sql<number>`min(${timeDiff})`.as('min')
		})
		.from(courseSpots)
		.leftJoin(courses, eq(courseSpots.courseId, courses.id))
		.where(eq(courseSpots.userId, userId))
		.groupBy(courseSpots.userId)
		.limit(1);

	const [totalRegistrations] = await locals.db.select({ count: count() }).from(courseSpots).where(eq(courseSpots.userId, userId)).limit(1);

	let allGroups: {
		id: number;
		name: string;
		isMember: unknown;
	}[] = [];

	// Only show groups if user is not an admin, admins can see all groups
	if (user.role === Role.USER) {
		const membership = locals.db
			.select({
				id: groups.id
			})
			.from(groupMembers)
			.where(eq(groupMembers.userId, userId))
			.leftJoin(groups, eq(groupMembers.groupId, groups.id));

		allGroups = await locals.db
			.select({
				id: groups.id,
				name: groups.name,
				isMember: exists(membership)
			})
			.from(groups);
	}

	return {
		user: serializeUser(user),
		globalUser: serializeUser(locals.user),
		stats,
		registrationStats,
		totalRegistrations: totalRegistrations.count,
		groups: allGroups
		// svg: getPath(totalRegistrations)
	};
};

export const actions = {
	demote: async ({ locals, params }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

		if (!user) {
			error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			error(400, 'Cannot demote super admin');
		}

		await locals.db.update(accounts).set({ role: Role.USER }).where(eq(accounts.id, userId));
	},
	promote: async ({ locals, params }) => {
		if (locals.user?.role !== Role.ADMIN && locals.user?.role !== Role.SUPER_ADMIN) {
			redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

		if (!user) {
			error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			error(400, 'Cannot promote super admin');
		}

		await locals.db.update(accounts).set({ role: Role.ADMIN }).where(eq(accounts.id, userId));
	},
	note: async ({ locals, params, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const form = await request.formData();
		const notes = form.get('notes') as string | undefined;

		await locals.db.update(accounts).set({ notes }).where(eq(accounts.id, userId));
	},
	unstrike: async ({ locals, params }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		await locals.db
			.update(accounts)
			.set({ strikes: sql<number>`GREATEST(0, ${accounts.strikes} - 1)` })
			.where(eq(accounts.id, userId));
	},
	delete: async ({ locals, params }) => {
		if (!locals.user || locals.user.role !== Role.SUPER_ADMIN) {
			redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

		if (!user) {
			error(400, 'User not found');
		}

		if (user.role !== Role.USER) {
			error(400, 'Cannot delete user');
		}

		await locals.db.transaction(async (db) => {
			await db.delete(courseSpots).where(eq(courseSpots.userId, userId));
			await db.delete(accounts).where(eq(accounts.id, userId));
		});

		redirect(303, '/admin/users');
	},
	'reset-pw': async ({ locals, params }) => {
		if (!locals.user || locals.user.role !== Role.SUPER_ADMIN) {
			redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);
		if (!user) {
			error(400, 'User not found');
		}

		const token = generateRandomToken();

		await locals.db
			.update(accounts)
			.set({
				resetToken: token,
				resetTokenExpires: sql<Date>`NOW() + INTERVAL '1 day'`
			})
			.where(eq(accounts.id, userId));

		await sendEmail(ResetPassword, { user, subject: 'Reset Password', props: { user, token } });
	},
	sendEmail: async ({ locals, params, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, 'No userId provided');
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

		if (!user) {
			error(400, 'User not found');
		}

		const form = await request.formData();
		const subject = form.get('subject') as string | undefined;
		const body = form.get('message') as string | undefined;

		if (!subject || !body) {
			return fail(400, { error: 'Missing subject or body', body, subject });
		}

		if (subject.length > 200 || body.length > 4000) {
			return fail(400, { error: 'Subject or body too long', body, subject });
		}

		if (subject.includes('\n')) {
			return fail(400, { error: 'Subject contains newlines', body, subject });
		}

		if (subject.length < 5 || body.length < 5) {
			return fail(400, { error: 'Subject or body too short', body, subject });
		}

		const message = body.replace(/\n/g, '<br>').replace(/\r/g, '').replace(/\t/g, '    ').replace(/ {2}/g, ' &nbsp;');

		await sendEmail(AdminEmail, {
			subject,
			user,
			props: {
				user,
				subject,
				message,
				trainer: locals.user
			}
		});

		return { body: '', subject: '' };
	},
	'update-groups': async ({ locals, params, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const userId = parseInt(params.id as string);
		if (userId === undefined || isNaN(userId)) {
			error(400, 'No userId provided');
		}

		const [user] = await locals.db.select().from(accounts).where(eq(accounts.id, userId)).limit(1);

		if (!user || user.role !== Role.USER) {
			error(400, 'User cannot be assigned to a group');
		}

		const form = await request.formData();
		const groups = form.get('groups') as string[] | string | undefined;

		if (!groups) {
			error(400, 'No groups provided');
		}

		const groupIds = Array.isArray(groups) ? groups.map((g) => parseInt(g)) : [parseInt(groups)];

		if (groupIds.some((g) => isNaN(g))) {
			error(400, 'Invalid group id');
		}

		await locals.db.transaction(async (db) => {
			await db.delete(groupMembers).where(eq(groupMembers.userId, userId));

			for (const groupId of groupIds) {
				await db.insert(groupMembers).values({ userId, groupId }).returning();
			}
		});

		redirect(303, `/admin/users/${userId}/stats`);
	}
} satisfies Actions;
