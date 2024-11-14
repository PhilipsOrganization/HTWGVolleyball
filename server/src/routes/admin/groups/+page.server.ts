import { Role } from '$lib/db/role';
import { groupMembers, groups } from '$lib/db/schema';
import { redirect } from '@sveltejs/kit';
import { eq } from 'drizzle-orm';
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/login');
	}

	const { db } = locals;
	const g = await db
		.select({
			id: groups.id,
			name: groups.name
		})
		.from(groups)
		.leftJoin(groupMembers, eq(groups.id, groupMembers.groupId))
		.groupBy(groups.id)
		.orderBy(groups.name);

	return {
		groups: g
	};
};

export const actions: Actions = {
	create: async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			return redirect(303, '/courses');
		}

		const { db } = locals;
		const form = await request.formData();

		const name = form.get('name') as string;

		const [g] = await db.insert(groups).values({ name }).returning();

		return redirect(302, '/admin/groups/' + g.id);
	}
};
