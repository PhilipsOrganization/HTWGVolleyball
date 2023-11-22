'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const { Migration } = require('@mikro-orm/migrations');

class Migration20231104134212 extends Migration {
	async up() {
		this.addSql('alter table "accounts" add column "created_at" timestamptz(0) not null default current_timestamp;');
	}

	async down() {
		this.addSql('alter table "accounts" drop column "created_at";');
	}
}
exports.Migration20231104134212 = Migration20231104134212;
