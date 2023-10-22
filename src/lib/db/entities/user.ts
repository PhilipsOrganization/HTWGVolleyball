import { Collection, Embedded, Entity, ManyToMany, PrimaryKey, Property, wrap } from '@mikro-orm/core';
import crypto from 'crypto';
import { Course } from './course';
import { Role } from '../role';
import { Subscription } from './subscription';

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

    @Property({ hidden: true, nullable: true })
    public sessionToken?: string;

    @Property()
    public role = Role.USER;

    @Property()
    public strikes: number;

    @Property({ nullable: true })
    public notes?: string;

    @Embedded(() => Subscription, { nullable: true })
    public subscription?: Subscription;

    @ManyToMany({ hidden: true, entity: () => Course, eager: true })
    public courses = new Collection<Course>(this);

    constructor(username: string, email: string, password: string) {
        this.username = username;
        this.email = email;
        this.password = crypto.createHmac('sha256', password).digest('hex');
        this.strikes = 0;
    }

    public toJSON() {
        return wrap<User>(this).toObject();
    }

    public isPasswordCorrect(password: string) {
        const hash = crypto.createHmac('sha256', password).digest('hex');
        return hash === this.password;
    }

    @Property({ persist: false })
    public get hasNotificationsEnabled() {
        return this.subscription !== undefined;
    }
}