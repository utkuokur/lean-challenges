import { z } from "zod";
import { createRouter, publicQuery } from "../middleware";
import { getDb } from "../queries/connection";
import { submissions } from "@db/schema";
import { desc, eq } from "drizzle-orm";
import { checkSubmission, saveSubmissionFiles } from "../lib/lean-checker";

export const submissionRouter = createRouter({
  create: publicQuery
    .input(
      z.object({
        nickname: z.string().min(1).max(255),
        name: z.string().max(255).optional(),
        problemId: z.string().min(1),
        problemTitle: z.string().min(1),
        claim: z.enum(["prove", "disprove"]),
        parameter: z.string().min(1).max(50),
        files: z.array(
          z.object({
            name: z.string(),
            content: z.string(),
          })
        ),
      })
    )
    .mutation(async ({ input }) => {
      const db = getDb();

      const fileNames = input.files.map((f) => f.name).join(", ");

      // FIXED: SQLite insert doesn't return array
      const insertResult = await db.insert(submissions).values({
        nickname: input.nickname,
        name: input.name || null,
        problemId: input.problemId,
        problemTitle: input.problemTitle,
        claim: input.claim,
        parameter: input.parameter,
        status: "checking",
        fileNames,
      }).returning();

      const submissionId = insertResult[0]?.id ?? 1;

      const decodedFiles = input.files.map((f) => ({
        name: f.name,
        content: Buffer.from(f.content, "base64").toString("utf-8"),
      }));

      await saveSubmissionFiles(submissionId, decodedFiles);

      const checkResult = await checkSubmission(decodedFiles);

      const resultMessage = checkResult.message;
      const theoremSig = checkResult.details.submittedSignature;

      await db
        .update(submissions)
        .set({
          status: checkResult.status,
          resultMessage,
          theoremSignature: theoremSig,
        })
        .where(eq(submissions.id, submissionId));

      return {
        id: submissionId,
        status: checkResult.status,
        message: resultMessage,
        details: checkResult.details,
      };
    }),

  list: publicQuery
    .input(
      z
        .object({
          problemId: z.string().optional(),
        })
        .optional()
    )
    .query(async ({ input }) => {
      const db = getDb();

      let query;
      if (input?.problemId && input.problemId !== "all") {
        query = db
          .select()
          .from(submissions)
          .where(eq(submissions.problemId, input.problemId))
          .orderBy(desc(submissions.createdAt));
      } else {
        query = db
          .select()
          .from(submissions)
          .orderBy(desc(submissions.createdAt));
      }

      return await query;
    }),

  getById: publicQuery
    .input(z.object({ id: z.number() }))
    .query(async ({ input }) => {
      const db = getDb();
      const result = await db
        .select()
        .from(submissions)
        .where(eq(submissions.id, input.id));
      return result[0] || null;
    }),
});