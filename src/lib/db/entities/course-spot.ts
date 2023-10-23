import { Collection, Embedded, Entity, ManyToMany, ManyToOne, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import crypto from 'crypto';
import { Role } from '../role';
import { Subscription } from './subscription';

@Entity({ tableName: 'users' })
export class User {
	@PrimaryKey()
	public id!: number;

	@Property()
	public username: string;

	@Property({ hidden: true })
	public email: string;

	@Property({ hidden: true })
	public password: string;

	@Property({ hidden: true, nullable: true })
	public sessionToken?: string;

	@Property()
	public role = Role.USER;

	@Property()
	public strikes: number;

	@Property({ nullable: true })
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

	@Property({ persist: false })
	public get hasNotificationsEnabled() {
		return this.subscription !== undefined;
	}
}

@Entity({ tableName: 'courses' })
export class Course {
	@PrimaryKey()
	public id!: number;

	@Property()
	public name!: string;

	@Property({ type: 'date', length: 3 })
	public date!: Date;

	@Property({ type: 'datetime', length: 3 })
	public publishOn!: Date;

	@Property()
	public maxParticipants!: number;

	@Property()
	public location!: string;

	@Property()
	public time!: string;

	@ManyToMany(() => User, (user) => user.courses, {
		owner: true,
		hidden: true,
		eager: true,
		pivotEntity: () => CourseSpot
	})
	public users = new Collection<User>(this);

	@Property({ type: 'datetime' })
	public createdAt = new Date();

	@Property({ type: 'datetime', onUpdate: () => new Date() })
	public updatedAt = new Date();

	public toJSON(user?: User) {
		const obj = wrap<Course>(this).toObject();
		const signupCount = this.users.count();

		const result = {
			...obj,
			signupCount,
			isEnrolled: false,
			spot: -1,
			participants: [] as ReturnType<User['toJSON']>[]
		};

		if (user) {
			result.isEnrolled = this.users.contains(user);

			if (result.isEnrolled) {
				result.spot = this.users.getItems().indexOf(user);
			}

			if (user.role !== Role.USER) {
				result.participants = this.users.getItems().map((u) => u.toJSON());
			}
		}

		return result;
	}
}

export type CourseDTO = ReturnType<Course['toJSON']>;

@Entity({ tableName: 'course_spots' })
export class CourseSpot {
	@ManyToOne(() => User, { primary: true })
	public user!: User;

	@ManyToOne(() => Course, { primary: true })
	public course!: Course;

	@Property({ type: 'datetime', defaultRaw: 'NOW()' })
	createdAt = new Date();
}
