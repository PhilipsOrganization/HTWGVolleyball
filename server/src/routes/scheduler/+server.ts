import { Course } from "$lib/db/entities";
import { sendNotification } from "$lib/helpers/notification";
import type { RequestHandler } from "@sveltejs/kit";
import { isToday } from "date-fns";

export const POST: RequestHandler = async ({ locals }) => {
    const em = locals.em;
    const courses = await em.find(Course, { shouldPublish: true, notificationSent: false });
    for (const course of courses) {
        if (!isToday(course.date)) {
            continue;
        }

        console.log(`Sending notifications for course ${course.id}`);
        for (const user of course.users.getItems()) {
            // TODO: add course link to notification
            await sendNotification(user, `You have a course today: ${course.name}`);
        }

        course.notificationSent = true;
        await em.persistAndFlush(course);
    }

    return new Response(JSON.stringify({ message: "ok" }));
}
