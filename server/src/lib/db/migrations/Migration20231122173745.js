'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231122173745 extends Migration {

  async up() {
    this.addSql('drop table if exists "accounts_courses" cascade;');
  }

  async down() {
    this.addSql('create table "accounts_courses" ("user_id" int not null, "course_id" int not null, constraint "accounts_courses_pkey" primary key ("user_id", "course_id"));');

    this.addSql('alter table "accounts_courses" add constraint "accounts_courses_user_id_foreign" foreign key ("user_id") references "accounts" ("id") on update cascade on delete cascade;');
    this.addSql('alter table "accounts_courses" add constraint "accounts_courses_course_id_foreign" foreign key ("course_id") references "courses" ("id") on update cascade on delete cascade;');
  }

}
exports.Migration20231122173745 = Migration20231122173745;
