<script>
	import { styleToString } from '../utils';

	/**
	 * @type {{
	 *   style?: Record<string, string | number>;
	 *   class?: string;
	 *   target?: string;
	 *   href?: string;
	 *   children?: import('svelte').Snippet;
	 *   [key: string]: any;
	 * }}
	 */
	let { style = {}, class: className, target = '_blank', href = '', children, ...restProps } = $props();

	const styleDefault = {
		color: '#067df7',
		textDecoration: 'none',
		...style
	};
</script>

<a {...restProps} {href} {target} style={styleToString(styleDefault)} class={className}>
	{@render children?.()}
</a>
