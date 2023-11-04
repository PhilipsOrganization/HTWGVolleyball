import { Collection, Embedded, Entity, Index, ManyToMany, ManyToOne, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import crypto from 'crypto';
import { Role } from '../role';
import { Subscription } from './subscription';
import { Course } from './course';

@Entity({ tableName: 'accounts' })
@Index({ properties: ['username'], options: { unique: true } })
@Index({ properties: ['email'], options: { unique: true } })
@Index({ properties: ['sessionToken'], options: { unique: true } })
export class User {
	@PrimaryKey({ type: 'number' })
	public id!: number;

	@Property({ type: 'string' })
	public username!: string;

	@Property({ type: 'string', hidden: true })
	public email!: string;

	@Property({ type: 'string', hidden: true })
	public password!: string;

	@Property({ type: 'string', hidden: true, nullable: true })
	public sessionToken?: string;

	@Property({ type: 'string' })
	public role: Role = Role.USER;

	@Property({ type: 'number' })
	public strikes!: number;

	@Property({ type: 'string', nullable: true })
	public notes?: string;

	@Embedded(() => Subscription, { nullable: true })
	public subscription?: Subscription;

	@ManyToMany({ hidden: true, entity: () => Course, eager: true })
	public courses = new Collection<Course>(this);

	constructor(username: string, email: string, password: string) {
		this.username = username;
		this.email = email;
		this.password = crypto.createHmac('sha256', password).digest('hex');
		this.strikes = 0;
	}

	public toJSON() {
		return wrap<User>(this).toObject();
	}

	public isPasswordCorrect(password: string) {
		const hash = crypto.createHmac('sha256', password).digest('hex');
		return hash === this.password;
	}

	@Property({ persist: false, type: 'boolean' })
	public get hasNotificationsEnabled() {
		return this.subscription !== undefined;
	}
}


@Entity({ tableName: 'course_spots' })
export class CourseSpot {
	@ManyToOne(() => User, { primary: true })
	public user!: User;

	@ManyToOne(() => Course, { primary: true })
	public course!: Course;

	@Property({ type: 'datetime', defaultRaw: 'NOW()' })
	createdAt = new Date();
}
