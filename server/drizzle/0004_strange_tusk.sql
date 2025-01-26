CREATE TABLE IF NOT EXISTS "course_template" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(255) NOT NULL,
	"max_participants" integer NOT NULL,
	"location" varchar(255) NOT NULL,
	"time" varchar(255) NOT NULL,
	"group_id" integer,
	"day" integer NOT NULL,
	"publish_day" integer NOT NULL,
	"publish_hour" integer NOT NULL,
	"allow_double_bookings" boolean DEFAULT false NOT NULL,
	"auto_create" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "course_template" ADD CONSTRAINT "course_template_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE no action ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "course_template_name_index" ON "course_template" USING btree ("name");