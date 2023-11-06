import { redirect, type Actions, fail } from "@sveltejs/kit";
import type { PageServerLoad } from "../$types";
import { User } from "$lib/db/entities";

export const load: PageServerLoad = async ({ locals, url }) => {
    const token = url.searchParams.get("token");
    const userId = url.searchParams.get("user");

    if (!token || userId === null) {
        throw redirect(303, "/login");
    }

    const user = await locals.em.findOne(User, { id: parseInt(userId), resetToken: token });

    if (!user || !user.resetTokenExpires || user.resetTokenExpires < new Date()) {
        throw redirect(303, "/login");
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
            throw redirect(303, "/login");
        }

        const user = await locals.em.findOne(User, { id: parseInt(userId), resetToken: token });

        if (!user) {
            throw fail(400, { error: "User not found" });
        }

        if (!user.resetTokenExpires || user.resetTokenExpires < new Date()) {
            user.resetToken = undefined;
            user.resetTokenExpires = undefined;
            await locals.em.persistAndFlush(user);

            return fail(400, { error: "Token expired" });
        }

        if (password !== passwordConfirm) {
            return fail(400, { token, userId, error: "Passwords do not match" });
        }

        const weakPassword = password.length < 8;
		if (weakPassword) {
			return fail(400, { token, userId, error: "Password too weak" });
		}

        user.password = await User.hashPassword(password);
        user.resetToken = undefined;
        user.resetTokenExpires = undefined;

        await locals.em.persistAndFlush(user);

        throw redirect(303, "/login");
    },
} satisfies Actions;