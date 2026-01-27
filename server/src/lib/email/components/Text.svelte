<script>
	import { styleToString } from '../utils';

	/**
	 * @type {{
	 *   style?: Record<string, string | number>;
	 *   class?: string;
	 *   children?: import('svelte').Snippet;
	 *   [key: string]: any;
	 * }}
	 */
	let { style = {}, class: className, children, ...restProps } = $props();

	const styleDefault = {
		fontSize: '14px',
		lineHeight: '24px',
		margin: '16px 0',
		...style
	};
</script>

<p style={styleToString(styleDefault)} {...restProps} class={className}>
	{@render children?.()}
</p>
