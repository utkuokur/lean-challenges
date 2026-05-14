import { createRouter, publicQuery } from "./middleware";
import { submissionRouter } from "./routers/submission";

export const appRouter = createRouter({
  ping: publicQuery.query(() => ({ ok: true, ts: Date.now() })),

  submission: submissionRouter,
});

export type AppRouter = typeof appRouter;
