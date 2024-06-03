import { Role } from '$lib/db/role';
import { accounts, courseSpots, courses } from '$lib/db/schema';
import { sendEmail } from '$lib/email';
import ResetPassword from '$lib/email/templates/reset-password.svelte';
import { generateRandomToken, serializeUser } from '$lib/helpers/account';
import { error, fail, redirect, type Actions } from '@sveltejs/kit';
import { count, eq, sql } from 'drizzle-orm';
import type { PageServerLoad } from './$types';
import AdminEmail from '$lib/email/templates/admin-email.svelte';

export const load: PageServerLoad = async ({ locals, params }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	const userIdString = params.id as string | undefined;
	if (!userIdString) {
		error(400, 'No userId provided');
	}

	const userId = parseInt(userIdString);
	const [user] = await locals.db
		.select()
		.from(accounts)
		.where(eq(accounts.id, userId))
		.limit(1);

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
	const [registrationStats] = await locals.db.select({
		avg: sql<number>`avg(${timeDiff})`.as('avg'),
		min: sql<number>`min(${timeDiff})`.as('min'),
	})
		.from(courseSpots)
		.leftJoin(courses, eq(courseSpots.courseId, courses.id))
		.where(eq(courseSpots.userId, userId))
		.groupBy(courseSpots.userId)
		.limit(1);

	const [totalRegistrations] = await locals.db.select({ count: count() })
		.from(courseSpots)
		.where(eq(courseSpots.userId, userId))
		.limit(1);

	return {
		user: serializeUser(user),
		stats,
		registrationStats,
		totalRegistrations: totalRegistrations.count,
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
		const [user] = await locals.db
			.select()
			.from(accounts)
			.where(eq(accounts.id, userId))
			.limit(1);

		if (!user) {
			error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			error(400, 'Cannot demote super admin');
		}

		await locals.db
			.update(accounts)
			.set({ role: Role.USER })
			.where(eq(accounts.id, userId));
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
		const [user] = await locals.db.
			select()
			.from(accounts)
			.where(eq(accounts.id, userId))
			.limit(1);

		if (!user) {
			error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			error(400, 'Cannot promote super admin');
		}

		await locals.db
			.update(accounts)
			.set({ role: Role.ADMIN })
			.where(eq(accounts.id, userId));
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

		await locals.db
			.update(accounts)
			.set({ notes })
			.where(eq(accounts.id, userId));
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
			redirect(303, "/login");
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, "No userId provided");
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db
			.select()
			.from(accounts)
			.where(eq(accounts.id, userId))
			.limit(1);

		if (!user) {
			error(400, "User not found");
		}

		if (user.role !== Role.USER) {
			error(400, "Cannot delete user");
		}

		await locals.db.transaction(async db => {
			await db.delete(courseSpots).where(eq(courseSpots.userId, userId));
			await db.delete(accounts).where(eq(accounts.id, userId));
		});

		redirect(303, "/admin/users");
	},
	"reset-pw": async ({ locals, params }) => {
		if (!locals.user || locals.user.role !== Role.SUPER_ADMIN) {
			redirect(303, "/login");
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, "No userId provided");
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db
			.select()
			.from(accounts)
			.where(eq(accounts.id, userId))
			.limit(1);
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

		await sendEmail(ResetPassword, { user, subject: "Reset Password", props: { user, token } });
	},
	sendEmail: async ({ locals, params, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, "/login");
		}

		const userIdString = params.id as string | undefined;
		if (!userIdString) {
			error(400, "No userId provided");
		}

		const userId = parseInt(userIdString);
		const [user] = await locals.db
			.select()
			.from(accounts)
			.where(eq(accounts.id, userId))
			.limit(1);

		if (!user) {
			error(400, "User not found");
		}

		const form = await request.formData();
		const subject = form.get('subject') as string | undefined;
		const body = form.get('message') as string | undefined;

		if (!subject || !body) {
			return fail(400, { error: "Missing subject or body", body, subject });
		}

		if (subject.length > 200 || body.length > 4000) {
			return fail(400, { error: "Subject or body too long", body, subject });
		}

		if (subject.includes('\n')) {
			return fail(400, { error: "Subject contains newlines", body, subject });
		}

		if (subject.length < 5 || body.length < 5) {
			return fail(400, { error: "Subject or body too short", body, subject });
		}

		const message = body
			.replace(/\n/g, '<br>')
			.replace(/\r/g, '')
			.replace(/\t/g, '    ')
			.replace(/ {2}/g, ' &nbsp;');

		await sendEmail(AdminEmail, {
			subject, user, props: {
				user,
				subject,
				message,
				trainer: locals.user,
			}
		});

		return { body: "", subject: "" };
	}
} satisfies Actions;
