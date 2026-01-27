<script>
	/**
	 * @type {{
	 *   children?: import('svelte').Snippet;
	 *   [key: string]: any;
	 * }}
	 */
	let { children, ...restProps } = $props();
</script>

<head {...restProps}>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	{@render children?.()}
</head>
