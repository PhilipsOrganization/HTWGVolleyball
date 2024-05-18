import { dev } from "$app/environment";
import { accounts, courseSpots, courses } from "$lib/db/schema.js";
import { sendEmail } from "$lib/email/index.js";
import CourseNotification from "$lib/email/templates/course-notification.svelte";
import { OpenCourseAction, sendNotification } from "$lib/helpers/notification.js";
import * as Sentry from '@sentry/sveltekit';
import type { RequestHandler } from "@sveltejs/kit";
import { differenceInHours, isToday } from "date-fns";
import { and, eq, sql } from "drizzle-orm";

export const GET: RequestHandler = async ({ locals }) => {
    const checkInId = Sentry.captureCheckIn({
        monitorSlug: "notification-cron",
        status: "in_progress",
    });

    try {
        const db = locals.db;
        // { shouldPublish: true, notificationSent: false }
        const result = await db.select().from(courses).where(
            and(
                eq(sql<boolean>`publish_on <= NOW() AND date >= (NOW() - INTERVAL '1 day')`, true),
                eq(courses.notificationSent, false)
            )
        );

        console.log(`Found ${result.length} courses to send notifications for`);

        for (const course of result) {
            const [hours, minutes] = course.time.split(":").map(Number);
            const date = new Date(course.date);
            date.setHours(hours, minutes, 0, 0);
            const hoursToCourse = differenceInHours(date, new Date())
            if (!isToday(date) || hoursToCourse > 6) {
                continue;
            }

            if (!dev && course.notificationSent) {
                continue;
            }

            await db.update(courses).set({ notificationSent: true }).where(eq(courses.id, course.id));

            console.log(`Sending notifications for course ${course.id}`);
            const usersInCourse = await db.select().from(courseSpots)
                .leftJoin(accounts, eq(courseSpots.userId, accounts.id))
                .where(eq(courseSpots.courseId, course.id));

            for (const user of usersInCourse) {
                if (user.accounts?.subscriptionAuth) {
                    try {
                        await sendNotification(user.accounts, `You have a course today: ${course.name}`, [new OpenCourseAction(course.id)]);
                    } catch (e) {
                        await db.update(accounts).set({ subscriptionAuth: null, subscriptionEndpoint: null, subscriptionExpirationTime: null, subscriptionP256Dh: null }).where(eq(accounts.id, user.accounts.id));
                    }
                }

                if (user.accounts && (!user.accounts.subscriptionAuth || dev)) {
                    await sendEmail(CourseNotification, {
                        user: user.accounts,
                        subject: `You have a course today: ${course.name}`,
                        props: { course, user }
                    });
                }
            }

        }

        Sentry.captureCheckIn({
            checkInId,
            monitorSlug: 'notification-cron',
            status: 'ok',
        });
    } catch (e) {
        Sentry.captureCheckIn({
            checkInId,
            monitorSlug: "notification-cron",
            status: "error",
        });
    }

    return new Response(JSON.stringify({ message: "ok" }));
}
