<script>
	import ConfirmableForm from '$lib/components/confirmable-form.svelte';
	import { onMount } from 'svelte';

	export let data;
	let notificationsSupported = false;

	onMount(() => {
		notificationsSupported = 'serviceWorker' in navigator && 'PushManager' in window;
	});

	async function enableNotification() {
		await Notification.requestPermission();
		const registration = await navigator.serviceWorker.getRegistration();

		if (!registration) {
			return alert('registration failed');
		}

		const subscription = await registration.pushManager.subscribe({
			userVisibleOnly: true,
			applicationServerKey: urlBase64ToUint8Array(import.meta.env.VITE_VAPID_PUBLIC)
		});

		const request = await fetch('/profile', {
			method: 'POST',
			body: JSON.stringify({ subscription }),
			headers: {
				'content-type': 'application/json'
			}
		});

		if (!request.ok) {
			console.log(await request.text());
			return alert('subscription failed');
		}

		const user = await request.json();
		data = { ...data, user };
	}

	/**
	 * @param {string} base64String
	 */
	function urlBase64ToUint8Array(base64String) {
		const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
		const base64 = (base64String + padding).replace(/\-/g, '+').replace(/_/g, '/');

		const rawData = window.atob(base64);
		const outputArray = new Uint8Array(rawData.length);

		for (let i = 0; i < rawData.length; ++i) {
			outputArray[i] = rawData.charCodeAt(i);
		}
		return outputArray;
	}

	async function disableNotification() {
		const request = await fetch('/profile', {
			method: 'DELETE'
		});

		if (!request.ok) {
			return alert('subscription failed');
		}

		const user = await request.json();
		data = { ...data, user };
	}

	/**
	 *
	 * @param {number} time
	 */
	function approximatelyFormatTime(time) {
		const days = Math.floor(time / 60 / 60 / 24);
		const hours = Math.floor(time / 60 / 60) - days * 24;
		const minutes = Math.floor(time / 60) - hours * 60 - days * 24 * 60;
		const seconds = Math.floor(time) - minutes * 60 - hours * 60 * 60 - days * 24 * 60 * 60;

		let result = '';
		if (days > 0) {
			result += `${days} days `;
		}

		if (hours > 0) {
			result += `${hours} hours `;
		}

		if (minutes > 0) {
			result += `${minutes} minutes `;
		}

		result += `${seconds} seconds`;

		return result;
	}
</script>

<section>
	<h1>Profile</h1>

	<h3>Email</h3>
	{#if data.user.emailVerified}
		<!-- TODO: disable email notifications -->
		<p>Email verified</p>
	{:else}
		<p class="red">Email not verified</p>
		<ConfirmableForm message="Do you really want to resend the verification email?">
			<form action="?/reverify" method="post" slot="confirm">
				<button class="confirm">Resend verification email</button>
			</form>
			<button slot="button">Resend verification email</button>
		</ConfirmableForm>
	{/if}

	{#if notificationsSupported}
		<h3>Push Notifications</h3>
		<p>
			Notifications make it easier to keep up to date. You'll get a notification when something happens that you might want to know about.
			You can turn them off any time from your profile. If they are disabled, you'll get an email instead. However, emails are not instant.
		</p>
		{#if data.user.hasNotificationsEnabled}
			<button on:click={disableNotification}>Disable notifications</button>
		{:else}
			<button on:click={enableNotification}>Enable notifications</button>
		{/if}
	{/if}

	<h3>Strikes</h3>
	<p class="red">Number of Strikes: {data.user.strikes}</p>
	<p class="red">A strike is given when you don't show up for a course you registered for.</p>

	<h3>Statistics</h3>
	<p>Registered for {data.totalRegistrations} courses</p>
	{#each data.stats as course}
		<p>{course.name}: {course.count}</p>
	{:else}
		<p>No courses registered</p>
	{/each}
	{#if data.registrationStats}
		<p>Average Registration time: {approximatelyFormatTime(data.registrationStats.avg)}</p>
		<p>Fastest Registration time: {approximatelyFormatTime(data.registrationStats.min)}</p>
	{/if}

	<!-- <div id="stats">
		<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
			<path in:draw={{ duration: 1000 }} fill="none" stroke="grey" d={data.svg} />
		</svg>
	</div> -->
</section>

<style>
	h1 {
		margin: 0;
		padding: 0;
		font-size: 3rem;
		font-weight: 300;
	}

	section {
		padding: 20px 4rem 6rem;
		max-width: 800px;
		margin: 0 auto;
	}

	h3 {
		margin: 2rem 0 10px 0;
		font-weight: 300;
		text-decoration: underline;
		border-top: 1px solid #9cc1cf3d;
		padding-top: 2rem;
	}

	p {
		font-weight: 300;
	}

	div#stats {
		display: flex;
		justify-content: center;
		align-items: center;
		margin: 1rem;
		width: 100%;
		height: 200px;
	}

	button {
		background: #ecfbc7;
		color: #000;
		padding: 0.5rem 1rem;
	}

	button:not(.confirm) {
		margin: 1rem 0 0;
	}

	svg {
		width: 100%;
		height: 100%;
	}

	.red {
		color: #ecfbc7;
	}
</style>
