'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231122183742 extends Migration {

  async up() {
    this.addSql('alter table "course_spots" drop constraint "course_spots_pkey";');
    this.addSql('alter table "course_spots" add constraint "course_spots_pkey" primary key ("user_id", "course_id");');
  }

  async down() {
    this.addSql('alter table "course_spots" drop constraint "course_spots_pkey";');
    this.addSql('alter table "course_spots" add constraint "course_spots_pkey" primary key ("course_id", "user_id");');
  }

}
exports.Migration20231122183742 = Migration20231122183742;
