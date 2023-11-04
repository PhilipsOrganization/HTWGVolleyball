<script>
	import { Role } from '$lib/db/role';
	import { draw } from 'svelte/transition';

	export let data;

	const user = data.user;

	/**
	 *
	 * @param date {Date}
	 */
	function format(date) {
		return new Intl.DateTimeFormat('de-DE', {
			weekday: 'long',
			year: 'numeric',
			month: 'numeric',
			day: 'numeric'
		}).format(date);
	}

	async function copyResetPasswordLink() {
		const req = await fetch(`/admin/users/${user.id}/reset-pw`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: user.id + ''
		});

		const url = new URL(window.location.href);
		const { link } = await req.json();
		await navigator.clipboard.writeText(url.origin + link);
	}
</script>

<section>
	<h1>Stats for {user.username}</h1>
	{#if user.role === Role.ADMIN}
		<form action="?/demote" method="post">
			<button>demote to user</button>
		</form>
	{:else if user.role === Role.USER}
		<form action="?/promote" method="post">
			<button>promote to admin</button>
		</form>
	{/if}

	<div>
		<button class="small" on:click={copyResetPasswordLink}>Copy Reset Password Link</button>
		<form action="?/delete" method="post">
			<button class="small">Delete User</button>
		</form>
	</div>
	<br>
	<div class="column">
		<p>Registered: {format(user.createdAt)}</p>
		<p>Last Login: {format(user.lastLogin)}</p>
	</div>

	<br />
	<div>
		<p class="red">Number of Strikes: {user.strikes}</p>
		{#if user.strikes > 0}
			<form action="?/unstrike" method="post">
				<button class="small">remove</button>
			</form>
		{/if}
	</div>
	<br />
	<p>Registered for {data.totalRegistrations} Courses</p>
	{#each data.stats as course}
		<p>{course.courseName}: {course.count}</p>
	{:else}
		<p>No courses registered</p>
	{/each}
</section>

<div class="center">
	<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		<path in:draw={{ duration: 1000 }} fill="none" stroke="grey" d={data.svg} />
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
		flex-direction: row;
		align-items: center;
	}

	div.center {
		justify-content: center;
		margin: 1rem;
		width: 80%;
		height: 200px;
	}

	div.column {
		flex-direction: column;
		align-items: flex-start;
	}

	svg {
		width: 100%;
		height: 100%;
	}

	button {
		padding: 20px;
		background: #9cc1cf;
		margin: 10px;
		color: black;
	}

	.red {
		color: #ecfbc7;
	}

	.small {
		padding: 10px;
		background: #ecfbc7;
	}
</style>
