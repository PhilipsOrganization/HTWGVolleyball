'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231104211514 extends Migration {

  async up() {
    this.addSql('ALTER TABLE "accounts" ADD COLUMN "display_name" VARCHAR(255) null;');
  }

  async down() {
    this.addSql('alter table "accounts" drop column "display_name";');
  }

}
exports.Migration20231104211514 = Migration20231104211514;
