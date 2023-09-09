import { Collection, Entity, ManyToMany, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import { User } from './user';

@Entity()
export class Course {
    @PrimaryKey()
    public id!: number;

    @Property()
    public title!: string;

    @Property({ type: 'date' })
    public createdAt = new Date();

    @ManyToMany(() => User, user => user.courses, { owner: true, hidden: true, eager: true })
    public users = new Collection<User>(this);

    @Property({ type: 'date', onUpdate: () => new Date() })
    public updatedAt = new Date();

    public toJSON() {
        const obj = wrap<Course>(this).toObject();
        const signupCount = this.users.count();
        return { ...obj, signupCount };
    }
}