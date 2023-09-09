import { Collection, Entity, ManyToMany, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import { User } from './user';
import { DateType } from '../date-type';

@Entity()
export class Course {
    @PrimaryKey()
    public id!: number;

    @Property()
    public name!: string;

    @Property({ type: DateType, length: 3 })
    public date!: Date;

    @Property({ type: "date" })
    public publishOn!: Date;

    @Property()
    public maxParticipants!: number;

    @Property()
    public location!: string;

    @Property()
    public time!: string;

    @ManyToMany(() => User, user => user.courses, { owner: true, hidden: true, eager: true })
    public users = new Collection<User>(this);

    @Property({ type: 'date' })
    public createdAt = new Date();

    @Property({ type: 'date', onUpdate: () => new Date() })
    public updatedAt = new Date();

    public toJSON(user?: User) {
        const obj = wrap<Course>(this).toObject();
        const signupCount = this.users.count();

        let isEnrolled = false;

        if (user) {
            isEnrolled = this.users.contains(user);
        }

        return { ...obj, signupCount, isEnrolled };
    }
}

export type CourseDTO = ReturnType<Course['toJSON']>;