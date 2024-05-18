
import { accounts } from '$lib/db/schema';
import { error } from '@sveltejs/kit';
import { eq } from 'drizzle-orm';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals, url }) => {
    const token = url.searchParams.get('token');
    if (!token) {
        error(400, 'No token provided');
    }

    const [user] = await locals.db
        .select()
        .from(accounts)
        .where(eq(accounts.emailVerificationToken, token))
        .limit(1);

    if (!user) {
        error(400, 'Invalid token');
    }

    await locals.db
        .update(accounts)
        .set({ emailVerified: true, emailVerificationToken: undefined })
        .where(eq(accounts.id, user.id));
};
