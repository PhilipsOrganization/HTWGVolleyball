<script>
	/**
	 * @type {{
	 *   lang?: string;
	 *   children?: import('svelte').Snippet;
	 *   [key: string]: any;
	 * }}
	 */
	let { lang = 'en', children, ...restProps } = $props();
</script>

<html {...restProps} id="__svelte-email" {lang}>
	{@render children?.()}
</html>
