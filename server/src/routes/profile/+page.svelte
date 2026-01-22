<script lang="ts">
	import ConfirmableForm from '$lib/components/confirmable-form.svelte';
	import { approximatelyFormatTime } from '$lib/helpers/date';
	import { onMount } from 'svelte';

	let { data = $bindable() } = $props();
	let notificationsSupported = $state(false);
	let loading = $state(false);

	onMount(() => {
		notificationsSupported = 'serviceWorker' in navigator && 'PushManager' in window;
	});

	async function enableNotification() {
		try {
			loading = true;
			const permission = await Notification.requestPermission();
			if (permission !== 'granted') {
				throw new Error('Notification permission denied');
			}

			const registration = await navigator.serviceWorker.getRegistration();
			if (!registration) {
				throw new Error('Service worker registration failed');
			}

			const vapidKey = import.meta.env.VITE_VAPID_PUBLIC;
			if (!vapidKey) {
				throw new Error('VAPID public key is missing');
			}

			const subscription = await registration.pushManager.subscribe({
				userVisibleOnly: true,
				applicationServerKey: urlBase64ToUint8Array(vapidKey)
			});

			const request = await fetch('/profile', {
				method: 'POST',
				body: JSON.stringify({ subscription }),
				headers: {
					'content-type': 'application/json'
				}
			});

			if (!request.ok) {
				throw new Error(await request.text() || 'Subscription failed on server');
			}

			const globalUser = await request.json();
			data = { ...data, globalUser };
		} catch (e) {
			console.error('Failed to enable notifications:', e);
			alert(e instanceof Error ? e.message : 'Failed to enable notifications');
		} finally {
			loading = false;
		}
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
		try {
			loading = true;
			const request = await fetch('/profile', {
				method: 'DELETE'
			});

			if (!request.ok) {
				throw new Error('Failed to disable notifications');
			}

			const globalUser = await request.json();
			data = { ...data, globalUser };
		} catch (e) {
			console.error('Failed to disable notifications:', e);
			alert(e instanceof Error ? e.message : 'Failed to disable notifications');
		} finally {
			loading = false;
		}
	}
</script>

<section>
	<div class="profile-header">
		<h1>Profile</h1>
		<div class="user-badge">{data.globalUser.username}</div>
	</div>

	<div class="grid">
		<div class="card email-card" class:unverified={!data.globalUser.emailVerified}>
			<div class="card-icon">✉</div>
			<div class="card-content">
				<h3>Email Status</h3>
				{#if data.globalUser.emailVerified}
					<p class="status-msg success">Email verified and active</p>
				{:else}
					<p class="status-msg warning">Email not verified</p>
					<ConfirmableForm message="Do you really want to resend the verification email?">
						{#snippet confirm()}
												<form action="?/reverify" method="post" >
								<button class="action-btn outline" type="submit">Resend verification email</button>
							</form>
											{/snippet}
						{#snippet button()}
												<button  class="action-btn outline" type="button">Resend verification email</button>
											{/snippet}
					</ConfirmableForm>
				{/if}
			</div>
		</div>

		{#if notificationsSupported}
			<div class="card notification-card" class:enabled={data.globalUser.hasNotificationsEnabled}>
				<div class="card-icon">🔔</div>
				<div class="card-content">
					<h3>Push Notifications</h3>
					<p class="description">
						Receive instant updates about course openings and spot availability.
					</p>
					<div class="toggle-area">
						{#if data.globalUser.hasNotificationsEnabled}
							<button 
								class="action-btn enabled" 
								onclick={disableNotification} 
								disabled={loading}
								type="button"
							>
								{loading ? 'Processing...' : 'Disable Notifications'}
							</button>
						{:else}
							<button 
								class="action-btn accent" 
								onclick={enableNotification} 
								disabled={loading}
								type="button"
							>
								{loading ? 'Processing...' : 'Enable Notifications'}
							</button>
						{/if}
					</div>
				</div>
			</div>
		{/if}

		<div class="card strike-card" class:has-strikes={data.globalUser.strikes > 0}>
			<div class="card-icon">⚠️</div>
			<div class="card-content">
				<h3>Strikes</h3>
				<div class="strike-count">
					<span class="count">{data.globalUser.strikes}</span>
					<span class="label">Strikes received</span>
				</div>
				<p class="description small">
					Strikes are given for no-shows or late cancellations. Too many strikes may result in registration restrictions.
				</p>
			</div>
		</div>

		<div class="card stats-card">
			<div class="card-icon">📊</div>
			<div class="card-content">
				<h3>Statistics</h3>
				<div class="stats-overview">
					<div class="stat-item">
						<span class="val">{data.totalRegistrations}</span>
						<span class="lab">Total Courses</span>
					</div>
					{#if data.registrationStats}
						<div class="stat-item">
							<span class="val">{approximatelyFormatTime(data.registrationStats.avg)}</span>
							<span class="lab">Avg Signup Time</span>
						</div>
					{/if}
				</div>
				
				<div class="course-list">
					<h4>Recent Activity</h4>
					{#each data.stats as course}
						<div class="course-stat">
							<span class="course-name">{course.name}</span>
							<span class="course-count">{course.count}x</span>
						</div>
					{:else}
						<p class="empty">No courses registered yet</p>
					{/each}
				</div>
			</div>
		</div>
	</div>
</section>

<style>
	* {
		box-sizing: border-box;
	}

	section {
		padding: 2rem 1.5rem 6rem;
		max-width: 1000px;
		margin: 0 auto;
	}

	.profile-header {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		margin-bottom: 2.5rem;
		border-bottom: 1px solid #333;
		padding-bottom: 1rem;
	}

	h1 {
		margin: 0;
		font-size: 2.5rem;
		font-weight: 200;
		color: #e0e0e0;
	}

	.user-badge {
		background: #9cc1cf20;
		color: #9cc1cf;
		padding: 0.4rem 1rem;
		border-radius: 100px;
		font-size: 0.9rem;
		font-weight: 500;
	}

	.grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
		gap: 1.5rem;
	}

	.card {
		background: #1a1a1a;
		border: 1px solid #2a2a2a;
		border-radius: 16px;
		padding: 1.5rem;
		display: flex;
		gap: 1.25rem;
		transition: transform 0.2s ease, border-color 0.2s ease;
	}

	.card:hover {
		border-color: #3a3a3a;
	}

	.card-icon {
		font-size: 1.5rem;
		opacity: 0.8;
		background: #252525;
		width: 3rem;
		height: 3rem;
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 12px;
		flex-shrink: 0;
	}

	.card-content {
		flex: 1;
		min-width: 0;
	}

	h3 {
		margin: 0 0 0.5rem 0;
		font-size: 1.1rem;
		font-weight: 400;
		color: #e0e0e0;
	}

	h4 {
		margin: 1.5rem 0 0.75rem 0;
		font-size: 0.85rem;
		text-transform: uppercase;
		letter-spacing: 0.5px;
		color: #666;
	}

	p {
		margin: 0;
		font-weight: 300;
		line-height: 1.5;
		color: #aaa;
	}

	.description {
		font-size: 0.9rem;
	}

	.description.small {
		font-size: 0.8rem;
		margin-top: 1rem;
		color: #666;
	}

	.status-msg {
		font-size: 0.9rem;
		margin-bottom: 1rem;
	}

	.status-msg.success { color: #9cc1cf; }
	.status-msg.warning { color: #eb714f; }

	.action-btn {
		padding: 0.6rem 1.25rem;
		border-radius: 8px;
		font-size: 0.9rem;
		font-weight: 500;
		transition: all 0.15s ease;
		width: 100%;
		text-align: center;
		cursor: pointer;
		border: none;
		display: block;
	}

	.action-btn:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.action-btn.accent {
		background: #9cc1cf;
		color: #000;
	}

	.action-btn.accent:hover:not(:disabled) { background: #b0d1dc; }

	.action-btn.outline {
		background: transparent;
		border: 1px solid #333;
		color: #aaa;
	}

	.action-btn.outline:hover:not(:disabled) {
		border-color: #9cc1cf;
		color: #9cc1cf;
	}

	.action-btn.enabled {
		background: #252525;
		color: #888;
		border: 1px solid #333;
	}

	.action-btn.enabled:hover:not(:disabled) {
		border-color: #eb714f;
		color: #eb714f;
	}

	.strike-count {
		display: flex;
		align-items: baseline;
		gap: 0.5rem;
		margin: 0.5rem 0;
	}

	.strike-count .count {
		font-size: 2.5rem;
		font-weight: 200;
		color: #eb714f;
	}

	.strike-count .label {
		color: #666;
		font-size: 0.9rem;
	}

	.stats-overview {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1rem;
		margin-bottom: 1rem;
	}

	.stat-item {
		display: flex;
		flex-direction: column;
	}

	.stat-item .val {
		font-size: 1.5rem;
		color: #9cc1cf;
	}

	.stat-item .lab {
		font-size: 0.75rem;
		color: #666;
		text-transform: uppercase;
	}

	.course-list {
		background: #151515;
		border-radius: 10px;
		padding: 1rem;
	}

	.course-stat {
		display: flex;
		justify-content: space-between;
		padding: 0.4rem 0;
		font-size: 0.9rem;
		border-bottom: 1px solid #252525;
	}

	.course-stat:last-child {
		border-bottom: none;
	}

	.course-name { color: #888; }
	.course-count { color: #9cc1cf; font-weight: 500; }

	.empty {
		font-size: 0.85rem;
		color: #555;
		text-align: center;
		padding: 1rem 0;
	}

	@media (max-width: 600px) {
		section { padding: 1.5rem 1rem 5rem; }
		h1 { font-size: 2rem; }
		.profile-header { margin-bottom: 1.5rem; }
		.grid { grid-template-columns: 1fr; }
		.card { padding: 1.25rem; }
	}
</style>
