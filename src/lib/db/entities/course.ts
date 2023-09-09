import { Entity, PrimaryKey, Property, wrap } from '@mikro-orm/core';

@Entity()
export class Course {

    @PrimaryKey()
    public id!: number;

    @Property()
    public title!: string;

    @Property()
    public createdAt = new Date();

    @Property({ onUpdate: () => new Date() })
    public updatedAt = new Date();

    public toJSON() {
        return wrap<Course>(this).toObject();
    }
}