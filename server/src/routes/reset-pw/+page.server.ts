import { User } from '$lib/db/entities/course-spot.js';
import { sendEmail } from '$lib/email/index.js';
import ResetPassword from '$lib/email/templates/reset-password.svelte';
import { type Actions, fail, redirect } from '@sveltejs/kit';

export const actions = {
    "reset-pw": async ({ locals, request }) => {
        const form = await request.formData();
        const userNameOrEmail = form.get("username") as string | undefined;
        if (!userNameOrEmail) {
            return fail(400, { error: "Missing credentials" });
        }

        const user = await locals.em.findOne(User, { $or: [{ username: userNameOrEmail }, { email: userNameOrEmail }] });
        if (!user) {
            return fail(400, { error: 'User not found' });
        }

        const token = encodeURIComponent(crypto.getRandomValues(new Uint8Array(32)).join(""))

        locals.em.assign(user, {
            resetToken: token,
            resetTokenExpires: new Date(Date.now() + 1000 * 60 * 60 * 24)
        });

        await locals.em.persistAndFlush(user);

        await sendEmail(ResetPassword, { user, subject: "Reset Password", props: { user, token } });
        throw redirect(303, "/login");
    }
} satisfies Actions;