<script>
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import Course from '$lib/components/course.svelte';
	import CreateCourse from '$lib/components/createCourse.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;

	/** @type {number} */
	$: courseID = parseInt($page.url.searchParams.get('course') ?? '0');

	/** @param {boolean} show  */
	function toggleShowArchived(show) {
		show ? $page.url.searchParams.set('archived', 'true') : $page.url.searchParams.delete('archived');
		goto($page.url.toString(), { replaceState: true, invalidateAll: true });
	}
</script>

<CreateCourse />
<main>
	<h1>Courses <a href="/admin/users">Manage Users</a></h1>
	<div id="list">
		<div>
			<label for="archived">Show archived</label>
			<input type="checkbox" id="archived" on:change={(e) => toggleShowArchived(e.target.checked)} />
		</div>

		{#each data.dates ?? [] as block, i}
			<div id="block">
				<span>{humanReadableDate(block.date)}</span>
				{#each block.courses as course}
					<Course {course} admin />
				{/each}
			</div>
		{/each}
		{#if data.dates?.length === 0}There are currently no courses. ☹{/if}
	</div>
</main>

<style>
	h1 {
		text-align: center;
	}

	main {
		display: flex;
		flex-direction: column;
		margin: 5dvh auto 15dvh;
		width: 90vw;
		max-width: 700px;
		box-sizing: border-box;
	}

	#list {
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

	a {
		text-decoration: none;
	}
</style>
