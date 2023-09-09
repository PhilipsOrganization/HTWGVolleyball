import { error, redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import { Course } from "$lib/db/entities/course";

export const load: PageServerLoad = async ({ locals }) => {
    if (!locals.user) {
        throw redirect(307, '/login');
    }

    const courses = locals.user.courses.getItems();

    const allCourses = await locals.em.find(Course, {});

    return {
        courses: courses.map((c) => c.toJSON()),
        allCourses: allCourses.map((c) => c.toJSON()),
    };
};

export const actions = {
    enlist: async ({ locals, request }) => {
        if (!locals.user) {
            throw redirect(307, '/login');
        }

        const form = await request.formData()
        const courseIdString = form.get('courseId') as string | undefined;
        if (!courseIdString) {
            throw error(400, 'No courseId provided');
        }

        const courseId = parseInt(courseIdString);
        const course = await locals.em.findOne(Course, { id: courseId });
        if (!course) {
            throw error(400, 'Course not found');
        }

        if (locals.user.courses.contains(course)) {
            throw error(400, 'Already enrolled');
        }

        locals.user.courses.add(course);
        await locals.em.persistAndFlush(locals.user);
    },
    drop: async ({ locals, request }) => {
        if (!locals.user) {
            throw redirect(307, '/login');
        }

        const form = await request.formData()
        const courseIdString = form.get('courseId') as string | undefined;
        if (!courseIdString) {
            throw error(400, 'No courseId provided');
        }

        const courseId = parseInt(courseIdString);
        const course = await locals.em.findOne(Course, { id: courseId });
        if (!course) {
            throw error(400, 'Course not found');
        }

        if (!locals.user.courses.contains(course)) {
            throw error(400, 'Not enrolled');
        }

        locals.user.courses.remove(course);
        await locals.em.persistAndFlush(locals.user);
    },
}