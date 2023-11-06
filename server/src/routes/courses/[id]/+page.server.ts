import { error, redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "../$types";
import { Course, User } from "$lib/db/entities";
import { Role } from "$lib/db/role";
import { DropCourseAction, OpenCourseAction, OpenProfileAction, sendNotification } from "$lib/helpers/notification";
import { sendEmail } from "$lib/email";
import OpenSpot from "$lib/email/templates/open-spot.svelte";

export const load: PageServerLoad = async ({ locals, params }) => {
    if (!locals.user) {
        throw redirect(303, '/login');
    }

    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    const id = parseInt(params.id);
    const course = await locals.em.findOneOrFail(Course, { id });

    if (!course.shouldPublish && locals.user.role === Role.USER) {
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

    if (userOnWaitlist.hasNotificationsEnabled) {
        return sendNotification(userOnWaitlist, `A spot in ${course.name} Course has opened up for you!`, [new OpenCourseAction(course.id), new DropCourseAction(course.id)]);
    } else {
        return sendEmail(OpenSpot, {
            user: userOnWaitlist,
            subject: `A spot in ${course.name} Course has opened up for you!`,
            props: { course, user: userOnWaitlist }
        });
    }
}

export const actions = {
    enlist: async ({ locals, params }) => {
        if (!locals.user) {
            throw redirect(303, '/login');
        }

        if (!locals.user.emailVerified) {
            throw error(400, 'Your Email is not verified. Check your inbox for the verification email or request a new one in your profile.');
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
    },
    strike: async ({ locals, request, params }) => {
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

        user.strikes += 1;
        await locals.em.persistAndFlush(user);

        sendNotification(user, `You have been striked for Course "${course.name}" by ${locals.user.username}`, [new OpenCourseAction(course.id), new OpenProfileAction()]);

        return {
            course: course.toJSON(locals.user),
        };
    },
};
