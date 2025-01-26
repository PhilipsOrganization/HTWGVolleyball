ALTER TABLE "course_template" ALTER COLUMN "max_strikes" SET DEFAULT 0;--> statement-breakpoint
ALTER TABLE "course_template" ADD COLUMN "trainer" integer;--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "course_template" ADD CONSTRAINT "course_template_trainer_accounts_id_fk" FOREIGN KEY ("trainer") REFERENCES "public"."accounts"("id") ON DELETE no action ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
