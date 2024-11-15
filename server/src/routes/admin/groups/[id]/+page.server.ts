import { Role } from '$lib/db/role';
import { accounts, groupMembers, groups } from '$lib/db/schema';
import { redirect } from '@sveltejs/kit';
import { eq } from 'drizzle-orm';
import type { PageServerLoad } from './$types';
import { serializeUser } from '$lib/helpers/account';

export const load: PageServerLoad = async ({ locals, params }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/login');
	}

	const { db } = locals;
	const { id } = params;
	const groupId = parseInt(id);
	if (id === undefined || isNaN(groupId)) {
		return redirect(303, '/admin/groups');
	}

	const [g] = await db.select().from(groups).where(eq(groups.id, groupId)).limit(1);

	if (!g) {
		return redirect(303, '/admin/groups');
	}

	const members = await db
		.select({
			name: accounts.username,
			id: accounts.id
		})
		.from(accounts)
		.innerJoin(groupMembers, eq(accounts.id, groupMembers.userId))
		.where(eq(groupMembers.groupId, groupId));

	return {
		members, group: g,
		globalUser: serializeUser(locals.user),
	};
};
