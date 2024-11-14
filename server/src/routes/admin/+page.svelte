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

<CreateCourse groups={data.groups} />
<main>
	<div>
		<label for="archived">Show archived</label>
		<input type="checkbox" id="archived" on:change={(e) => toggleShowArchived(e)} />
	</div>
	<a href="/admin/groups"> Groups </a>

	<div id="list">
		{#each data.dates ?? [] as block}
			<div id="block">
				<h2>{humanReadableDate(block.date)}</h2>
				{#each block.courses as course, i}
					<Course {course} admin isFirst={i === 0} />
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
		margin-bottom: 3rem;
		border-radius: 12px 12px 0 0;
		background: #2a2a2a;
		padding-top: 1rem;
	}

	h2 {
		text-align: center;
		margin: 0 0 1rem;
		text-transform: capitalize;
		letter-spacing: 1.1px;
		font-weight: 200;
	}
</style>
