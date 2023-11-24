import { dev } from "$app/environment";
import { Course, orderCourse } from "$lib/db/entities";
import { sendEmail } from "$lib/email";
import CourseNotification from "$lib/email/templates/course-notification.svelte";
import { OpenCourseAction, sendNotification } from "$lib/helpers/notification";
import type { RequestHandler } from "@sveltejs/kit";
import { differenceInHours, isToday } from "date-fns";
import * as Sentry from '@sentry/sveltekit';


export const GET: RequestHandler = async ({ locals }) => {
    const checkInId = Sentry.captureCheckIn({
        monitorSlug: "notification-cron",
        status: "in_progress",
    });

    try {
        const em = locals.em;
        const courses = await em.find(Course, { shouldPublish: true, notificationSent: false });

        console.log(`Found ${courses.length} courses to send notifications for`);

        for (const course of courses) {
            const [hours, minutes] = course.time.split(":").map(Number);
            const date = new Date(course.date);
            date.setHours(hours, minutes, 0, 0);
            const hoursToCourse = differenceInHours(date, new Date())
            if (!isToday(course.date) || hoursToCourse > 6) {
                continue;
            }

            if (!dev && course.notificationSent) {
                continue;
            }
            await orderCourse(course, locals.em);

            console.log(`Sending notifications for course ${course.id}`);
            for (const user of course.users.getItems()) {
                if (user.hasNotificationsEnabled) {
                    try {
                        await sendNotification(user, `You have a course today: ${course.name}`, [new OpenCourseAction(course.id)]);
                    } catch (e) {
                        user.subscription = undefined;
                        await em.persistAndFlush(user);
                    }
                }

                if (!user.hasNotificationsEnabled || dev) {
                    await sendEmail(CourseNotification, {
                        user,
                        subject: `You have a course today: ${course.name}`,
                        props: { course, user }
                    });
                }
            }

            course.notificationSent = true;
            await em.persistAndFlush(course);
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
