import { accounts } from '$lib/db/schema.js';
import { sendEmail } from '$lib/email/index.js';
import ResetPassword from '$lib/email/templates/reset-password.svelte';
import { findOneByNameOrEmail } from '$lib/helpers/account.js';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { eq } from 'drizzle-orm';

export const actions = {
    "reset-pw": async ({ locals, request }) => {
        const form = await request.formData();
        const userNameOrEmail = form.get("username") as string | undefined;
        if (!userNameOrEmail) {
            return fail(400, { error: "Missing credentials" });
        }

        const db = locals.db;
        const user = await findOneByNameOrEmail(userNameOrEmail, db);
        if (!user) {
            return fail(400, { error: 'User not found' });
        }

        const token = encodeURIComponent(crypto.getRandomValues(new Uint8Array(32)).join(""))

        db.update(accounts)
            .set({
                resetToken: token,
                resetTokenExpires: new Date(Date.now() + 1000 * 60 * 60 * 24).toISOString()
            })
            .where(eq(accounts.id, user.id));

        await sendEmail(ResetPassword, { user, subject: "Reset Password", props: { user, token } });
        redirect(303, "/login");
    }
} satisfies Actions;