CREATE TABLE "users" (
  "id" BIGSERIAL PRIMARY KEY,
  "email" varchar(255) UNIQUE NOT NULL,
  "password" text NOT NULL,
  "name" varchar(255) NOT NULL,
  "role" integer NOT NULL,
  "avatar_url" text DEFAULT null,
  "provider" varchar(50) NOT NULL,
  "provider_id" varchar(255) NOT NULL,
  "created_at" timestampz NOT NULL,
  "updated_at" timestampz NOT NULL
);

CREATE TABLE "roles" (
  "id" serial PRIMARY KEY,
  "role_name" varchar(50) UNIQUE NOT NULL
);

CREATE TABLE "tasks" (
  "id" BIGSERIAL PRIMARY KEY,
  "title" varchar(255) NOT NULL,
  "description" text,
  "column_id" bigint NOT NULL,
  "progress" integer NOT NULL DEFAULT 0,
  "deadline" timestampz DEFAULT null,
  "image_url" text DEFAULT null,
  "creator_id" bigint NOT NULL,
  "created_at" timestampz NOT NULL,
  "updated_at" timestampz NOT NULL
);

CREATE TABLE "task_assignments" (
  "user_id" bigint NOT NULL,
  "task_id" bigint NOT NULL,
  "assigned_at" timestampz NOT NULL,
  "modified_at" timestampz NOT NULL,
  PRIMARY KEY ("user_id", "task_id"),
  PRIMARY KEY ("user_id", "task_id")
);

CREATE TABLE "checklist_items" (
  "id" BIGSERIAL PRIMARY KEY,
  "description" text NOT NULL,
  "is_completed" boolean NOT NULL DEFAULT false,
  "task_id" bigint NOT NULL
);

CREATE TABLE "columns" (
  "id" BIGSERIAL PRIMARY KEY,
  "name" varchar(100) NOT NULL,
  "user_id" bigint NOT NULL,
  "column_order" integer NOT NULL,
  "created_at" timestampz NOT NULL,
  "updated_at" timestampz NOT NULL
);

CREATE INDEX ON "users" ("email");

CREATE UNIQUE INDEX ON "users" ("provider", "provider_id");

CREATE INDEX ON "tasks" ("creator_id");

CREATE INDEX ON "tasks" ("column_id");

CREATE UNIQUE INDEX ON "columns" ("user_id", "name");

CREATE UNIQUE INDEX ON "columns" ("user_id", "column_order");

COMMENT ON COLUMN "users"."password" IS 'hashed password value';

COMMENT ON COLUMN "users"."role" IS 'Default role is user';

COMMENT ON COLUMN "users"."avatar_url" IS 'URL to avatar';

COMMENT ON COLUMN "tasks"."column_id" IS 'Defines in which collumn the Task is in at the momment';

COMMENT ON COLUMN "tasks"."progress" IS 'Defines how many of the subtasks are done';

COMMENT ON COLUMN "tasks"."deadline" IS 'Optional date';

COMMENT ON COLUMN "tasks"."image_url" IS 'Optional image url in case the user wants a background image for the card';

ALTER TABLE "users" ADD FOREIGN KEY ("role") REFERENCES "roles" ("id");

ALTER TABLE "tasks" ADD FOREIGN KEY ("column_id") REFERENCES "columns" ("id");

ALTER TABLE "tasks" ADD FOREIGN KEY ("creator_id") REFERENCES "users" ("id");

ALTER TABLE "task_assignments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "task_assignments" ADD FOREIGN KEY ("task_id") REFERENCES "tasks" ("id");

ALTER TABLE "checklist_items" ADD FOREIGN KEY ("task_id") REFERENCES "tasks" ("id") ON DELETE CASCADE;

ALTER TABLE "columns" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
