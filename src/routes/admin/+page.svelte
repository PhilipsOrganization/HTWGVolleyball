<script>
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import Course from '$lib/components/course.svelte';
	import CreateCourse from '$lib/components/createCourse.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;

	/** @param {Event & {currentTarget: EventTarget & HTMLInputElement}} event  */
	function toggleShowArchived(event) {
		const show = event.currentTarget.checked;
		show ? $page.url.searchParams.set('archived', 'true') : $page.url.searchParams.delete('archived');
		goto($page.url.toString(), { replaceState: true, invalidateAll: true });
	}
</script>

<CreateCourse />
<main>
	<div>
		<label for="archived">Show archived</label>
		<input type="checkbox" id="archived" on:change={(e) => toggleShowArchived(e)} />
	</div>

	<div id="list">
		{#each data.dates ?? [] as block, i}
			<div id="block">
				<h2>{humanReadableDate(block.date)}</h2>
				{#each block.courses as course}
					<Course {course} admin />
				{/each}
			</div>
		{/each}
		{#if data.dates?.length === 0}There are currently no courses. ☹{/if}
	</div>
</main>

<style>
	main {
		display: flex;
		flex-direction: column;
		margin: 0 auto 15dvh;
		width: 90vw;
		max-width: 700px;
		box-sizing: border-box;
	}

	#list {
		margin-top: 2rem;
		flex: 1;
		display: flex;
		flex-direction: column;
	}

	#block {
		flex: 1;
		display: flex;
		flex-direction: column;
		margin-bottom: 6rem;
	}

	h2 {
		text-align: center;
		margin: 0 0 2rem;
		text-transform: capitalize;
	}
</style>
