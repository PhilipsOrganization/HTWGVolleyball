'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231111152800 extends Migration {

  async up() {
    this.addSql('alter table "accounts" alter column "password" type varchar(255) using ("password"::varchar(255));');
    this.addSql('alter table "accounts" alter column "password" drop not null;');
  }

  async down() {
    this.addSql('alter table "accounts" alter column "password" type varchar(255) using ("password"::varchar(255));');
    this.addSql('alter table "accounts" alter column "password" set not null;');
  }

}
exports.Migration20231111152800 = Migration20231111152800;
