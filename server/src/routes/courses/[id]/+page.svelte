<script>
	import { enhance } from '$app/forms';
	import { page } from '$app/state';
	import ConfirmableForm from '$lib/components/confirmable-form.svelte';
	import { addToast } from '$lib/helpers/toast';
	import { format, isToday } from 'date-fns';
	import { char } from 'drizzle-orm/mysql-core';

	let { data } = $props();
	let course = $derived(data.course);
	let justSignedUp = $state(false);

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

	let admin = $derived(page.url.searchParams.has('admin'));
	let waitList = $derived(Math.min(course.signupCount, course.spot < 0 ? Infinity : course.spot) > course.maxParticipants);

	function copyUsers() {
		const filtered = course.participants.filter((p) => !p.canceledAt);
		const enlisted = filtered
			.slice(0, course.maxParticipants)
			.map((r) => r.username)
			.sort((a, b) => a.localeCompare(b));

		let registrations = `*${course.name}:*\n${enlisted.join(',\n')}`;

		if (filtered.length > course.maxParticipants) {
			const waitList = filtered.slice(course.maxParticipants).map((r, i) => `#${i + 1}: ${r.username}`);
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
		</h2>
		<div class="status-badge">
			{#if course.isEnrolled}
				{#if course.isOnWaitlist}
					<span class="badge waitList">on waitlist spot #{course.spot - course.maxParticipants + 1}</span>
				{:else}
					<span class="badge isSignedUp">registered</span>
				{/if}
			{/if}
		</div>
		<p class="time bold">{course.time}</p>
		<p class="date">{intl.format(new Date(course.date))}</p>
		<p class="location">{course.location}</p>

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
		<a class="btn-secondary" href={admin ? '/admin' : '/courses'}>back</a>
		{#if admin}
			<form class="waitlist" action="?/delete-course" method="post" use:enhance>
				<ConfirmableForm message="Do you really want to delete this course?">
					{#snippet children(onclick, type)}
						<button class="btn-danger" {type} {onclick}>delete</button>
					{/snippet}
				</ConfirmableForm>
			</form>
		{/if}
		{#if course.isEnrolled}
			<form action={`?/drop${admin ? '&admin' : ''}`} method="post" use:enhance={updateCourse}>
				<ConfirmableForm message="Do you really want to drop this course?">
					{#snippet children(onclick, type)}
						<button class="btn-action" {type} {onclick}> drop </button>
					{/snippet}
				</ConfirmableForm>
			</form>
		{:else}
			<form action={`?/enlist${admin ? '&admin' : ''}`} method="post" use:enhance={updateCourse}>
				<button class="btn-action" type="submit" disabled={course.isPast}> enlist </button>
			</form>
		{/if}
	</div>
	{#if admin}
		<div id="users">
			<div class="header">
				<h2>Participants</h2>
				{#if course.participants.length}
					<button class="underline" onclick={copyUsers}>Copy for WhatsApp</button>
				{/if}
			</div>

			{#each course.participants ?? [] as participant, index}
				{@const idx = course.participants.filter((p) => !p.canceledAt).findIndex((p) => p.id === participant.id)}
				{@const isOnWaitList = idx >= course.maxParticipants}
				<div class="user-row" class:waitList={isOnWaitList} class:is-canceled={participant.canceledAt}>
					<div class="user-info">
						<div class="user-name">
							<b class="ellipsis">{participant.username}</b>
							{#if isOnWaitList && !participant.canceledAt}
								<span class="waitlist-indicator">WL</span>
							{/if}
						</div>
						{#if participant.canceledAt}
							{@const canceledToday = isToday(participant.canceledAt) && false}
							{@const dateFormat = canceledToday ? 'HH:mm' : 'dd.MM. HH:mm'}
							<div class="canceled-at">canceled {format(participant.canceledAt, dateFormat)}</div>
						{/if}
					</div>
					<div class="user-actions">
						<a title="Stats" href="/admin/users/{participant.id}/stats">&#9432;</a>
						<form action="?/strike" method="post" use:enhance={updateCourse}>
							<input type="hidden" name="userId" value={participant.id} />
							<ConfirmableForm message="Do you really want to strike this user?">
								{#snippet children(onclick, type)}
									<button {type} {onclick} class="underline strike-btn">strike</button>
								{/snippet}
							</ConfirmableForm>
						</form>
						{#if !participant.canceledAt}
							<form action="?/cancel" method="post" use:enhance={updateCourse}>
								<input type="hidden" name="userId" value={participant.id} />
								<ConfirmableForm message="Do you really want to cancel this user?">
									{#snippet children(onclick, type)}
										<button {type} {onclick} class="underline cancel-btn">cancel</button>
									{/snippet}
								</ConfirmableForm>
							</form>
						{/if}
					</div>
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
		color: #ecfbc7;
		font-weight: 800;
	}

	.badge {
		padding: 0.2rem 0.6rem;
		border-radius: 4px;
		font-size: 0.8rem;
		text-transform: uppercase;
		letter-spacing: 0.05rem;
	}

	.badge.isSignedUp {
		background: #ecfbc7;
		color: #131313;
	}

	.badge.waitList {
		background: #eb714f;
		color: #131313;
	}

	.status-badge {
		display: flex;
		justify-content: center;
		margin-top: -0.5rem;
		margin-bottom: 1rem;
	}

	.time {
		font-size: 1.5rem;
	}

	.date {
		opacity: 0.8;
	}

	.location {
		font-style: italic;
		opacity: 0.8;
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

	.btn-action,
	.btn-secondary,
	.btn-danger {
		padding: 0.5rem 1rem;
		text-transform: uppercase;
		font-weight: 500;
		transition: transform 0.1s ease;
	}

	.btn-action:active,
	.btn-secondary:active,
	.btn-danger:active {
		transform: scale(0.95);
	}

	.btn-secondary {
		opacity: 0.7;
	}

	.btn-danger {
		color: #830000;
	}

	#users {
		display: flex;
		flex-direction: column;
		margin: 0 auto 6rem;
		width: min(90%, 9000px);
	}

	.user-row {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 1rem;
		padding: 0.75rem 1rem;
		margin-bottom: 0.5rem;
		background: #1a1a1a;
		border-radius: 4px;
		transition: background 0.2s ease;
	}

	.user-row:hover {
		background: #222;
	}

	.user-row.waitList {
		border-left: 3px solid #eb714f;
	}

	.user-row.is-canceled {
		opacity: 0.6;
		background: #1a1a1a;
	}

	.user-info {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		flex: 1;
		min-width: 0;
	}

	.user-name {
		display: flex;
		align-items: center;
		gap: 0.5rem;
	}

	.waitlist-indicator {
		padding: 0.1rem 0.4rem;
		font-size: 0.7rem;
		background: #eb714f;
		color: #131313;
		border-radius: 3px;
		text-transform: uppercase;
		font-weight: 700;
	}

	.user-actions {
		display: flex;
		align-items: center;
		gap: 1rem;
		justify-content: flex-end;
		flex-shrink: 0;
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

	.canceled-at {
		color: #ff592b;
		font-size: 0.85rem;
		white-space: nowrap;
		font-weight: 400;
	}

	.strike-btn {
		color: #e65932;
	}

	.cancel-btn {
		color: #eb714f;
	}
</style>
