<script>
	import { enhance } from '$app/forms';
	import { page } from '$app/stores';
	import ConfirmableForm from '$lib/components/confirmable-form.svelte';
	import { addToast } from '$lib/helpers/toast';
	import { format, isToday } from 'date-fns';
	import da from 'date-fns/locale/da';

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
			if (!course.isOnWaitlist && update.isOnWaitlist) {
				addToast('info', 'You have been put on the waitlist for this course.');
				course = update;
				return;
			}

			if (justSignedUp) {
				addToast('success', 'You have successfully signed up for this course!', 2000);
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
	const waitList = Math.min(course.signupCount, course.spot < 0 ? Infinity : course.spot) > course.maxParticipants;

	function copyUsers() {
		const enlisted = course.participants
			.slice(0, course.maxParticipants)
			.map((r) => r.username)
			.sort((a, b) => a.localeCompare(b));

		let registrations = `*${course.name}:*\n${enlisted.join(',\n')}`;

		if (course.participants.length > course.maxParticipants) {
			const waitList = course.participants.slice(course.maxParticipants).map((r, i) => `#${i + 1}: ${r.username}`);
			registrations += `\n_Warteliste:_\n${waitList.join(',\n')}`;
		}

		navigator.clipboard.writeText(registrations);
		addToast('success', 'Copied registrations to clipboard.');
	}
</script>

<main>
	<section>
		<h2>
			{course.name}
			{#if course.isEnrolled}
				{#if course.isOnWaitlist}
					<small class="isSignedUp waitList"> - on waitlist spot #{course.spot - course.maxParticipants + 1}</small>
				{:else}
					<small class="isSignedUp"> - registered</small>
				{/if}
			{/if}
		</h2>
		<p class="bold">{course.time}</p>
		<p>{intl.format(new Date(course.date))}</p>
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
			<p>Is published on: {intlAdmin.format(new Date(course.publishOn))}</p>
			{#if data.group}
				<p>
					<a href="/admin/groups/{data.group.id}">Group: {data.group.name}</a>
				</p>
			{/if}
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
			<ConfirmableForm message="Do you really want to delete this course?">
				<form class="waitlist" action="?/delete-course" method="post" slot="confirm">
					<button type="submit">delete</button>
				</form>
				<button type="submit" slot="button">delete</button>
			</ConfirmableForm>
		{/if}
		{#if course.isEnrolled}
			<ConfirmableForm message="Do you really want to drop this course?">
				<form action={`?/drop${admin ? '&admin' : ''}`} method="post" use:enhance={updateCourse} slot="confirm">
					<button type="submit"> Drop </button>
				</form>
				<button type="submit" disabled={course.isPast} slot="button"> drop </button>
			</ConfirmableForm>
		{:else}
			<form action={`?/enlist${admin ? '&admin' : ''}`} method="post" use:enhance={updateCourse}>
				<button type="submit" disabled={course.isPast}> enlist </button>
			</form>
		{/if}
	</div>
	{#if admin}
		<div id="users">
			<div class="header">
				<h2>Participants</h2>
				{#if course.participants.length}
					<button class="underline" on:click={copyUsers}>Copy for WhatsApp</button>
				{/if}
			</div>

			{#each course.participants ?? [] as participant, index}
				<div class="user" class:waitList={index >= course.maxParticipants}>
					<span>
						<b class="ellipsis" class:canceled={participant.canceledAt}>{participant.username}</b>
						{#if participant.canceledAt}
							{@const canceledToday = isToday(participant.canceledAt) && false}
							{@const dateFormat = canceledToday ? 'HH:mm' : 'dd.MM. HH:mm'}
							<em>canceled at  {format(participant.canceledAt, dateFormat)} </em>
						{/if}
					</span>
					<a href="/admin/users/{participant.id}/stats">&#9432;</a>
					<ConfirmableForm message="Do you really want to strike this user?">
						<form action="?/strike" method="post" use:enhance={updateCourse} slot="confirm">
							<input type="hidden" name="userId" value={participant.id} />
							<button type="submit" class="underline">strike</button>
						</form>
						<button type="submit" class="underline" slot="button">strike</button>
					</ConfirmableForm>
					<ConfirmableForm message="Do you really want to cancel this user?">
						<form action="?/cancel" method="post" use:enhance={updateCourse} slot="confirm">
							<input type="hidden" name="userId" value={participant.id} />
							<button type="submit" class="underline">cancel</button>
						</form>
						<button type="submit" class="underline" slot="button">cancel</button>
					</ConfirmableForm>
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
		margin: 0 auto 6rem;
		width: min(90%, 1150px);
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

	.header {
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.5rem;
	}

	.ellipsis {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		width: 100%;
	}

	.underline {
		text-decoration: underline;
	}

	.canceled {
		text-decoration: line-through;
		color: #eb714f;
	}

</style>
