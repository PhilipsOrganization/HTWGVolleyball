<script>
	import { fade } from 'svelte/transition';

	/**
	 * @typedef {Object} Props
	 * @property {import('$lib/db/entities').CourseDTO} course
	 * @property {boolean} [isFirst]
	 * @property {boolean} [admin]
	 */

	/** @type {Props} */
	let { course, isFirst = false, admin = false } = $props();

	const spot = course.spot + 1;
	const waitlistSpot = spot - course.maxParticipants;
	const href = `courses/${course.id}${admin ? '?admin' : ''}`;
</script>

<a {href} in:fade>
	<div
		aria-roledescription="course"
		class:enlisted={course.isEnrolled}
		class:on-waitlist={waitlistSpot > 0}
		class:first={isFirst}
		class:isPast={course.isPast}
		style:--course-transition={`course-${course.id}`}
	>
		<span>{course.name}</span>

		{#if course.isEnrolled}
			{#if waitlistSpot > 0}
				<span>#{waitlistSpot}</span>
			{:else}
				<span>✅</span>
			{/if}
		{:else}
			<span>{course.signupCount}/{course.maxParticipants}</span>
		{/if}

		<p class="underline right">
			{#if admin || course.isPast}
				details
			{:else}
				{course.isEnrolled ? 'drop ' : 'enlist'}
			{/if}
		</p>
	</div>
</a>

<style>
	div {
		display: grid;
		grid-template-columns: 1fr 1fr 1fr;

		padding: 1rem 2rem;
		border-bottom: 1px solid #5d5d5d;
		view-transition-name: var(--course-transition);
	}

	div.first {
		border-top: 1px solid #5d5d5d;
	}

	span {
		font-weight: 200;
	}

	span:nth-child(2) {
		text-align: center;
	}

	a.right {
		display: flex;
		justify-content: flex-end;
	}

	p {
		all: unset;
		min-width: 8ch;
		text-align: center;
	}

	.underline {
		text-decoration: underline;
	}

	.enlisted {
		background-color: #9cc1cf;
		color: #000;
	}

	.enlisted span {
		font-weight: bold;
	}

	.isPast {
		opacity: 0.7;
	}

	.on-waitlist {
		background-color: #eb714f;
	}
</style>
