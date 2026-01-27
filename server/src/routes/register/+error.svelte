<script >
	import ErrorPage from '$lib/components/error-page.svelte';
</script>

<ErrorPage title="Registration Failed">
	{#snippet children()}
		<a href="/register">Try again</a>
	{/snippet}
</ErrorPage>

<style>
	a {
		font-size: 18px;
		font-weight: bold;
		color: var(--cAccent);
	}
</style>
