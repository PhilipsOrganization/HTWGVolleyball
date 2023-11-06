'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231106095304 extends Migration {

  async up() {
    this.addSql('alter table "accounts" add column "email_verification_token" varchar(255) null;');
  }

  async down() {
    this.addSql('alter table "accounts" drop column "email_verification_token";');
  }

}
exports.Migration20231106095304 = Migration20231106095304;
