ALTER TABLE "courses" ADD COLUMN "from_template" integer;--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "courses" ADD CONSTRAINT "courses_from_template_course_template_id_fk" FOREIGN KEY ("from_template") REFERENCES "public"."course_template"("id") ON DELETE set null ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
