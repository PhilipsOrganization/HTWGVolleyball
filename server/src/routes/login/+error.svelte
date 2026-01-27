<script>
	import ErrorPage from '$lib/components/error-page.svelte';
</script>

<ErrorPage title="Login Failed">
	{#snippet children()}
		<a href="/login">Try again</a>
	{/snippet}
</ErrorPage>

<style>
	a {
		font-size: 18px;
		font-weight: bold;
		color: var(--cAccent);
	}
</style>
