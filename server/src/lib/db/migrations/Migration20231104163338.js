'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231104163338 extends Migration {

  async up() {
    this.addSql('alter table "accounts" add column "last_login" timestamptz(0) null;');
    this.addSql('alter table "accounts" alter column "role" type varchar(255) using ("role"::varchar(255));');
    this.addSql('alter table "accounts" alter column "role" set default \'user\';');
    this.addSql('alter table "accounts" alter column "strikes" type int using ("strikes"::int);');
    this.addSql('alter table "accounts" alter column "strikes" set default 0;');
  }

  async down() {
    this.addSql('alter table "accounts" alter column "role" drop default;');
    this.addSql('alter table "accounts" alter column "role" type varchar(255) using ("role"::varchar(255));');
    this.addSql('alter table "accounts" alter column "strikes" drop default;');
    this.addSql('alter table "accounts" alter column "strikes" type int using ("strikes"::int);');
    this.addSql('alter table "accounts" drop column "last_login";');
  }

}
exports.Migration20231104163338 = Migration20231104163338;
