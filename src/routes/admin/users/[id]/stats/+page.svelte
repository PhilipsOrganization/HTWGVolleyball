<script>
	import { Role } from '$lib/db/role';

	export let data;

	const user = data.user;
</script>

<section>
	<h1>Stats for {user.username}</h1>
	{#if user.role === Role.ADMIN}
		<form action="?/demote" method="post">
			<input type="hidden" name="userId" value={user.id} />
			<button>demote to user</button>
		</form>
	{:else if user.role === Role.USER}
		<form action="?/promote" method="post">
			<input type="hidden" name="userId" value={user.id} />
			<button>promote to admin</button>
		</form>
	{/if}

	<p>Registered for {data.totalRegistrations} courses</p>
	{#each data.stats as course}
		<p>{course.courseName}: {course.count}</p>
	{:else}
		<p>No courses registered</p>
	{/each}
</section>

<div>
	<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		{@html data.svg}
	</svg>
</div>

<style>
	section {
		display: flex;
		flex-direction: column;
		padding: 1rem;
		gap: 0px;
	}

	p {
		margin: 0;
	}

	div {
		display: flex;
		justify-content: center;
		align-items: center;
		margin: 1rem;
		width: 100%;
		height: 200px;
	}

	svg {
		width: 100%;
		height: 100%;
	}
</style>
