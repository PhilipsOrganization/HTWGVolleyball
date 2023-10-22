<script>
	import { createEventDispatcher } from 'svelte';
	import { humanReadableDate } from '../helpers/date';
	import Scale from './scale.svelte';
	const dispatch = createEventDispatcher();

	/** @type {import('$lib/db/entities/course').CourseDTO} */
	export let course;

	/** @type {string | undefined} */
	export let action = undefined;

	/** @type {string | undefined} */
	export let actionName = undefined;

	export let selected = false;
	export let fullDate = false;
	export let showPublishDate = false;
	export let spot = 0;

	$: registered = course?.signupCount;

	$: formated = new Intl.DateTimeFormat('en-GB', {
		weekday: 'short',
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit'
	}).format(new Date(course.publishOn));
</script>

<div
	class="course"
	on:click={() => dispatch('select', { course: course.id })}
	aria-roledescription="course"
	role="button"
	tabindex="0"
	on:keydown={(e) => {
		if (e.key === 'Enter') dispatch('select', { course: course.id });
	}}
	class:dark={selected}
>
	<div class="flex">
		<b>{course.name}</b>
		<span id="time">
			{#if fullDate}
				{humanReadableDate(course.date)} at {course.time}
			{:else}
				{course.time}
			{/if}
		</span>
	</div>
	{#if course.isEnrolled}
		<div class="center">
			{#if spot > 0}
				{@const waitlistSpot = spot - course.maxParticipants}
				{#if waitlistSpot > 0}
					<span>Waitlist: #{waitlistSpot}</span>
				{:else}
					<span>#{spot}</span>
				{/if}
			{/if}
		</div>
	{:else}
		<Scale avaliable={course.maxParticipants} booked={registered} dark={selected} />
	{/if}
	<span>{course.location}</span>
	{#if showPublishDate}
		<br />
		<span>Publish On: {formated} </span>
	{/if}
	{#if action && actionName}
		<form {action} method="post">
			<input type="hidden" name="courseId" value={course.id} />
			<button>{actionName}</button>
		</form>
	{/if}
</div>

<style>
	.dark {
		background: var(--c40) !important;
		color: var(--c100);
	}

	div.course::before {
		--width: 4px;
		content: '';
		position: absolute;
		top: 10px;
		left: var(--width);
		right: 0;
		z-index: 5;
		bottom: 10px;
		box-shadow: var(--width) 0px 0 0px var(--cAccent);
		pointer-events: none;
	}

	div.course {
		/* background: linear-gradient(90deg, var(--c100) 20%, color.scale(var(--c80), $alpha: -60%) 100%); */
		border-radius: 10px;
		padding: 15px 20px;
		margin-top: 10px;
		position: relative;
		cursor: pointer;
	}

	form,
	button {
		background: black;
		color: #fff;
		border: 0;
		height: 2em;
		cursor: pointer;
		font-weight: bold;
		letter-spacing: 0.5px;
		float: right;
	}

	button {
		padding: 5px 25px 0;
	}

	.flex {
		display: flex;
		justify-content: space-between;
	}

	.center {
		text-align: center;
		font-size: large;
		color: var(--cAccent);
	}
</style>
