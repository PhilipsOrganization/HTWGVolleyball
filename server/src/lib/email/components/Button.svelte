<script>
	import { pxToPt, styleToString } from '../utils';

	/**
	 * @type {{
	 *   href?: string;
	 *   style?: Record<string, string | number>;
	 *   class?: string;
	 *   pX?: number;
	 *   pY?: number;
	 *   target?: string;
	 *   children?: import('svelte').Snippet;
	 *   [key: string]: any;
	 * }}
	 */
	let { href = '', style = {}, class: className, pX = 0, pY = 0, target = '_blank', children, ...restProps } = $props();

	const y = pY * 2;
	const textRaise = pxToPt(y.toString());

	/**
	 * @param {Record<string, string | number> & { pY?: number; pX?: number }} [style]
	 */
	const buttonStyle = (style) => {
		const paddingY = style?.pY || 0;
		const paddingX = style?.pX || 0;

		return {
			...style,
			lineHeight: '100%',
			textDecoration: 'none',
			display: 'inline-block',
			maxWidth: '100%',
			padding: `${paddingY}px ${paddingX}px`
		};
	};

	/**
	 * @param {Record<string, string | number | null> & { pY?: number; pX?: number }} [style]
	 */
	const buttonTextStyle = (style) => {
		const paddingY = style?.pY || 0;

		return {
			...style,
			maxWidth: '100%',
			display: 'inline-block',
			lineHeight: '120%',
			textDecoration: 'none',
			textTransform: 'none',
			msoPaddingAlt: '0px',
			msoTextRaise: pxToPt(paddingY.toString())
		};
	};
</script>

<a {...restProps} {href} {target} style={styleToString(buttonStyle({ ...style, pX, pY }))} class={className}>
	<span>
		{@html `<!--[if mso]><i style="letter-spacing: ${pX}px;mso-font-width:-100%;mso-text-raise:${textRaise}" hidden>&nbsp;</i><![endif]-->`}
	</span>
	<span style={styleToString(buttonTextStyle({ ...style, pX, pY }))}>
		{@render children?.()}
	</span>
	<span>
		{@html `<!--[if mso]><i style="letter-spacing: ${pX}px;mso-font-width:-100%" hidden>&nbsp;</i><![endif]-->`}
	</span>
</a>
