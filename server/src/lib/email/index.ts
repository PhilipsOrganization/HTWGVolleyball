
import { Resend } from 'resend';
import type { ComponentType, SvelteComponent } from 'svelte';
import { render } from 'svelte-email';
import { env } from '$env/dynamic/private';
import { building } from '$app/environment';
import type { User } from '$lib/db/entities';


let resend: Resend;
if (!building) {
    resend = new Resend(env.RESEND_API_KEY);
}

export async function sendEmail<T extends Record<string, any>>(component: ComponentType<SvelteComponent<T, any, any>>, config: { user: User, subject: string, props: T }) {
    console.log('Sending email to', config.user.email);
    const html = render({ template: component, props: config.props });
    const response = await resend.emails.send({ from: 'VolleyballHTWG@volleyball.oesterlin.dev', to: config.user.email, subject: config.subject, html });
    console.log(response);
}
