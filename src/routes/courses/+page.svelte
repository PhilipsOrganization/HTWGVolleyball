<script>
	import Course from '$lib/components/course.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;

	/** @type {number | null} */
	let courseID;
</script>

<main>
	<div id="list">
		{#each data.dates ?? [] as block, i}
			<span>{humanReadableDate(block.date)}</span>
			{#each block.courses as course}
				<Course
					{course}
					on:select={(c) => (courseID = c.detail.course)}
					selected={course.isEnrolled}
					action={course.isEnrolled ? '?/drop' : '?/enlist'}
					actionName={course.isEnrolled ? 'drop' : 'enlist'}
					spot={course.isEnrolled ? course.spot + 1 : 0}
				/>
			{/each}
			{#if i < data.dates?.length - 1}
				<div class="line" />
			{/if}
		{/each}
	</div>
</main>

<style>
	#list {
		margin-bottom: 4vh;
		padding-right: 5px;
	}

	main {
		display: flex;
		flex-direction: column;
		margin: 5dvh auto 15dvh;
		width: 90vw;
		max-width: 700px;
		box-sizing: border-box;
	}
</style>
