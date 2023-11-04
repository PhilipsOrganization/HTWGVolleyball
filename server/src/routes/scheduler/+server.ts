import { Course } from "$lib/db/entities";
import { OpenCourseAction, sendNotification } from "$lib/helpers/notification";
import type { RequestHandler } from "@sveltejs/kit";
import { differenceInHours, isToday } from "date-fns";

export const GET: RequestHandler = async ({ locals }) => {
    const em = locals.em;
    const courses = await em.find(Course, { shouldPublish: true, notificationSent: false });
    for (const course of courses) {
        const hoursToCourse = differenceInHours(course.date, new Date())
        if (!isToday(course.date) || course.notificationSent || hoursToCourse > 6) {
            continue;
        }

        console.log(`Sending notifications for course ${course.id}`);
        for (const user of course.users.getItems()) {
            // TODO: add course link to notification
            await sendNotification(user, `You have a course today: ${course.name}`, [new OpenCourseAction(course.id)]);
        }

        course.notificationSent = true;
        await em.persistAndFlush(course);
    }

    return new Response(JSON.stringify({ message: "ok" }));
}
