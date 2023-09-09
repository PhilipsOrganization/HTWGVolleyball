import { Course } from "$lib/db/entities/course";
import { error } from "@sveltejs/kit";
import type { PageServerLoad, Actions } from "./$types";

export const load: PageServerLoad = async ({ locals }) => {
    const courses = await locals.em.find(Course, {});
    return {
        posts: courses.map((c) => c.toJSON()),
    };
};

export const actions = {
    default: async ({ locals, request }) => {
        const form = await request.formData()
        const title = form.get('title');
        if (!title) {
            throw error(400, 'No title provided');
        }

        const course = new Course();
        course.title = title as string;

        await locals.em.persistAndFlush(course);
    },
} satisfies Actions;
