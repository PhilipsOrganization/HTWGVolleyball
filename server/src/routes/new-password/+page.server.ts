import { accounts } from "$lib/db/schema.js";
import { hashPassword } from "$lib/helpers/account.js";
import { error, fail, redirect, type Actions } from "@sveltejs/kit";
import { and, eq } from "drizzle-orm";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ locals, url }) => {
    const token = url.searchParams.get("token");
    const userId = url.searchParams.get("user");

    if (!token || userId === null) {
        redirect(303, "/login");
    }

    const [user] = await locals.db.select().from(accounts).where(and(
        eq(accounts.id, parseInt(userId)),
        eq(accounts.resetToken, token)
    )).limit(1);

    if (!user || !user.resetTokenExpires || new Date(user.resetTokenExpires) < new Date()) {
        redirect(303, "/login");
    }

    return { error: false };
};

export const actions = {
    default: async ({ locals, request, cookies }) => {
        cookies.delete('user', { path: '/' });
        const body = await request.formData();

        const password = body.get("password") as string;
        const passwordConfirm = body.get("password2") as string;

        const userId = body.get("user") as string;
        const token = body.get("token") as string;

        if (!userId || !token) {
            redirect(303, "/login");
        }

        const [user] = await locals.db.select().from(accounts).where(and(
            eq(accounts.id, parseInt(userId)),
            eq(accounts.resetToken, token)
        )).limit(1);

        if (!user) {
            error(400, new Error("User not found"));
        }

        if (!user.resetTokenExpires) {
            error(400, new Error("Token expired"));
        }

        const expirationDate = new Date(user.resetTokenExpires as string);
        if (expirationDate < new Date()) {
            await locals.db
                .update(accounts)
                .set({ resetToken: null, resetTokenExpires: null })
                .where(eq(accounts.id, parseInt(userId)));

            return fail(400, { error: "Token expired" });
        }

        if (password !== passwordConfirm) {
            return fail(400, { token, userId, error: "Passwords do not match" });
        }

        const weakPassword = password.length < 8;
        if (weakPassword) {
            return fail(400, { token, userId, error: "Password too weak" });
        }

        const hash = await hashPassword(password);

        await locals.db
            .update(accounts)
            .set({ resetToken: null, resetTokenExpires: null, password: hash })
            .where(eq(accounts.id, parseInt(userId)));

        redirect(303, "/login");
    },
} satisfies Actions;