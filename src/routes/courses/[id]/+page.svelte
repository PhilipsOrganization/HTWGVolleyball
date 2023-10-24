<script>
	import { Role } from '$lib/db/role';
	import { humanReadableDate } from '$lib/helpers/date.js';

	export let data;

	const intl = new Intl.DateTimeFormat('de-DE', {
		weekday: 'long',
		year: 'numeric',
		month: 'numeric',
		day: 'numeric'
	});

	const admin = data.user.role !== Role.USER;

	const course = data.course;
	const waitList = course.signupCount > course.maxParticipants;
</script>

<main>
	<div>
		<h2>{course.name}</h2>
		<p>{course.time}</p>
		<p>{intl.format(course.date)}</p>
		<p>{course.location}</p>

		{#if data.user.role !== Role.USER}
			<p>{intl.format(course.publishOn)}</p>
		{/if}
		<p />
		<p class:waitList>
			{course.signupCount}/{course.maxParticipants} Registrations
		</p>
	</div>

	<form class:waitList action={course.isEnrolled ? '?/drop' : '?/enlist'} method="post" style:--course-transition={`course-${course.id}`}>
		<a href="/courses">back</a>
		<button type="submit">
			{#if course.isEnrolled}
				drop
			{:else}
				enlist
			{/if}
		</button>
	</form>

	{#if admin}
		<div id="users">
			{#each data.course.participants ?? [] as participant}
				<div class="user">
					<span>{participant.username}</span>
					<a href="/admin/users/{participant.id}/stats">&#9432;</a>
					<form action="?/cancel" method="post">
						<input type="hidden" name="userId" value={participant.id} />
						<button>cancel</button>
					</form>
				</div>
			{:else}
				<p>There are currently no participants. ☹</p>
			{/each}
		</div>
	{/if}
</main>

<style>
	main,
	div {
		flex: 1;
		display: flex;
		flex-direction: column;
	}

	div {
		justify-content: center;
		max-height: 400px;
	}

	h2,
	p {
		text-align: center;
	}

	h2 {
		margin: 0 0 2rem;
	}

	p {
		margin-bottom: 0.4rem;
	}

	p.waitList {
		color: #eb714f;
	}

	form {
		view-transition-name: var(--course-transition);
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		background: #ecfbc7;
		padding: 1rem 2rem;
		width: min(80%, 450px);
		margin: 2rem auto 4rem;
		color: black;
	}

	form.waitList {
		background: #eb714f;
	}
</style>
