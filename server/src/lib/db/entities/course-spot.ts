import { Cascade, Collection, Embedded, Entity, Formula, Index, ManyToMany, ManyToOne, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import { isPast } from 'date-fns';
import { Role } from '../role';
import { Subscription } from './subscription';
import { hash, compare } from 'bcrypt';

@Entity({ tableName: 'accounts' })
@Index({ properties: ['username'], options: { unique: true } })
@Index({ properties: ['email'], options: { unique: true } })
@Index({ properties: ['sessionToken'], options: { unique: true } })
export class User {
	@PrimaryKey()
	public id!: number;

	@Property()
	public username: string;

	@Property({ default: false, type: 'boolean' })
	public emailVerified = false;

	@Property({ hidden: true, nullable: true })
	public emailVerificationToken?: string;

	@Property({ type: 'date' })
	public createdAt = new Date();

	@Property({ type: 'date', nullable: true, onUpdate: () => new Date() })
	public lastLogin = new Date();

	@Property({ hidden: true })
	public email: string;

	@Property({ hidden: true })
	public password!: string;

	@Property({ hidden: true, nullable: true })
	public sessionToken?: string;

	@Property()
	public role = Role.USER;

	@Property()
	public strikes: number;

	@Property({ nullable: true })
	public notes?: string;

	@Property({ nullable: true, hidden: true })
	public resetToken?: string;

	@Property({ nullable: true, type: 'datetime' })
	public resetTokenExpires?: Date;

	@Embedded(() => Subscription, { nullable: true })
	public subscription?: Subscription;

	@ManyToMany({ hidden: true, entity: () => Course, eager: true })
	public courses = new Collection<Course>(this);

	constructor(username: string, email: string, hash: string) {
		this.username = username;
		this.email = email;
		this.password = hash;
		this.strikes = 0;
	}

	public toJSON() {
		return wrap<User>(this).toObject();
	}

	public static hashPassword(password: string) {
		return hash(password, 10);
	}

	public async isPasswordCorrect(password: string) {
		return compare(password, this.password);
	}

	@Property({ persist: false })
	public get hasNotificationsEnabled() {
		return this.subscription !== undefined && this.subscription !== null;
	}
}

@Entity({ tableName: 'courses' })
@Index({ properties: ['name', 'date'], options: { unique: true } })
export class Course {
	@PrimaryKey()
	public id!: number;

	@Property()
	public name!: string;

	@Property({ type: 'date', length: 3 })
	public date!: Date;

	@Property({ type: 'datetime', length: 3 })
	public publishOn!: Date;

	// formula to check if the course should be published: publish in the past and date in the future but not more than 1 day ago
	@Formula("(publish_on <= NOW() AND date >= (NOW() - INTERVAL '1 day'))")
	public shouldPublish = false;

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
		cascade: [Cascade.REMOVE],
		pivotEntity: () => CourseSpot
	})
	public users = new Collection<User>(this);

	@Property({ type: 'datetime' })
	public createdAt = new Date();

	@Property({ type: 'datetime', onUpdate: () => new Date() })
	public updatedAt = new Date();

	@Property({ type: 'boolean', default: false })
	public notificationSent = false;

	@Property({ persist: false })
	public get isPast() {
		const clone = new Date(this.date.getTime());
		const [hours, minutes] = this.time.split(':').map((n) => parseInt(n));
		clone.setHours(hours, minutes, 0, 0);
		return isPast(clone);
	}

	public toJSON(user?: User) {
		const obj = wrap<Course>(this).toObject();
		const signupCount = this.users.count();

		const result = {
			...obj,
			signupCount,
			isEnrolled: false,
			spot: -1,
			isOnWaitlist: false,
			participants: [] as ReturnType<User['toJSON']>[]
		};

		if (user) {
			result.isEnrolled = this.users.contains(user);

			if (result.isEnrolled) {
				result.spot = this.users.getItems().indexOf(user);
				result.isOnWaitlist = result.spot >= this.maxParticipants;
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
