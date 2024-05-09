import { relations } from "drizzle-orm/relations";
import { courses, courseSpots, accounts } from "./schema";

export const courseSpotsRelations = relations(courseSpots, ({one}) => ({
	course: one(courses, {
		fields: [courseSpots.courseId],
		references: [courses.id]
	}),
	account: one(accounts, {
		fields: [courseSpots.userId],
		references: [accounts.id]
	}),
}));

export const coursesRelations = relations(courses, ({many}) => ({
	courseSpots: many(courseSpots),
}));

export const accountsRelations = relations(accounts, ({many}) => ({
	courseSpots: many(courseSpots),
}));