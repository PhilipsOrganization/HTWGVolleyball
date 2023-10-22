<script lang="ts">
	import ErrorPage from '$lib/components/error-page.svelte';
</script>

<ErrorPage title="Registration Failed">
	<a href="/register">Try again</a>
</ErrorPage>

<style>
	a {
		font-size: 18px;
		font-weight: bold;
		color: var(--cAccent);
	}
</style>
