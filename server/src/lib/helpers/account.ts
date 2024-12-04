import { Role } from '$lib/db/role';
import { accounts, type Account, type DB } from '$lib/db/schema.js';
import { compare, hash } from 'bcrypt';
import { eq, or } from 'drizzle-orm';

export async function findOneByNameOrEmail(usernameOrEmail: string, db: DB): Promise<Account | undefined> {
	const [user] = await db
		.select()
		.from(accounts)
		.where(or(eq(accounts.username, usernameOrEmail), eq(accounts.email, usernameOrEmail.toLowerCase())))
		.limit(1);

	return user;
}

export function hashPassword(password: string) {
	return hash(password, 10);
}

export async function isPasswordCorrect(user: Account, password: string) {
	if (!password || !user.password) {
		return false;
	}

	return compare(password, user.password);
}

export function generateRandomToken() {
	return encodeURIComponent(crypto.getRandomValues(new Uint8Array(32)).join(''));
}

export function serializeUser(user: Account) {
	return {
		id: user.id,
		username: user.username,
		email: user.email,
		strikes: user.strikes,
		role: user.role,
		emailVerified: user.emailVerified,
		createdAt: new Date(user.createdAt),
		lastLogin: new Date(user.lastLogin ?? user.createdAt),
		notes: user.notes,
		hasNotificationsEnabled: user.subscriptionAuth !== null && user.subscriptionAuth !== undefined,
		canceledAt: user.canceledAt
	};
}

export type SanitizedAccount = Pick<Account, 'id' | 'username' | 'role' | 'canceledAt'>;

export function sanitizeUser(account: Account): SanitizedAccount {
	const user = {
		id: account.id,
		username: account.username,
		role: account.role,
		canceledAt: account.canceledAt // used for courses
	};

	return user;
}

export async function makeNewUser({ username, password, email }: { username: string; password?: string; email: string }) {
	const newUser = {
		username,
		password: password ? await hashPassword(password) : null,
		email,
		role: Role.USER,
		createdAt: new Date().toISOString(),
		lastLogin: new Date().toISOString(),
		sessionToken: generateRandomToken(),
		emailVerificationToken: generateRandomToken(),
		emailVerified: false,
		notes: '',
		strikes: 0,
		subscriptionEndpoint: null,
		subscriptionP256Dh: null,
		subscriptionAuth: null,
		subscriptionExpirationTime: null,
		resetToken: null,
		resetTokenExpires: null
	} satisfies Omit<Account, 'id'>;

	return newUser;
}
