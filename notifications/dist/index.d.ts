import { User } from '@lib/database';

declare function setEnv(env: any): void;
declare function sendNotification(user: User, payload: string): Promise<void>;

export { sendNotification, setEnv };
