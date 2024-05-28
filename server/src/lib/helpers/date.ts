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
		}
		return `${modifier} ${weekday}`;
	}

	if (weeks === -1) {
		return weekday + ' last week';
	}
	if (weeks === 1) {
		return weekday + ' next week';
	}

	return comp.toLocaleDateString('en-US', {
		dateStyle: 'full',
	});
}

export function isOnDate(d1: Date | string, d2: Date | string): boolean {
	return isSameDay(new Date(d1), new Date(d2));
}

export function sort(d1: any, d2: any) {
	return compareAsc(new Date(d1.date), new Date(d2.date));
}

/**
 * format time in seconds to human readable format
 * @param time in seconds
 * @returns 
 */
export function approximatelyFormatTime(time: number) {
	const days = Math.floor(time / 60 / 60 / 24);
	const hours = Math.floor(time / 60 / 60) - days * 24;
	const minutes = Math.floor(time / 60) - hours * 60 - days * 24 * 60;
	const seconds = Math.floor(time) - minutes * 60 - hours * 60 * 60 - days * 24 * 60 * 60;

	let result = '';
	if (days > 0) {
		result += `${days} days `;
	}

	if (hours > 0) {
		result += `${hours} hours `;
	}

	if (minutes > 0) {
		result += `${minutes} minutes `;
	}

	result += `${seconds} seconds`;

	return result;
}