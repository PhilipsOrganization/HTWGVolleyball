import { redirect, type Actions, error } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";
import { Course } from "$lib/db/entities/course";
import { Role } from "$lib/db/role";
import { assign } from "@mikro-orm/core";
import { User } from "$lib/db/entities/user";

export const load: PageServerLoad = async ({ locals }) => {
    if (locals.user?.role !== Role.ADMIN) {
        throw redirect(307, '/login');
    }

    const courses = await locals.em.find(Course, {});
    const users = await locals.em.find(User, {});

    return {
        courses: courses.map((c) => c.toJSON()),
        users: users.map((u) => u.toJSON()),
    };
};

export const actions = {
    "create-course": async ({ locals, request }) => {
        if (locals.user?.role !== Role.ADMIN) {
            throw redirect(307, '/login');
        }

        const form = await request.formData()
        const title = form.get('title');
        if (!title) {
            throw error(400, 'No title provided');
        }

        const course = new Course();
        course.title = title as string;

        await locals.em.persistAndFlush(course);
    },
    "delete-course": async ({ locals, request }) => {
        if (locals.user?.role !== Role.ADMIN) {
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

        locals.em.remove(course);
        await locals.em.flush();
    },
    "update-course": async ({ locals, request }) => {
        if (locals.user?.role !== Role.ADMIN) {
            throw redirect(307, '/login');
        }

        const form = await request.formData()
        const courseIdString = form.get('courseId') as string | undefined;
        const title = form.get('title') as string | undefined;
        if (!courseIdString || !title) {
            throw error(400, 'No courseId or title provided');
        }

        const courseId = parseInt(courseIdString);
        const course = await locals.em.findOne(Course, { id: courseId });
        if (!course) {
            throw error(400, 'Course not found');
        }

        assign(course, { title });
        await locals.em.persistAndFlush(course);
    },
} satisfies Actions;