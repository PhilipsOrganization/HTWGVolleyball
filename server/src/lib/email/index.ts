import { Resend } from 'resend';
import type { ComponentType, SvelteComponent } from 'svelte';
import { render } from 'svelte-email';
import { env } from '$env/dynamic/private';
import { building } from '$app/environment';
import type { Account } from '$lib/db/schema.js';

let resend: Resend;
if (!building) {
	resend = new Resend(env.RESEND_API_KEY);
}

export async function sendEmail<T extends Record<string, any>>(
	component: ComponentType<SvelteComponent<T, any, any>>,
	config: { user: Account; subject: string; props: T }
) {
	console.log('Sending email to', config.user.email);
	try {
		const html = render({ template: component, props: config.props });
		await resend.emails.send({ from: 'VolleyballHTWG@volleyball.oesterlin.dev', to: config.user.email, subject: config.subject, html });
	} catch (error) {
		console.log('Error sending email');
		console.error(error);
	}
}
