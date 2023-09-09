import { User } from "$lib/db/entities/user";
import { error, type Actions, redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "../$types";


export const load: PageServerLoad = async ({ locals }) => {
    if (locals.user) {
        throw redirect(307, '/courses');
    }
};


export const actions = {
    login: async ({ locals, request, cookies }) => {
        const form = await request.formData()

        const username = form.get('username') as string | undefined;
        const password = form.get('password') as string | undefined;

        if (!username || !password) {
            throw error(400, 'No username or password provided');
        }

        const user = await locals.em.findOne(User, { username });
        if (!user) {
            throw error(400, 'User not found');
        }

        if (!user.isPasswordCorrect(password)) {
            throw error(400, 'Incorrect password');
        }

        const sessionToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
        user.sessionToken = sessionToken;
        cookies.set('user', user.sessionToken, { path: "/" });

        await locals.em.persistAndFlush(user);
        throw redirect(307, '/courses'); // 307 is a temporary redirect, 301 is permanent
    },
} satisfies Actions;
