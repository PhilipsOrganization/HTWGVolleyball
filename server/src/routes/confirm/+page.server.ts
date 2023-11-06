
import { error } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { User } from '$lib/db/entities';

export const load: PageServerLoad = async ({ locals, url }) => {
    const token = url.searchParams.get('token');
    if (!token) {
        throw error(400, 'No token provided');
    }

    const user = await locals.em.findOne(User, { emailVerificationToken: token });
    if (!user) {
        throw error(400, 'Invalid token');
    }

    user.emailVerified = true;
    user.emailVerificationToken = undefined;
    await locals.em.persistAndFlush(user);
};
