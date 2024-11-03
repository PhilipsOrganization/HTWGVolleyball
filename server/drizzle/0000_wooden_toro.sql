-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "courses" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(255) NOT NULL,
	"date" timestamp(3) with time zone NOT NULL,
	"publish_on" timestamp(3) with time zone NOT NULL,
	"max_participants" integer NOT NULL,
	"location" varchar(255) NOT NULL,
	"time" varchar(255) NOT NULL,
	"created_at" timestamp(0) with time zone NOT NULL,
	"updated_at" timestamp(0) with time zone NOT NULL,
	"notification_sent" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "accounts" (
	"id" serial PRIMARY KEY NOT NULL,
	"username" varchar(255) NOT NULL,
	"email" varchar(255) NOT NULL,
	"password" varchar(255),
	"session_token" varchar(255),
	"role" varchar(255) DEFAULT 'user'::character varying NOT NULL,
	"strikes" integer DEFAULT 0 NOT NULL,
	"notes" varchar(255),
	"subscription_endpoint" varchar(255),
	"subscription_expiration_time" varchar(255),
	"subscription_p256dh" varchar(255),
	"subscription_auth" varchar(255),
	"created_at" timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"reset_token" varchar(255),
	"reset_token_expires" timestamp(0) with time zone,
	"last_login" timestamp(0) with time zone,
	"email_verification_token" varchar(255),
	"email_verified" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "course_spots" (
	"course_id" integer NOT NULL,
	"user_id" integer NOT NULL,
	"created_at" timestamp(0) with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "course_spots_pkey" PRIMARY KEY("course_id","user_id")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "course_spots" ADD CONSTRAINT "course_spots_course_id_foreign" FOREIGN KEY ("course_id") REFERENCES "public"."courses"("id") ON DELETE no action ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "course_spots" ADD CONSTRAINT "course_spots_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."accounts"("id") ON DELETE no action ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "courses_name_date_index" ON "courses" ("name","date");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "accounts_session_token_index" ON "accounts" ("session_token");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "accounts_email_index" ON "accounts" ("email");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "accounts_username_index" ON "accounts" ("username");