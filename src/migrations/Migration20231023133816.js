'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231023133816 extends Migration {

  async up() {
    this.addSql('create table `courses` (`id` integer not null primary key autoincrement, `name` text not null, `date` date(3) not null, `publish_on` datetime not null, `max_participants` integer not null, `location` text not null, `time` text not null, `created_at` datetime not null, `updated_at` datetime not null);');

    this.addSql('create table `users` (`id` integer not null primary key autoincrement, `username` text not null, `email` text not null, `password` text not null, `session_token` text null, `role` text not null, `strikes` integer not null, `notes` text null, `subscription_endpoint` text null, `subscription_expiration_time` text null, `subscription_p256dh` text null, `subscription_auth` text null);');

    this.addSql('create table `course_spots` (`course_id` integer not null, `user_id` integer not null, `created_at` datetime not null default CURRENT_TIMESTAMP, constraint `course_spots_course_id_foreign` foreign key(`course_id`) references `courses`(`id`) on update cascade, constraint `course_spots_user_id_foreign` foreign key(`user_id`) references `users`(`id`) on update cascade, primary key (`course_id`, `user_id`));');
    this.addSql('create index `course_spots_course_id_index` on `course_spots` (`course_id`);');
    this.addSql('create index `course_spots_user_id_index` on `course_spots` (`user_id`);');

    this.addSql('create table `users_courses` (`user_id` integer not null, `course_id` integer not null, constraint `users_courses_user_id_foreign` foreign key(`user_id`) references `users`(`id`) on delete cascade on update cascade, constraint `users_courses_course_id_foreign` foreign key(`course_id`) references `courses`(`id`) on delete cascade on update cascade, primary key (`user_id`, `course_id`));');
    this.addSql('create index `users_courses_user_id_index` on `users_courses` (`user_id`);');
    this.addSql('create index `users_courses_course_id_index` on `users_courses` (`course_id`);');
  }

}
exports.Migration20231023133816 = Migration20231023133816;
