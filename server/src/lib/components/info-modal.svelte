<script>
	import { onNavigate } from '$app/navigation';
	import { onMount } from 'svelte';
	import { fade, scale } from 'svelte/transition';
    
	let open = $state(false);
	const id = 'info-modal';

	onMount(() => {
		if (window.localStorage.getItem(id) !== 'true') {
			open = true;
			window.localStorage.setItem(id, 'true');
		}
	});

	onNavigate(() => {
		open = false;
	});
</script>

{#if open}
	<dialog in:scale={{ duration: 200 }} out:scale={{ duration: 200 }}>
		<h1>Welcome!</h1>
		<p>This is the new HTWG Volleyball App 🥳 You can now register and login to access your courses.	Have fun!</p>
		<a href="register">Register Account</a>
	</dialog>

	<div class="background" onclick={() => (open = false)} transition:fade={{ duration: 200 }}></div>
{/if}

<style>
	dialog {
		position: fixed;
		inset: 0;
		background: rgb(193, 217, 225);
		max-width: min(80%, 450px);
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		align-items: center;
		color: rgb(19 19 19);
		border-radius: 1rem;
		z-index: 100;
		padding: 2rem;
		box-sizing: border-box;
        gap: 5vh;
	}

	div.background {
		background: rgba(0, 0, 0, 0.752);
		position: fixed;
		inset: -20px;
		z-index: 99;
		filter: blur(2px);
	}

	h1 {
		margin-top: 0;
	}

	p {
		text-align: center;
		transform: translate(0, -1rem);
		font-weight: 300;
		max-width: min(80%, 400px);
	}

	a {
		display: flex;
		justify-content: center;
		font-size: 1.2rem;
		text-decoration: underline;
	}
</style>
