import { Collection, Entity, ManyToMany, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import crypto from 'crypto';
import { Course } from './course';

@Entity()
export class User {

    @PrimaryKey()
    public id!: number;

    @Property()
    public username: string;

    @Property({ hidden: true })
    public email: string;

    @Property({ hidden: true })
    public password: string;

    @ManyToMany({ hidden: true, entity: () => Course })
    public courses = new Collection<Course>(this);

    constructor(username: string, email: string, password: string) {
        this.username = username;
        this.email = email;
        this.password = crypto.createHmac('sha256', password).digest('hex');
    }

    public toJSON() {
        return wrap<User>(this).toObject();
    }
}