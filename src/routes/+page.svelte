<script>
	import Course from '$lib/components/course.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;

	/** @type {number} */
	let courseID;
</script>

<main>
	{#if data.dates?.length === 0}
		<p>There are currently no courses. ☹</p>
	{:else}
		<h2>Avaliable Courses:</h2>
		<p> <a href="/login">Sign in</a> to register</p>
	{/if}
	<div id="list">
		{#each data.dates ?? [] as block, i}
			<span>{humanReadableDate(block.date)}</span>
			{#each block.courses as course}
				<Course
					{course}
					on:select={(c) => (courseID = c.detail.course)}
					selected={course.id === courseID}
				/>
			{/each}
			{#if i < data.dates?.length - 1}
				<div class="line" />
			{/if}
		{/each}
	</div>
</main>

<style>
	span {
		font-size: 14px;
		font-weight: bold;
		text-transform: capitalize;
		margin-top: 20px;
		display: block;
		margin-left: 20px;
	}

	.line {
		width: 60%;
		margin: 60px 20% 50px;
		height: 2px;
		opacity: 0.4;
		background: linear-gradient(90deg, var(--c80) 0%, var(--c40) 50%, var(--c80) 100%);
	}

	main {
		display: flex;
		flex-direction: column;
		margin: 5dvh auto 15dvh;
		width: 90vw;
		max-width: 700px;
		box-sizing: border-box;
	}

	@media screen and (max-height: 600px) {
		#list {
			max-height: 40dvh;
		}
	}
</style>
