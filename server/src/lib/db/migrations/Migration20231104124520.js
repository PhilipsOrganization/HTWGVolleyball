'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231104124520 extends Migration {

  async up() {
    this.addSql('alter table "courses" add column "notification_sent" boolean not null default false;');
  }

  async down() {
    this.addSql('alter table "courses" drop column "notification_sent";');
  }

}
exports.Migration20231104124520 = Migration20231104124520;
