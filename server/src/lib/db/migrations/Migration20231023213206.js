'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231023213206 extends Migration {

  async up() {
    this.addSql('create table "courses" ("id" serial primary key, "name" varchar(255) not null, "date" timestamptz(3) not null, "publish_on" timestamptz(3) not null, "max_participants" int not null, "location" varchar(255) not null, "time" varchar(255) not null, "created_at" timestamptz(0) not null, "updated_at" timestamptz(0) not null);');
    this.addSql('create index "courses_name_date_index" on "courses" ("name", "date");');

    this.addSql('create table "accounts" ("id" serial primary key, "username" varchar(255) not null, "email" varchar(255) not null, "password" varchar(255) not null, "session_token" varchar(255) null, "role" varchar(255) not null, "strikes" int not null, "notes" varchar(255) null, "subscription_endpoint" varchar(255) null, "subscription_expiration_time" varchar(255) null, "subscription_p256dh" varchar(255) null, "subscription_auth" varchar(255) null);');
    this.addSql('create index "accounts_session_token_index" on "accounts" ("session_token");');
    this.addSql('create index "accounts_email_index" on "accounts" ("email");');
    this.addSql('create index "accounts_username_index" on "accounts" ("username");');

    this.addSql('create table "course_spots" ("course_id" int not null, "user_id" int not null, "created_at" timestamptz(0) not null default now(), constraint "course_spots_pkey" primary key ("course_id", "user_id"));');

    this.addSql('create table "accounts_courses" ("user_id" int not null, "course_id" int not null, constraint "accounts_courses_pkey" primary key ("user_id", "course_id"));');

    this.addSql('alter table "course_spots" add constraint "course_spots_course_id_foreign" foreign key ("course_id") references "courses" ("id") on update cascade;');
    this.addSql('alter table "course_spots" add constraint "course_spots_user_id_foreign" foreign key ("user_id") references "accounts" ("id") on update cascade;');

    this.addSql('alter table "accounts_courses" add constraint "accounts_courses_user_id_foreign" foreign key ("user_id") references "accounts" ("id") on update cascade on delete cascade;');
    this.addSql('alter table "accounts_courses" add constraint "accounts_courses_course_id_foreign" foreign key ("course_id") references "courses" ("id") on update cascade on delete cascade;');

  }

  async down() {
    this.addSql('alter table "course_spots" drop constraint "course_spots_course_id_foreign";');

    this.addSql('alter table "accounts_courses" drop constraint "accounts_courses_course_id_foreign";');

    this.addSql('alter table "course_spots" drop constraint "course_spots_user_id_foreign";');

    this.addSql('alter table "accounts_courses" drop constraint "accounts_courses_user_id_foreign";');

    this.addSql('drop table if exists "courses" cascade;');

    this.addSql('drop table if exists "accounts" cascade;');

    this.addSql('drop table if exists "course_spots" cascade;');

    this.addSql('drop table if exists "accounts_courses" cascade;');
  }

}
exports.Migration20231023213206 = Migration20231023213206;
