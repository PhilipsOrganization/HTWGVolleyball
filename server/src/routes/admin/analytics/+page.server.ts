import { Role } from '$lib/db/role';
import { accounts, courseSpots, courses } from '$lib/db/schema';
import { redirect } from '@sveltejs/kit';
import { eq, isNull, and, gte, desc } from 'drizzle-orm';
import { startOfWeek, differenceInWeeks, subMonths, addWeeks } from 'date-fns';
import type { PageServerLoad } from './$types';

interface UserConsistency {
	userId: number;
	username: string;
	score: number;
	totalBookings: number;
	consecutiveWeeks: number;
	missedWeeks: number;
}

interface CourseBooking {
	userId: number;
	username: string;
	courseName: string;
	courseDate: Date;
}

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	// Get all bookings from the last 12 months
	const twelveMonthsAgo = subMonths(new Date(), 36);

	const bookings = await locals.db
		.select({
			userId: accounts.id,
			username: accounts.username,
			courseName: courses.name,
			courseDate: courses.date
		})
		.from(courseSpots)
		.innerJoin(accounts, eq(courseSpots.userId, accounts.id))
		.innerJoin(courses, eq(courseSpots.courseId, courses.id))
		.where(
			and(
				isNull(courseSpots.deletedAt),
				isNull(courses.deletedAt),
				gte(courses.date, twelveMonthsAgo)
			)
		)
		.orderBy(accounts.id, courses.name, desc(courses.date));

	// Calculate consistency scores per user
	const userScores = calculateConsistencyScores(bookings as CourseBooking[]);

	// Get score distribution for histogram
	const scoreDistribution = calculateScoreDistribution(userScores);

	// Get weekly activity data
	const weeklyActivity = calculateWeeklyActivity(bookings as CourseBooking[]);

	// Get score over time for each user (for spaghetti chart)
	const userScoresOverTime = calculateScoresOverTime(bookings as CourseBooking[]);

	// Get top consistent users
	const topUsers = [...userScores]
		.sort((a, b) => b.score - a.score)
		.slice(0, 60);

	// Get summary stats
	const totalUsers = userScores.length;
	const avgScore = userScores.length > 0
		? Math.round(userScores.reduce((sum, u) => sum + u.score, 0) / userScores.length)
		: 0;
	const totalBookings = userScores.reduce((sum, u) => sum + u.totalBookings, 0);

	return {
		scoreDistribution,
		weeklyActivity,
		userScoresOverTime,
		topUsers,
		stats: {
			totalUsers,
			avgScore,
			totalBookings,
			positiveScoreUsers: userScores.filter(u => u.score > 0).length,
			negativeScoreUsers: userScores.filter(u => u.score === 0).length
		}
	};
};

function calculateConsistencyScores(bookings: CourseBooking[]): UserConsistency[] {
	// Group bookings by user
	const userBookings = new Map<number, { username: string; bookings: Map<string, Date[]> }>();

	for (const booking of bookings) {
		if (!userBookings.has(booking.userId)) {
			userBookings.set(booking.userId, {
				username: booking.username,
				bookings: new Map()
			});
		}

		const user = userBookings.get(booking.userId)!;
		const courseBookings = user.bookings.get(booking.courseName) ?? [];
		courseBookings.push(new Date(booking.courseDate));
		user.bookings.set(booking.courseName, courseBookings);
	}

	const results: UserConsistency[] = [];

	for (const [userId, userData] of userBookings) {
		let score = 0;
		let totalBookings = 0;
		let consecutiveWeeks = 0;
		let missedWeeks = 0;

		// For each course the user booked
		for (const [, dates] of userData.bookings) {
			totalBookings += dates.length;

			// Sort dates
			dates.sort((a, b) => a.getTime() - b.getTime());

			// Check consecutive weeks
			for (let i = 1; i < dates.length; i++) {
				const prevWeek = startOfWeek(dates[i - 1], { weekStartsOn: 1 });
				const currWeek = startOfWeek(dates[i], { weekStartsOn: 1 });
				const weekDiff = differenceInWeeks(currWeek, prevWeek);

				if (weekDiff === 1) {
					// Consecutive week - +1 point
					score++;
					consecutiveWeeks++;
				} else if (weekDiff > 1) {
					// Missed weeks - -1 point per missed week
					const missed = weekDiff - 1;
					score -= missed;
					score = Math.max(0, score); // Clamp at 0
					missedWeeks += missed;
				}
				// weekDiff === 0 means same week, no points
			}
		}

		results.push({
			userId,
			username: userData.username,
			score,
			totalBookings,
			consecutiveWeeks,
			missedWeeks
		});
	}

	return results;
}

function calculateScoreDistribution(users: UserConsistency[]): { label: string; count: number }[] {
	// Create buckets for score ranges (scores clamped at 0)
	const buckets: { min: number; max: number; label: string; count: number }[] = [
		{ min: -1, max: 0, label: '0', count: 0 },
		{ min: 0, max: 5, label: '1-5', count: 0 },
		{ min: 5, max: 10, label: '6-10', count: 0 },
		{ min: 10, max: 20, label: '11-20', count: 0 },
		{ min: 20, max: 35, label: '21-35', count: 0 },
		{ min: 35, max: 50, label: '36-50', count: 0 },
		{ min: 50, max: 75, label: '51-75', count: 0 },
		{ min: 75, max: Infinity, label: '> 75', count: 0 }
	];

	for (const user of users) {
		for (const bucket of buckets) {
			if (user.score > bucket.min && user.score <= bucket.max) {
				bucket.count++;
				break;
			}
		}
	}

	return buckets.map(b => ({ label: b.label, count: b.count }));
}

function calculateWeeklyActivity(bookings: CourseBooking[]): { week: string; bookings: number; uniqueUsers: number }[] {
	const weeklyData = new Map<string, { bookings: number; users: Set<number> }>();

	for (const booking of bookings) {
		const week = startOfWeek(new Date(booking.courseDate), { weekStartsOn: 1 });
		const weekKey = week.toISOString().substring(0, 10);

		if (!weeklyData.has(weekKey)) {
			weeklyData.set(weekKey, { bookings: 0, users: new Set() });
		}

		const data = weeklyData.get(weekKey)!;
		data.bookings++;
		data.users.add(booking.userId);
	}

	return Array.from(weeklyData)
		.sort(([a], [b]) => a.localeCompare(b))
		.map(([week, data]) => ({
			week,
			bookings: data.bookings,
			uniqueUsers: data.users.size
		}));
}

interface ScoreEvent {
	week: Date;
	delta: number;
}

function calculateScoresOverTime(bookings: CourseBooking[]): {
	weeks: string[];
	users: { id: number; username: string; scores: (number | null)[] }[];
} {
	// Group bookings by user and course
	const userCourseBookings = new Map<number, { username: string; courses: Map<string, Date[]> }>();

	for (const booking of bookings) {
		if (!userCourseBookings.has(booking.userId)) {
			userCourseBookings.set(booking.userId, {
				username: booking.username,
				courses: new Map()
			});
		}

		const user = userCourseBookings.get(booking.userId)!;
		const dates = user.courses.get(booking.courseName) ?? [];
		dates.push(new Date(booking.courseDate));
		user.courses.set(booking.courseName, dates);
	}

	// Calculate score events (when score changes) for each user
	const userScoreEvents = new Map<number, { username: string; events: ScoreEvent[] }>();

	for (const [userId, userData] of userCourseBookings) {
		const events: ScoreEvent[] = [];

		for (const [, dates] of userData.courses) {
			dates.sort((a, b) => a.getTime() - b.getTime());

			for (let i = 1; i < dates.length; i++) {
				const prevWeek = startOfWeek(dates[i - 1], { weekStartsOn: 1 });
				const currWeek = startOfWeek(dates[i], { weekStartsOn: 1 });
				const weekDiff = differenceInWeeks(currWeek, prevWeek);

				if (weekDiff === 1) {
					// Consecutive week: +1 at current week
					events.push({ week: currWeek, delta: 1 });
				} else if (weekDiff > 1) {
					// Missed weeks: -1 per missed week, applied at current week
					events.push({ week: currWeek, delta: -(weekDiff - 1) });
				}
			}
		}

		if (events.length > 0) {
			userScoreEvents.set(userId, { username: userData.username, events });
		}
	}

	// Get all unique weeks from bookings
	const allWeeks = new Set<string>();
	for (const booking of bookings) {
		const week = startOfWeek(new Date(booking.courseDate), { weekStartsOn: 1 });
		allWeeks.add(week.toISOString().substring(0, 10));
	}

	const sortedWeeks = Array.from(allWeeks).sort();

	// For each user, build cumulative score array
	const users: { id: number; username: string; scores: (number | null)[]; finalScore: number }[] = [];

	for (const [userId, userData] of userScoreEvents) {
		// Sort events by week
		userData.events.sort((a, b) => a.week.getTime() - b.week.getTime());

		// Create a map of week -> cumulative score change for this user
		const weekDeltas = new Map<string, number>();
		for (const event of userData.events) {
			const weekKey = event.week.toISOString().substring(0, 10);
			weekDeltas.set(weekKey, (weekDeltas.get(weekKey) ?? 0) + event.delta);
		}

		// Find first week where this user has data
		const firstEventWeek = userData.events[0].week.toISOString().substring(0, 10);
		const firstWeekIndex = sortedWeeks.indexOf(firstEventWeek);

		// Build cumulative scores
		const scores: (number | null)[] = [];
		let cumScore = 0;
		let hasStarted = false;

		for (let i = 0; i < sortedWeeks.length; i++) {
			const week = sortedWeeks[i];

			if (i >= firstWeekIndex) {
				hasStarted = true;
			}

			if (!hasStarted) {
				scores.push(null);
			} else {
				cumScore += weekDeltas.get(week) ?? 0;
				cumScore = Math.max(0, cumScore); // Clamp at 0
				scores.push(cumScore);
			}
		}

		const finalScore = scores.filter(s => s !== null).pop() ?? 0;
		users.push({ id: userId, username: userData.username, scores, finalScore });
	}

	// Sort by final score ascending so high scores are drawn last (on top)
	users.sort((a, b) => a.finalScore - b.finalScore);

	return { weeks: sortedWeeks, users };
}
