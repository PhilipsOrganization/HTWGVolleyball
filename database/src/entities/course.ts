import { Entity, Index, PrimaryKey, Property, Formula, ManyToMany, Cascade, Collection, wrap } from "@mikro-orm/core";
import { isPast } from "date-fns";
import { Role } from "../role";
import { User, CourseSpot } from "./course-spot";

@Entity({ tableName: 'courses' })
@Index({ properties: ['name', 'date'], options: { unique: true } })
export class Course {
	@PrimaryKey({ type: 'number' })
	public id!: number;

	@Property({ type: 'string' })
	public name!: string;

	@Property({ type: 'date', length: 3 })
	public date!: Date;

	@Property({ type: 'datetime', length: 3 })
	public publishOn!: Date;

	// formula to check if the course should be published: publish in the past and date in the future but not more than 1 day ago
	@Formula("(publish_on <= NOW() AND date >= (NOW() - INTERVAL '1 day'))", { type: 'boolean' })
	public shouldPublish = false;

	@Property({ type: 'number' })
	public maxParticipants!: number;

	@Property({ type: 'string' })
	public location!: string;

	@Property({ type: 'string' })
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

	@Property({ persist: false, type: 'boolean' })
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