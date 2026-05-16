import {
  sqliteTable,
  integer,
  text,
} from "drizzle-orm/sqlite-core";

export const submissions = sqliteTable("submissions", {
  id: integer("id", { mode: "number" }).primaryKey({ autoIncrement: true }),
  nickname: text("nickname").notNull(),
  name: text("name"),
  problemId: text("problem_id").notNull(),
  problemTitle: text("problem_title").notNull(),
  claim: text("claim").notNull(), // 'prove' or 'disprove'
  parameter: text("parameter").notNull(),
  status: text("status").notNull().default("pending"),
  resultMessage: text("result_message"),
  fileNames: text("file_names"),
  theoremSignature: text("theorem_signature"),
  createdAt: integer("created_at", { mode: "timestamp" }).$defaultFn(() => new Date()),
});