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

	const styleDefaultTable = {
		width: '100%',
		...style
	};

	const styleDefaultTr = {
		display: 'grid',
		gridAutoColumns: 'minmax(0, 1fr)',
		gridAutoFlow: 'column'
	};
</script>

<table
	style={styleToString(styleDefaultTable)}
	align="center"
	border={0}
	cellPadding={0}
	cellSpacing={0}
	role="presentation"
	{...restProps}
	class={className}
>
	<tbody>
		<tr style={styleToString(styleDefaultTr)}>
			{@render children?.()}
		</tr>
	</tbody>
</table>
