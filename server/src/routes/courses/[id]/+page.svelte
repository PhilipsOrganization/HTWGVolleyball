<script>
	import { enhance } from '$app/forms';
	import { page } from '$app/stores';
	import { addToast } from '$lib/helpers/toast';

	export let data;
	let course = data.course;
	let justSignedUp = false;

	/**
	 * @returns {(data: {result: any}) => void}
	 */
	function updateCourse() {
		return ({ result }) => {
			if (result.error) {
				addToast('error', result.error.message);
				return;
			}

			const update = result?.data?.course;
			if (!update) {
				return;
			}

			justSignedUp = update.isEnrolled && !course.isEnrolled && !course.isOnWaitlist;
			if (justSignedUp) {
				addToast('success', 'You have successfully signed up for this course!', 2000);
			}

			if (course.isOnWaitlist) {
				addToast('info', 'You have been put on the waitlist for this course.');
			}

			course = update;
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

	<div
		class:waitList
		class="actions"
		class:isSignedUp={course.isEnrolled}
		class:justSignedUp
		style:--course-transition={`course-${course.id}`}
	>
		<a href={admin ? '/admin' : '/courses'}>back</a>
		{#if admin}
			<form class="waitlist" action="?/delete-course" method="post">
				<button type="submit">delete</button>
			</form>
		{/if}
		<form action={`?/${course.isEnrolled ? 'drop' : 'enlist'}${admin ? '&admin' : ''}`} method="post" use:enhance={updateCourse}>
			{#if course.isEnrolled}
				<button type="submit" disabled={course.isPast}> drop </button>
			{:else}
				<button type="submit" disabled={course.isPast}> enlist </button>
			{/if}
		</form>
	</div>
	{#if admin}
		<div id="users">
			<h2>Participants</h2>
			{#each course.participants ?? [] as participant}
				<div class="user">
					<span class="ellipsis">{participant.username}</span>
					<a href="/admin/users/{participant.id}/stats">&#9432;</a>
					<form action="?/strike" method="post" use:enhance={updateCourse}>
						<input type="hidden" name="userId" value={participant.id} />
						<button class="underline">strike</button>
					</form>
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
		position: relative;
		view-transition-name: var(--course-transition);
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		background: #9cc1cf;
		padding: 1rem 2rem;
		width: min(80%, 450px);
		max-width: 60vw;
		margin: 2rem auto 4rem;
		color: black;
		transition: background 0.1s ease-in-out 0.2s;
	}

	div.actions.isSignedUp {
		background: #ecfbc7;
	}

	div.actions.justSignedUp::after {
		content: '';
		position: absolute;
		inset: 0 0 0 auto;
		background: #b3f117;
		box-shadow: 0 0 15px 0 #ecfbc7;
		pointer-events: none;
		animation: scale 0.3s cubic-bezier(0.8, 0.25, 0.9, 0.5) forwards;
	}

	@keyframes scale {
		0% {
			left: 100%;
			opacity: 0.7;
		}
		80% {
			left: 0;
			opacity: 0.4;
		}
		100% {
			opacity: 0;
		}
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
		width: min(90%, 650px);
	}

	.user {
		display: grid;
		grid-template-columns: 2fr repeat(3, 1fr);
		justify-items: center;
		align-items: center;
		flex-direction: row;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.5rem;
		gap: 1rem;
	}

	.ellipsis {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		width: 100px;
	}

	.underline {
		text-decoration: underline;
	}
</style>
