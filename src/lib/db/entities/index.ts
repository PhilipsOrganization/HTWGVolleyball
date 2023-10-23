import { Subscription } from './subscription';
import { CourseSpot, Course, User } from './course-spot';
import { UserStats } from './user-stats';
import { RegistrationStats } from './registration-stats';

export const entities = [User, Course, CourseSpot, Subscription, UserStats, RegistrationStats];

export * from './subscription';
export * from './course-spot';
export * from './user-stats';
