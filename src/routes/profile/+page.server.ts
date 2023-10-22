import { redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "../$types";
import { UserStats } from "$lib/db/entities/user-stats";
import { getPath } from "$lib/helpers/stats";
import { Course } from "$lib/db/entities/course";

export const load: PageServerLoad = async ({ locals }) => {
    if (!locals.user) {
        throw redirect(303, '/login');
    }

    const stats = await locals.em.find(UserStats, { userId: locals.user.id });
    const totalRegistrations = await locals.em.find(Course, { users: locals.user }, { populate: [], fields: ["date"], orderBy: { date: 'ASC' } });
    
    return {
        user: locals.user.toJSON(),
        stats: stats.map((s) => s.toJSON()),
        totalRegistrations: totalRegistrations.length,
        svg: getPath(totalRegistrations),
    };
}