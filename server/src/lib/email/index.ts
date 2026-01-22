import { Resend } from 'resend';
import type { Component, ComponentProps, SvelteComponent } from 'svelte';
import { convert } from 'html-to-text';
import { render } from 'svelte/server';
import { env } from '$env/dynamic/private';
import { building } from '$app/environment';
import type { Account } from '$lib/db/schema.js';

let resend: Resend;
if (!building) {
	resend = new Resend(env.RESEND_API_KEY);
}

const renderAsPlainText = (markup: string) => {
	return convert(markup, {
		selectors: [
			{ selector: 'img', format: 'skip' },
			{ selector: '#__svelte-email-preview', format: 'skip' }
		]
	});
};

export const renderEmail = async <
	Comp extends SvelteComponent<any> | Component<any>,
	Props extends ComponentProps<Comp> = ComponentProps<Comp>
>(
	component: Comp,
	props?: Props
) => {
	const rendered = render(component as any, { props });

	const doctype =
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';

	const html = `${doctype}${rendered.body}`;

	const text = renderAsPlainText(rendered.body);

	return {
		html,
		text
	};
};

export async function sendEmail<T extends Record<string, any>>(
	component: Component<T> | SvelteComponent<T>,
	config: { user: Account; subject: string; props: T }
) {
	console.log('Sending email to', config.user.email);
	try {
		const { html, text } = await renderEmail(component, config.props);
		await resend.emails.send({
			from: 'VolleyballHTWG@volleyball.oesterlin.dev',
			to: config.user.email,
			subject: config.subject,
			html,
			text
		});
	} catch (error) {
		console.log('Error sending email');
		console.error(error);
	}
}
