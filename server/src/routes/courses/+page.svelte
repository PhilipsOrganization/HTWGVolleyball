<script>
	import Course from '$lib/components/course.svelte';
	import { humanReadableDate } from '$lib/helpers/date';

	export let data;
</script>

<main>
	<div id="list">
		{#each data.dates ?? [] as block}
			<div id="block">
				<h2>{humanReadableDate(block.date)}</h2>
				{#each block.courses as course, i}
					<Course {course} isFirst={i === 0} />
				{/each}
			</div>
		{:else}
			<p>No courses are found.</p>
			{#if data.user.hasNotificationsEnabled}
				<p>Notifications for updates are enabled.</p>
			{:else}
				<p>you can enable notifications in your <a href="/profile">Profile</a> for updates.</p>
			{/if}
		{/each}
	</div>
</main>

<style>
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

	main {
		display: flex;
		flex-direction: column;
		margin: 5dvh auto 15dvh;
		width: 90vw;
		max-width: 700px;
		box-sizing: border-box;
	}

	h2 {
		text-align: center;
		margin: 0 0 2rem;
		text-transform: capitalize;
	}
</style>
