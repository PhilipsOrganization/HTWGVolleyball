import { Entity, ManyToOne, Property } from "@mikro-orm/core";
import { User } from "./user";
import { Course } from "./course";

@Entity()
export class CourseSpot {

    @ManyToOne(() => User, { primary: true })
    public user!: User;

    @ManyToOne(() => Course, { primary: true })
    public course!: Course;

    @Property({ defaultRaw: "CURRENT_TIMESTAMP" })
    createdAt = new Date();
}