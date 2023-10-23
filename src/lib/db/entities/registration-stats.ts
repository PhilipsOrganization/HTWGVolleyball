import { Entity, Property, wrap } from '@mikro-orm/core';
import type { EntityManager } from '@mikro-orm/sqlite';
import { CourseSpot } from '.';

@Entity({
	expression: (em: EntityManager) => {
		const timeDiff = "abs(strftime('%s', spot.created_at) - strftime('%s', c.publish_on))";
		return (
			em
				.createQueryBuilder(CourseSpot, 'spot')
				// find time between course publishOn and date of registration
				.select([`avg(${timeDiff}) as average_time`, `min(${timeDiff}) as min_time`, 'u.id as user_id'])
				.join('spot.user', 'u')
				.leftJoin('spot.course', 'c')
				.groupBy(['u.id'])
		);
	}
})
export class RegistrationStats {
	@Property()
	public averageTime!: number;

	@Property()
	public minTime!: number;

	@Property()
	public userId!: number;

	public toJSON() {
		return wrap<RegistrationStats>(this).toObject();
	}
}
