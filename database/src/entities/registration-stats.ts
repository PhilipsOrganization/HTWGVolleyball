import { Entity, Property, wrap } from '@mikro-orm/core';
import type { EntityManager } from '@mikro-orm/postgresql';
import { CourseSpot } from './course-spot';

@Entity({
	expression: (em: EntityManager) => {
		const timeDiff = "extract(epoch from spot.created_at) - extract(epoch from c.publish_on)";
		return (
			em
				.createQueryBuilder(CourseSpot, 'spot')
				// find time between course publishOn and date of registration
				.select([`avg(${timeDiff}) as average_time`, `min(${timeDiff}) as min_time`, 'u.id as user_id'])
				.join('spot.user', 'u')
				.leftJoin('spot.course', 'c')
				.groupBy('u.id')
		);
	}
})
export class RegistrationStats {
	@Property({ type: "number" })
	public averageTime!: number;

	@Property({ type: "number" })
	public minTime!: number;

	@Property({ type: "number" })
	public userId!: number;

	public toJSON() {
		return wrap<RegistrationStats>(this).toObject();
	}
}
