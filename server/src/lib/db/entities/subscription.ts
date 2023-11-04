import { Embeddable, Property } from '@mikro-orm/core';

export interface SubscriptionDTO {
	keys: {
		p256dh: string;
		auth: string;
	};
	endpoint: string;
	expirationTime?: string | null | undefined;
}

@Embeddable()
export class Subscription {
	public constructor(subscription: SubscriptionDTO) {
		this.endpoint = subscription.endpoint;
		this.expirationTime = subscription.expirationTime;
		this.p256dh = subscription.keys.p256dh;
		this.auth = subscription.keys.auth;
	}

	@Property({ nullable: true })
	public endpoint!: string;

	@Property({ nullable: true })
	public expirationTime?: string | undefined | null;

	@Property({ nullable: true })
	public p256dh!: string;

	@Property({ nullable: true })
	public auth!: string;

	public toJSON() {
		return {
			endpoint: this.endpoint,
			expirationTime: this.expirationTime,
			keys: {
				p256dh: this.p256dh,
				auth: this.auth
			}
		};
	}
}
