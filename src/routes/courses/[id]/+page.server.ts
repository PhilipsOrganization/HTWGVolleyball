import { error, redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "../$types";
import { Course, User } from "$lib/db/entities";
import { Role } from "$lib/db/role";

export const load: PageServerLoad = async ({ locals, params }) => {
    if (!locals.user) {
        throw redirect(303, '/login');
    }

    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    const id = parseInt(params.id);
    const course = await locals.em.findOneOrFail(Course, { id });

    if (course.publishOn < new Date()) {
        throw error(400, 'Course not jet published');
    }

    return {
        course: course.toJSON(locals.user),
        user: locals.user.toJSON()
    };
};


export const actions = {
    enlist: async ({ locals, params }) => {
        if (!locals.user) {
            throw redirect(303, '/login');
        }

        const courseIdString = params.id as string | undefined;
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
        course.users.add(locals.user);

        await locals.em.persistAndFlush([locals.user, course]);
    },
    drop: async ({ locals, params, url }) => {
        if (!locals.user) {
            throw redirect(303, '/login');
        }

        const courseIdString = params.id as string | undefined;
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
        course.users.remove(locals.user);
        await locals.em.persistAndFlush([locals.user, course]);
    },
    'delete-course': async ({ locals, params }) => {
        if (!locals.user || locals.user.role === Role.USER) {
            throw redirect(303, '/login');
        }

        const courseIdString = params.id as string | undefined;
        if (!courseIdString) {
            throw error(400, 'No courseId provided');
        }

        const courseId = parseInt(courseIdString);

        const course = await locals.em.findOne(Course, { id: courseId });

        if (!course) {
            throw error(400, 'Course not found');
        }

        await locals.em.removeAndFlush(course);

        throw redirect(303, `/admin`);
    },
    cancel: async ({ locals, request, params }) => {
        if (!locals.user || locals.user.role === Role.USER) {
            throw redirect(303, '/login');
        }

        const form = await request.formData();
        const courseId = parseInt(params.id as string);
        const course = await locals.em.findOneOrFail(Course, { id: courseId });

        const userIdString = form.get('userId') as string | undefined;
        if (!userIdString) {
            throw error(400, 'No userId provided');
        }

        const userId = parseInt(userIdString);
        const user = await locals.em.findOneOrFail(User, { id: userId });
        course.users.remove(user);

        await locals.em.persistAndFlush(course);
    }
};
