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
		display: 'inline-flex',
		justifyContent: 'center',
		alignItems: 'center',
		...style
	};
</script>

<td style={styleToString(styleDefault)} role="presentation" {...restProps} class={className}>
	{@render children?.()}
</td>
