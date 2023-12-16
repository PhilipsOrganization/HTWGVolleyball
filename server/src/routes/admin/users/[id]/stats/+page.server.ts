import { UserStats } from '$lib/db/entities/user-stats';
import { Role } from '$lib/db/role';
import { error, redirect, type Actions } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { Course, User } from '$lib/db/entities';
import { getPath } from '$lib/helpers/stats';
import { sendEmail } from '$lib/email';
import ResetPassword from '$lib/email/templates/reset-password.svelte';

export const load: PageServerLoad = async ({ locals, params }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	const user = await locals.em.findOneOrFail(User, { id: parseInt(params.id) });
	const stats = await locals.em.find(UserStats, { userId: parseInt(params.id) });
	const totalRegistrations = await locals.em.find(Course, { users: user }, { populate: [], fields: ['date'], orderBy: { date: 'ASC' } });

	return {
		user: user.toJSON(),
		stats: stats.map((s) => s.toJSON()),
		totalRegistrations: totalRegistrations.length,
		svg: getPath(totalRegistrations)
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
		const user = await locals.em.findOne(User, { id: userId });

		if (!user) {
			error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			error(400, 'Cannot demote super admin');
		}

		user.role = Role.USER;
		user.sessionToken = undefined;
		await locals.em.persistAndFlush(user);
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
		const user = await locals.em.findOne(User, { id: userId });
		if (!user) {
			error(400, 'User not found');
		}

		if (user.role === Role.SUPER_ADMIN) {
			error(400, 'Cannot promote super admin');
		}

		user.role = Role.ADMIN;
		user.sessionToken = undefined;
		await locals.em.persistAndFlush(user);
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
		const user = await locals.em.findOneOrFail(User, { id: userId });
		const form = await request.formData();
		const notes = form.get('notes') as string | undefined;

		user.notes = notes;
		await locals.em.persistAndFlush(user);
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
		const user = await locals.em.findOne(User, { id: userId });
		if (!user) {
			error(400, 'User not found');
		}

		user.strikes = Math.max(0, user.strikes - 1);

		await locals.em.persistAndFlush(user);
	},
	delete: async ({ locals, params }) => {
		if (!locals.user || locals.user.role !== Role.SUPER_ADMIN) {
			redirect(303, "/login");
		}

		const userId = params.id as string | undefined;
		if (!userId) {
			error(400, "No userId provided");
		}

		const user = await locals.em.findOneOrFail(User, { id: parseInt(userId) });
		if (user.role !== Role.USER) {
			error(400, "Cannot delete user");
		}

		const courses = await locals.em.find(Course, { users: user });
		for (const course of courses) {
			course.users.remove(user);
		}

		await locals.em.transactional(async em => {
			await em.persistAndFlush(courses);
			await em.removeAndFlush(user);
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
		const user = await locals.em.findOne(User, { id: userId });
		if (!user) {
			error(400, 'User not found');
		}

		const token = encodeURIComponent(crypto.getRandomValues(new Uint8Array(32)).join(""))

		locals.em.assign(user, {
			resetToken: token,
			resetTokenExpires: new Date(Date.now() + 1000 * 60 * 60 * 24)
		});

		await locals.em.persistAndFlush(user);

		await sendEmail(ResetPassword, { user, subject: "Reset Password", props: { user, token } });
	}
} satisfies Actions;
