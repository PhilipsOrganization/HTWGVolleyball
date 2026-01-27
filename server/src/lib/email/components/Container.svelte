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

	const styles = { maxWidth: '37.5em', ...style };
	const inlineStyle = styleToString(styles);
</script>

<div>
	{@html `<!--[if mso | IE]>
          <table role="presentation" width="100%" align="center" style="${inlineStyle}" class="${className}"><tr><td></td><td style="width:37.5em;background:#ffffff">
        <![endif]-->`}
</div>
<div {...restProps} style={inlineStyle} class={className}>
	{@render children?.()}
</div>
<div>
	{@html `<!--[if mso | IE]>
          </td><td></td></tr></table>
          <![endif]-->`}
</div>
