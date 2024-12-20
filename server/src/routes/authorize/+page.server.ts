import { env } from "$env/dynamic/private";
import { accounts, type Account } from "$lib/db/schema";
import { generateRandomToken, makeNewUser } from "$lib/helpers/account";
import { error, redirect } from "@sveltejs/kit";
import { eq } from "drizzle-orm";
import type { PageServerLoad } from "./$types";

interface UserInfo {
    id: string;
    email: string;
    verified_email: boolean;
    name: string;
    given_name: string;
    family_name: string;
    picture: string;
    locale: string;
}

async function getToken(fetchFn: typeof fetch, code: string) {
    const tokenResponse = await fetchFn('https://oauth2.googleapis.com/token', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            code,
            client_id: env.VITE_GOOGLE_CLIENT_ID,
            client_secret: env.GOOGLE_CLIENT_SECRET,
            redirect_uri: 'https://volleyball.oesterlin.dev/authorize',
            grant_type: 'authorization_code',
        }),
    });

    if (!tokenResponse.ok) {
        const data = await tokenResponse.json();
        console.error(data, tokenResponse.status);

        throw new Error('Failed to exchange authorization code for access token');
    }

    const { access_token } = await tokenResponse.json();
    return access_token;
}


async function getUserInfo(fetchFn: typeof fetch, token: string) {
    const request = await fetchFn(`https://www.googleapis.com/oauth2/v2/userinfo`, {
        headers: {
            Authorization: `Bearer ${token}`,
        },
    });

    if (!request.ok) {
        const data = await request.json();
        console.error(data);

        error(request.status, 'Failed to get google user info');
    }

    const data = await request.json();
    return data as UserInfo;
}

export const load: PageServerLoad = async ({ url, cookies, locals, fetch }) => {
    const code = url.searchParams.get('code');
    if (!code) {
        throw new Error('No token provided');
    }

    const accessToken = await getToken(fetch, decodeURIComponent(code));
    const data = await getUserInfo(fetch, accessToken);

    let [user] = await locals.db
        .select()
        .from(accounts)
        .where(eq(accounts.email, data.email))
        .limit(1);

    if (!user) {
        user = await makeNewUser({ username: data.name, email: data.email }) as Account;
        await locals.db.insert(accounts).values(user);
    }

    const sessionToken = generateRandomToken();
    await locals.db
        .update(accounts)
        .set({ lastLogin: new Date().toISOString(), sessionToken })
        .where(eq(accounts.id, user.id));

    const expirationDate = new Date(Date.now() + 1000 * 60 * 60 * 24 * 21);
	cookies.set('user', sessionToken, { path: '/', expires: expirationDate, sameSite: 'lax' });
    redirect(303, '/courses');
};

