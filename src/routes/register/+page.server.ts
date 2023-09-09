import { User } from "$lib/db/entities/user";
import { Role } from "$lib/db/role";
import { error, type Actions, redirect } from "@sveltejs/kit";

export const actions = {
    register: async ({ locals, request, cookies }) => {
        const form = await request.formData()

        const username = form.get('username') as string | undefined;
        const password = form.get('password') as string | undefined;
        const email = form.get('email') as string | undefined;

        if (!username || !password || !email) {
            throw error(400, 'invalid data');
        }

        const user = await locals.em.findOne(User, { $or: [{ username }, { email }] });
        if (user) {
            throw error(400, 'invalid data');
        }

        const newUser = new User(username, email, password);

        const isFirstUser = (await locals.em.count(User)) === 0;
        if (isFirstUser) {
            newUser.role = Role.ADMIN;
        }

        const sessionToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
        newUser.sessionToken = sessionToken;
        cookies.set('user', newUser.sessionToken, { path: "/" });

        await locals.em.persistAndFlush(newUser);
        throw redirect(307, '/courses'); // 307 is a temporary redirect, 301 is permanent
    },
} satisfies Actions;
