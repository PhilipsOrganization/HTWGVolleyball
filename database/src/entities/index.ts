import { Subscription } from './subscription';
import { CourseSpot, User } from './course-spot';
import { UserStats } from './user-stats';
import { RegistrationStats } from './registration-stats';
import { Course } from './course';

export const entities = [User, Course, CourseSpot, Subscription, UserStats, RegistrationStats];

export * from './subscription';
export * from './course';
export * from './course-spot';
export * from './user-stats';
export * from './registration-stats';
