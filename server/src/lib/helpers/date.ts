import {
	compareAsc,
	differenceInCalendarDays,
	differenceInCalendarISOWeeks,
	isAfter,
	isSameDay
} from 'date-fns';

export function humanReadableDate(date: Date | string) {
	if (!date) {
		return 'no date';
	}
	const comp = new Date(date);
	const today = new Date();
	if (isSameDay(comp, today)) {
		return 'today';
	}
	const days = differenceInCalendarDays(comp, today);

	if (days === 1) {
		return 'tomorrow';
	}
	if (days === -1) {
		return 'yesterday';
	}
	const weekday = Intl.DateTimeFormat('en-US', { weekday: 'long' }).format(comp);

	if (Math.abs(days) < 4) {
		const past = isAfter(today, comp);
		return `${weekday}, ${past ? '' : 'in'} ${Math.abs(days)} days ${past ? 'ago' : ''}`;
	}

	const weeks = differenceInCalendarISOWeeks(comp, today);

	if (weeks === 0) {
		let modifier = '';
		if (isAfter(today, comp)) {
			modifier = 'last';
		} else {
			modifier = 'on';
		}
		return `${modifier} ${weekday}`;
	}

	if (weeks === -1) {
		return 'last week on ' + weekday;
	}
	if (weeks === 1) {
		return 'next week on ' + weekday;
	}
	if (Math.abs(weeks) < 4) {
		const day = comp.toLocaleDateString('en-US', {
			month: 'short',
			day: 'numeric'
		});
		return `on ${day}`;
	}

	return comp.toLocaleDateString('en-US', {
		year: 'numeric',
		month: 'long',
		day: 'numeric'
	});
}

export function isOnDate(d1: Date | string, d2: Date | string): boolean {
	return isSameDay(new Date(d1), new Date(d2));
}

export function sort(d1: any, d2: any) {
	return compareAsc(new Date(d1.date), new Date(d2.date));
}
