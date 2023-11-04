import { Entity, Property, wrap } from '@mikro-orm/core';
import type { EntityManager } from '@mikro-orm/postgresql';
import { Course } from './course';

@Entity({
	expression: (em: EntityManager) => {
		return em
			.createQueryBuilder(Course, 'b')
			.select(['b.name as course_name', 'count(*) as count', 'u.id as user_id'])
			.join('b.users', 'u')
			.groupBy(['b.name', 'u.id']);
	}
})
export class UserStats {
	@Property({ type: 'string' })
	public courseName!: string;

	@Property({ type: 'number' })
	public count!: number;

	@Property({ type: 'number' })
	public userId!: number;

	public toJSON() {
		return wrap<UserStats>(this).toObject();
	}
}
