import { Entity, Property, wrap } from "@mikro-orm/core";
import type { EntityManager } from "@mikro-orm/sqlite";
import { Course } from "./course";

@Entity({
    expression: (em: EntityManager) => {
        return em.createQueryBuilder(Course, 'b')
            .select(['b.name as course_name', 'count(*) as count', 'u.id as user_id'])
            .join('b.users', 'u')
            .groupBy('b.name');
    },
})
export class UserStats {
    @Property()
    public courseName!: string;

    @Property()
    public count!: number;

    @Property()
    public userId!: number;

    public toJSON() {
        return wrap<UserStats>(this).toObject();
    }
}