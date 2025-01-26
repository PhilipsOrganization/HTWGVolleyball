ALTER TABLE "course_template" ADD COLUMN "max_strikes" integer DEFAULT 10 NOT NULL;--> statement-breakpoint
ALTER TABLE "courses" ADD COLUMN "max_strikes" integer DEFAULT 10 NOT NULL;--> statement-breakpoint
ALTER TABLE "courses" ADD COLUMN "deleted_at" timestamp with time zone;