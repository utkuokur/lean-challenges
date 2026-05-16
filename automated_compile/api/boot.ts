import { Hono } from "hono";
import { bodyLimit } from "hono/body-limit";
import type { HttpBindings } from "@hono/node-server";
import { appRouter } from "./router";
import { createContext } from "./context";
import { env } from "./lib/env";
import { TRPCError } from "@trpc/server";
import { getHTTPStatusCodeFromError } from "@trpc/server/http";

const app = new Hono<{ Bindings: HttpBindings }>();

app.use(bodyLimit({ maxSize: 50 * 1024 * 1024 }));

// FIXED: Call tRPC router directly instead of using fetch adapter
app.use("/api/trpc/*", async (c) => {
  const path = c.req.path.replace("/api/trpc/", "").replace(/^\//, "");
  const type = c.req.method === "GET" ? "query" : "mutation";

  let rawInput: unknown;
  if (type === "mutation") {
    const body = await c.req.json();
    // tRPC client wraps with {json: ...} when using superjson; curl sends plain JSON
    rawInput = body.json ?? body;
  } else {
    const inputParam = c.req.query("input");
    rawInput = inputParam ? JSON.parse(inputParam) : undefined;
  }

  try {
    const ctx = await createContext({ req: c.req.raw });
    const caller = appRouter.createCaller(ctx);

    // Navigate nested routers, e.g. "submission.create"
    const parts = path.split(".");
    let proc: any = caller;
    for (const part of parts) {
      proc = proc[part];
    }

    const result = await proc(rawInput);

    // Return in tRPC response format
    return c.json({ result: { data: result } });
  } catch (cause) {
    const error =
      cause instanceof TRPCError
        ? cause
        : new TRPCError({
            code: "INTERNAL_SERVER_ERROR",
            message: cause instanceof Error ? cause.message : "Unknown error",
            cause,
          });

    return c.json(
      {
        error: {
          json: {
            message: error.message,
            code: error.code,
            data: {
              code: error.code,
              httpStatus: getHTTPStatusCodeFromError(error),
            },
          },
        },
      },
      getHTTPStatusCodeFromError(error),
    );
  }
});

app.all("/api/*", (c) => c.json({ error: "Not Found" }, 404));

export default app;

if (env.isProduction) {
  const { serve } = await import("@hono/node-server");
  const { serveStaticFiles } = await import("./lib/vite");
  serveStaticFiles(app);

  const port = parseInt(process.env.PORT || "3000");
  serve({ fetch: app.fetch, port }, () => {
    console.log(`Server running on http://localhost:${port}/`);
  });
}