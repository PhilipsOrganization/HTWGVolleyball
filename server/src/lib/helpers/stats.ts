import type { Course } from '@lib/database';

function daysBetween(first: Date, last: Date) {
	return (last.getTime() - first.getTime()) / (1000 * 60 * 60 * 24);
}

const line = (pointA: [number, number], pointB: [number, number]) => {
	const lengthX = pointB[0] - pointA[0];
	const lengthY = pointB[1] - pointA[1];
	return {
		length: Math.sqrt(Math.pow(lengthX, 2) + Math.pow(lengthY, 2)),
		angle: Math.atan2(lengthY, lengthX)
	};
};

const controlPoint = (
	current: [number, number],
	previous: [number, number],
	next: [number, number],
	reverse = false
) => {
	// When 'current' is the first or last point of the array
	// 'previous' or 'next' don't exist.
	// Replace with 'current'
	const p = previous || current;
	const n = next || current;
	// The smoothing ratio
	const smoothing = 0.2;
	// Properties of the opposed-line
	const o = line(p, n);
	// If is end-control-point, add PI to the angle to go backward
	const angle = o.angle + (reverse ? Math.PI : 0);
	const length = o.length * smoothing;
	// The control point position is relative to the current point
	const x = current[0] + Math.cos(angle) * length;
	const y = current[1] + Math.sin(angle) * length;
	return [x, y];
};

const bezierCommand = (point: [number, number], i: number, a: [number, number][]) => {
	// start control point
	const [cpsX, cpsY] = controlPoint(a[i - 1], a[i - 2], point);
	// end control point
	const [cpeX, cpeY] = controlPoint(point, a[i - 1], a[i + 1], true);
	return `C ${stringify(cpsX)},${stringify(cpsY)} ${stringify(cpeX)},${stringify(cpeY)} ${stringify(
		point[0]
	)},${stringify(point[1])}`;
};

function stringify(value: number) {
	if (isNaN(value)) {
		return '0';
	}

	const fixed = value.toFixed(1);
	if (fixed.endsWith('.0')) {
		return fixed.substring(0, fixed.length - 2);
	}
	return fixed;
}

const svgPath = (points: [number, number][]) => {
	// build the d attributes by looping over the points
	const d = points.reduce(
		(acc, point, i, a) =>
			i === 0
				? // if first point
				  `M ${point[0]},${point[1]}`
				: // else
				  `${acc} ${bezierCommand(point, i, a)}`,
		''
	);
	return d;
};

export function getPath(courses: Course[]) {
	const first = courses[0];
	const last = courses.at(-1);

	if (!first || !last) {
		return '';
	}

	const totalDays = daysBetween(first.date, last.date);

	const buckets = new Array(totalDays).fill(1);
	for (const course of courses) {
		const index = daysBetween(first.date, course.date);
		buckets[index] = (buckets[index] ?? 0) + 1;
	}

	const maxCount = Math.max(...buckets);

	const path: [number, number][] = [[0, 100]];
	for (let i = 0; i < buckets.length; i++) {
		const x = (i / (buckets.length - 1)) * 100;
		const y = 100 - (buckets[i] / maxCount) * 80;
		path.push([x, y]);
	}
	path.push([100, 100]);

	return svgPath(path);
}
