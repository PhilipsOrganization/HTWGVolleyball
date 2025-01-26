import type { Account, CourseTemplate, Group } from '$lib/db/schema';
import { add, set } from 'date-fns';

export function hydrateCourseTemplate(template: CourseTemplate, group: Group | null, trainer: Account | null): CourseTemplate {
	const publishDate = findNextWeekdayAfter(new Date(), template.publishDay);
	template.publishOn = set(publishDate, { hours: template.publishHour, minutes: 0, seconds: 0, milliseconds: 0 });

	template.date = findNextWeekdayAfter(publishDate, template.day);

	if (group) {
		template.group = group;
	}

	if (trainer) {
		template.trainerName = trainer.username;
	}

	return template;
}

export function findNextWeekdayAfter(base: Date, day: number): Date {
	const currentDay = base.getDay();

	// If the current day is the same as the target day, we want to find the next week's target day
	const daysUntil = (day - currentDay + 7) % 7;
	return add(base, { days: daysUntil });
}
