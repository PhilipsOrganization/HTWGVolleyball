import { Role } from '$lib/db/role';
import { accounts } from '$lib/db/schema';
import { sanitizeUser, serializeUser } from '$lib/helpers/account';
import { redirect } from '@sveltejs/kit';
import { count, ilike, eq, or, and, type SQL } from 'drizzle-orm';
import type { PageServerLoad } from './$types';

const PAGE_SIZE = 50;

export const load: PageServerLoad = async ({ locals, url }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	const page = Math.max(1, parseInt(url.searchParams.get('page') ?? '1', 10));
	const search = url.searchParams.get('search') ?? '';
	const roleFilter = url.searchParams.get('role') ?? '';
	const offset = (page - 1) * PAGE_SIZE;

	const conditions: SQL[] = [];
	if (search) {
		conditions.push(ilike(accounts.username, `%${search}%`));
	}
	if (roleFilter && Object.values(Role).includes(roleFilter as Role)) {
		conditions.push(eq(accounts.role, roleFilter as Role));
	}

	const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

	const [users, totalResult, allUsersCount] = await Promise.all([
		locals.db.select().from(accounts).where(whereClause).orderBy(accounts.role, accounts.username).limit(PAGE_SIZE).offset(offset),
		locals.db.select({ count: count() }).from(accounts).where(whereClause),
		locals.db.select({ count: count() }).from(accounts)
	]);

	const total = totalResult[0]?.count ?? 0;
	const totalPages = Math.ceil(total / PAGE_SIZE);

	return {
		users: users.map((u) => sanitizeUser(u)),
		globalUser: serializeUser(locals.user),
		pagination: {
			page,
			pageSize: PAGE_SIZE,
			total,
			totalPages
		},
		filters: {
			search,
			role: roleFilter
		},
		totalUsers: allUsersCount[0]?.count ?? 0
	};
};
