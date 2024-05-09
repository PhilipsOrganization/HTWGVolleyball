import { Course, CourseSpot, User } from "$lib/db/entities";
import { Role } from "$lib/db/role";
import { accounts, courseSpots, courses, sanitizeUser, type Account, type SanitizedAccount } from "$lib/db/schema.js";
import { sendEmail } from "$lib/email";
import OpenSpot from "$lib/email/templates/open-spot.svelte";
import { DropCourseAction, OpenCourseAction, OpenProfileAction, sendNotification } from "$lib/helpers/notification";
import { error, redirect } from "@sveltejs/kit";
import { eq, sql } from "drizzle-orm";
import type { PageServerLoad } from "./$types.js";

export const load: PageServerLoad = async ({ locals, params }) => {
    if (!locals.user) {
        redirect(303, '/login');
    }

    const id = parseInt(params.id);
    const [course] = await locals.db.select({
        courses,
        accountsJson: sql<Account[]>`json_agg(accounts order by course_spots.created_at asc)`.as('accountsJson'),
        shouldPublish: sql<boolean>`(publish_on <= NOW() AND date >= (NOW() - INTERVAL '1 day'))`.as('shouldPublish'),
    })
        .from(courseSpots)
        .leftJoin(courses, eq(courseSpots.courseId, courses.id))
        .leftJoin(accounts, eq(courseSpots.userId, accounts.id))
        .groupBy(courses.id)
        .where(eq(courses.id, id))
        .limit(1);

    if (!course.shouldPublish && locals.user.role === Role.USER) {
        error(400, 'Course not jet published');
    }

    return {
        course: serialize(course, locals.user),
        user: locals.user.toJSON()
    };
};

function serialize(data: { courses: Course | null, accountsJson: Account[] }, user?: Account) {
    if (!data.courses) {
        error(404, 'Course not found');
    }

    const course = data.courses;
    const accounts = data.accountsJson;

    const signupCount = accounts.length;

    const serialized = {
        ...course,
        date: new Date(course.date),
        publishOn: new Date(course.publishOn),
        signupCount,
        participants: [] as SanitizedAccount[],
    };

    if (!user) {
        return serialized;
    }

    if (user.role !== Role.USER) {
        serialized.participants = accounts.map(sanitizeUser);
    }

    const isEnrolled = accounts.some((a) => a.id === user.id);
    const spot = accounts.findIndex((a) => a.id === user.id);
    const isOnWaitlist = spot >= course.maxParticipants;

    return {
        ...serialized,
        isEnrolled,
        spot,
        isOnWaitlist,
    };
}

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
            redirect(303, '/login');
        }

        if (!locals.user.emailVerified) {
            error(400, 'Your Email is not verified. Check your inbox for the verification email or request a new one in your profile.');
        }

        const courseIdString = params.id as string | undefined;
        if (!courseIdString) {
            error(400, 'No courseId provided');
        }

        const courseId = parseInt(courseIdString);
        let course = await locals.em.findOne(Course, { id: courseId });
        if (!course) {
            error(400, 'Course not found');
        }

        if (locals.user.courses.contains(course)) {
            error(400, 'Already enrolled');
        }

        const spot = locals.em.create(CourseSpot, {
            course,
            user: locals.user,
            createdAt: new Date(),
        });

        await locals.em.persistAndFlush(spot);
        course = await locals.em.findOneOrFail(Course, { id: courseId }, { refresh: true });

        return {
            course: course.toJSON(locals.user),
        };
    },
    drop: async ({ locals, params }) => {
        if (!locals.user) {
            redirect(303, '/login');
        }

        const courseIdString = params.id as string | undefined;
        if (!courseIdString) {
            error(400, 'No courseId provided');
        }

        const courseId = parseInt(courseIdString);
        const course = await locals.em.findOne(Course, { id: courseId });
        if (!course) {
            error(400, 'Course not found');
        }

        if (!locals.user.courses.contains(course)) {
            error(400, 'Not enrolled');
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
            redirect(303, '/login');
        }

        const courseIdString = params.id as string | undefined;
        if (!courseIdString) {
            error(400, 'No courseId provided');
        }

        const courseId = parseInt(courseIdString);

        const course = await locals.em.findOne(Course, { id: courseId });

        if (!course) {
            error(400, 'Course not found');
        }

        await locals.em.transactional(async em => {
            course.users.removeAll();
            await em.persistAndFlush(course);
            await em.removeAndFlush(course);
        })

        redirect(303, `/admin`);
    },
    cancel: async ({ locals, request, params }) => {
        if (!locals.user || locals.user.role === Role.USER) {
            redirect(303, '/login');
        }

        const form = await request.formData();
        const courseId = parseInt(params.id as string);
        const course = await locals.em.findOneOrFail(Course, { id: courseId });

        const userIdString = form.get('userId') as string | undefined;
        if (!userIdString) {
            error(400, 'No userId provided');
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
            redirect(303, '/login');
        }

        const form = await request.formData();
        const courseId = parseInt(params.id as string);
        const course = await locals.em.findOneOrFail(Course, { id: courseId });

        const userIdString = form.get('userId') as string | undefined;
        if (!userIdString) {
            error(400, 'No userId provided');
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
