import { error, redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "../$types";
import { Course, User } from "$lib/db/entities";
import { Role } from "$lib/db/role";
import { sendNotification } from "$lib/helpers/notification";

export const load: PageServerLoad = async ({ locals, params }) => {
    if (!locals.user) {
        throw redirect(303, '/login');
    }

    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    const id = parseInt(params.id);
    const course = await locals.em.findOneOrFail(Course, { id });

    if (course.publishOn < new Date() && locals.user.role === Role.USER) {
        throw error(400, 'Course not jet published');
    }

    return {
        course: course.toJSON(locals.user),
        user: locals.user.toJSON()
    };
};


function notifyNextUser(course: Course) {
    const spots = course.maxParticipants;
    const users = course.users.getItems();
    if (users.length <= spots) {
        return;
    }

    const userOnWaitlist = users.at(spots - 1);
    if (!userOnWaitlist) {
        return;
    }

    return sendNotification(userOnWaitlist, `A spot in ${course.name} Course has opened up for you!`);
}

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
        return {
            course: course.toJSON(locals.user),
        };
    },
    drop: async ({ locals, params }) => {
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

        notifyNextUser(course);
        return {
            course: course.toJSON(locals.user),
        };
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

        await locals.em.transactional(async em => {
            course.users.removeAll();
            await em.persistAndFlush(course);
            await em.removeAndFlush(course);
        })

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

        notifyNextUser(course);
        return {
            course: course.toJSON(locals.user),
        };
    }
};
