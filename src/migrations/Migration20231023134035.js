'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231023134035 extends Migration {

  async up() {
    this.addSql('PRAGMA foreign_keys = OFF;');
    this.addSql('CREATE TABLE `_knex_temp_alter257` (`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL, `name` text NOT NULL, `date` date(3) NOT NULL, `publish_on` date(3) NOT NULL, `max_participants` integer NOT NULL, `location` text NOT NULL, `time` text NOT NULL, `created_at` datetime NOT NULL, `updated_at` datetime NOT NULL);');
    this.addSql('INSERT INTO "_knex_temp_alter257" SELECT * FROM "courses";;');
    this.addSql('DROP TABLE "courses";');
    this.addSql('ALTER TABLE "_knex_temp_alter257" RENAME TO "courses";');
    this.addSql('PRAGMA foreign_keys = ON;');
  }

}
exports.Migration20231023134035 = Migration20231023134035;
