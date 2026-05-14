import {
  mysqlTable,
  serial,
  varchar,
  text,
  timestamp,
} from "drizzle-orm/mysql-core";

export const submissions = mysqlTable("submissions", {
  id: serial("id").primaryKey(),
  nickname: varchar("nickname", { length: 255 }).notNull(),
  name: varchar("name", { length: 255 }),
  problemId: varchar("problem_id", { length: 50 }).notNull(),
  problemTitle: varchar("problem_title", { length: 255 }).notNull(),
  claim: varchar("claim", { length: 10 }).notNull(), // 'prove' or 'disprove'
  parameter: varchar("parameter", { length: 50 }).notNull(),
  status: varchar("status", { length: 20 }).notNull().default("pending"),
  resultMessage: text("result_message"),
  fileNames: text("file_names"),
  theoremSignature: text("theorem_signature"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});
