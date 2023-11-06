'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231106120143 extends Migration {

  async up() {
    this.addSql('alter table "accounts" alter column "email_verified" type boolean using ("email_verified"::boolean);');
  }

  async down() {
    this.addSql('alter table "accounts" alter column "email_verified" type varchar(255) using ("email_verified"::varchar(255));');
  }

}
exports.Migration20231106120143 = Migration20231106120143;
