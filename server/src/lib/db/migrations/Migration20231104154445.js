'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231104154445 extends Migration {

  async up() {
    this.addSql('alter table "accounts" add column "reset_token" varchar(255) null, add column "reset_token_expires" timestamptz(0) null;');
  }

  async down() {
    this.addSql('alter table "accounts" drop column "reset_token";');
    this.addSql('alter table "accounts" drop column "reset_token_expires";');
  }

}
exports.Migration20231104154445 = Migration20231104154445;
