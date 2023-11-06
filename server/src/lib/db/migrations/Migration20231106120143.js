'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231106120143 extends Migration {

  async up() {
    this.addSql('alter table "accounts" add column "email_verified" boolean not null default false');
  }

  async down() {
    this.addSql('alter table "accounts" drop column "email_verified";');
  }

}
exports.Migration20231106120143 = Migration20231106120143;
