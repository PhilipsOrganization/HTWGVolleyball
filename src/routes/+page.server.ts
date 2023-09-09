import { Course } from "$lib/db/entities/course";
import type { PageServerLoad } from "./$types";


export const load: PageServerLoad = async ({ locals }) => {
    const courses = await locals.em.find(Course, {});

    return {
        posts: courses.map((c) => c.toJSON()),
    };
};