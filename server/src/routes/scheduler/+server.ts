import { Course } from "$lib/db/entities";
import type { RequestHandler } from "@sveltejs/kit";



export const POST: RequestHandler = async ({ locals }) => {
    const em = locals.em;
    const courses = await em.find(Course, { shouldPublish: true, notificationSent: false });
    scheduleNotifications(courses, async (course) => {
        console.log(`Sending notifications for course ${course.id}`);
        for (const user of course.users.getItems()) {
            // TODO: add course link to notification
            await sendNotification(user, `You have a course today: ${course.name}`);
        }

        course.notificationSent = true;
        await em.persistAndFlush(course);

        process.exit(0);
    });

    return new Response(JSON.stringify({ message: "ok" }));
}

function scheduleNotifications(courses: Course[], callback: (course: Course) => void) {
    courses.forEach((course) => {
        if (!isToday(course.date)) {
            return;
        }

        // cron job runs at 2pm every day
        const cron = `0 14 * * *`;
        const job = new CronJob(cron, () => callback(course));
        job.start();
    });
}