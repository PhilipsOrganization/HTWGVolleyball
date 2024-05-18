import { accounts, courseSpots, courses, type Account, type Course, type DB } from "$lib/db/schema";
import { error } from "@sveltejs/kit";
import { sanitizeUser, type SanitizedAccount } from "./account";
import { Role } from "$lib/db/role";
import { eq, sql } from "drizzle-orm";

export function serializeCourse(data: { courses: Course | null, accountsJson: Account[] | [null] }, user?: Account) {
    if (!data.courses) {
        error(404, 'Course not found');
    }

    const course = data.courses;
    const accounts = data.accountsJson.filter((a) => a !== null) as Account[];
    const signupCount = accounts.length;

    const serialized = {
        ...course,
        signupCount,
        participants: [] as SanitizedAccount[],
        isEnrolled: false,
        isOnWaitlist: false,
        spot: 0,
        isPast: isCourseInThePast(course),
    };

    if (!user) {
        return serialized;
    }

    // Only show participants if the user is an admin
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

export async function getCourseWithUsers(db: DB, id: number) {
    const [updated] = await db.select({
        courses,
        accountsJson: sql<Account[] | [null]>`json_agg(accounts order by course_spots.created_at asc)`.as('accountsJson'),
        shouldPublish: sql<boolean>`(publish_on <= NOW() AND date >= (NOW() - INTERVAL '1 day'))`.as('shouldPublish'),
    })
        .from(courseSpots)
        .fullJoin(courses, eq(courseSpots.courseId, courses.id))
        .fullJoin(accounts, eq(courseSpots.userId, accounts.id))
        .groupBy(courses.id)
        .where(eq(courses.id, id))
        .limit(1);

    return updated;
}

export function isCourseInThePast(course: Course) {
    const clone = new Date(course.date);
    const [hours, minutes] = course.time.split(':').map((n) => parseInt(n));
    clone.setHours(hours, minutes, 0, 0);

    return clone < new Date();
}