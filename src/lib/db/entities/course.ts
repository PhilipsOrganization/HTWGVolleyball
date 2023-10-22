import { Collection, Entity, ManyToMany, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import { User } from './user';
import { DateType } from '../date-type';
import { CourseSpot } from './course-spot';
import { Role } from '../role';

@Entity()
export class Course {
	@PrimaryKey()
	public id!: number;

	@Property()
	public name!: string;

	@Property({ type: DateType, length: 3 })
	public date!: Date;

	@Property({ type: 'date' })
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

	@Property({ type: 'date' })
	public createdAt = new Date();

	@Property({ type: 'date', onUpdate: () => new Date() })
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
