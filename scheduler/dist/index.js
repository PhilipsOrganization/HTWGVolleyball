"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const postgresql_1 = require("@mikro-orm/postgresql");
const database_1 = require("@lib/database");
const notifications_1 = require("@lib/notifications");
const cron_1 = require("cron");
const date_fns_1 = require("date-fns");
async function main() {
    const orm = await postgresql_1.MikroORM.init(database_1.config);
    const em = orm.em.fork();
    const courses = await em.find(database_1.Course, { shouldPublish: true, notificationSent: false });
    scheduleNotifications(courses, async (course) => {
        console.log(`Sending notifications for course ${course.id}`);
        for (const user of course.users.getItems()) {
            // TODO: add course link to notification
            await (0, notifications_1.sendNotification)(user, `You have a course today: ${course.name}`);
        }
        course.notificationSent = true;
        await em.persistAndFlush(course);
        process.exit(0);
    });
}
function scheduleNotifications(courses, callback) {
    courses.forEach((course) => {
        if (!(0, date_fns_1.isToday)(course.date)) {
            return;
        }
        // cron job runs at 2pm every day
        const cron = `0 14 * * *`;
        const job = new cron_1.CronJob(cron, () => callback(course));
        job.start();
    });
}
main();
