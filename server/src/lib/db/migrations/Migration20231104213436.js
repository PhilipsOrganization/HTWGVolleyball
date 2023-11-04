'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231104213436 extends Migration {

  async up() {
    this.addSql('alter table "accounts" drop column "display_name";');
  }

  async down() {
    this.addSql('alter table "accounts" add column "display_name" varchar(255) null;');
  }

}
exports.Migration20231104213436 = Migration20231104213436;
