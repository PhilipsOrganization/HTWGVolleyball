<script>
	import { enhance } from '$app/forms';
	import { page } from '$app/stores';

	export let data;
	let course = data.course;

	/**
	 * @returns {(data: {result: any}) => void}
	 */
	function updateCourse() {
		return ({ result }) => {
			course = result?.data?.course;
		};
	}

	const intl = new Intl.DateTimeFormat('de-DE', {
		weekday: 'long',
		year: 'numeric',
		month: 'numeric',
		day: 'numeric'
	});

	const admin = $page.url.searchParams.has('admin');
	const waitList = course.signupCount > course.maxParticipants;
</script>

<main>
	<section>
		<h2>
			{course.name}
			{#if course.isEnrolled}
				<small class="isSignedUp"> - registered</small>
			{/if}
		</h2>
		<p class="bold">{course.time}</p>
		<p>{intl.format(course.date)}</p>
		<p>{course.location}</p>

		{#if admin}
			{@const intlAdmin = new Intl.DateTimeFormat('de-DE', {
				weekday: 'long',
				year: 'numeric',
				month: 'numeric',
				day: 'numeric',
				hour: 'numeric',
				minute: 'numeric'
			})}
			<p>Is published on: {intlAdmin.format(course.publishOn)}</p>
		{/if}
		<p class:waitList>
			{course.signupCount}/{course.maxParticipants} Registrations
		</p>
	</section>

	<div class:waitList class="actions" style:--course-transition={`course-${course.id}`}>
		<a href={admin ? '/admin' : '/courses'}>back</a>
		{#if admin}
			<form class="waitlist" action="?/delete-course" method="post">
				<button type="submit">delete</button>
			</form>
		{/if}
		<form action={`?/${course.isEnrolled ? 'drop' : 'enlist'}${admin ? '&admin' : ''}`} method="post" use:enhance={updateCourse}>
			<button type="submit" disabled={course.isPast}>
				{#if course.isEnrolled}
					drop
				{:else}
					enlist
				{/if}
			</button>
		</form>
	</div>
	{#if admin}
		<div id="users">
			<h2>Participants</h2>
			{#each course.participants ?? [] as participant}
				<div class="user">
					<span>{participant.username}</span>
					<a href="/admin/users/{participant.id}/stats">&#9432;</a>
					<form action="?/cancel" method="post" use:enhance={updateCourse}>
						<input type="hidden" name="userId" value={participant.id} />
						<button class="underline">cancel</button>
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
	section {
		flex: 1;
		display: flex;
		flex-direction: column;
	}

	section {
		justify-content: center;
		max-height: 400px;
		padding-top: 2rem;
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

	.isSignedUp {
		color: #9cc1cf;
		font-weight: 800;
	}

	.waitList {
		color: #eb714f;
	}

	div.actions {
		view-transition-name: var(--course-transition);
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		background: #ecfbc7;
		padding: 1rem 2rem;
		width: min(80%, 450px);
		max-width: 60vw;
		margin: 2rem auto 4rem;
		color: black;
	}

	button:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	div.actions.waitList {
		background: #eb714f;
	}

	#users {
		display: flex;
		flex-direction: column;
		margin: 0 auto;
		width: min(80%, 450px);
	}

	.user {
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.5rem;
	}

	.underline {
		text-decoration: underline;
	}
</style>
