import { z } from "zod";
import { createRouter, publicQuery } from "../middleware";
import { env } from "../lib/env";
import { TRPCError } from "@trpc/server";

interface GitHubIssueResponse {
  number: number;
  html_url: string;
}

interface LeaderboardEntry {
  rank: number;
  nickname: string;
  name: string;
  problem: string;
  claim: string;
  parameter: string;
  date: string;
  issue?: number;
}

interface LeaderboardData {
  entries: LeaderboardEntry[];
}

/**
 * Create a GitHub issue on the submissions repo with the submission data.
 */
async function createGitHubIssue(
  nickname: string,
  name: string | undefined,
  problemId: string,
  claim: string,
  parameter: string,
  files: Array<{ name: string; content: string }>
): Promise<{ issueNumber: number; issueUrl: string }> {
  if (!env.githubToken) {
    throw new TRPCError({
      code: "INTERNAL_SERVER_ERROR",
      message: "GitHub token not configured",
    });
  }

  const problemTitles: Record<string, string> = {
    challenge_1: "challenge_1 (Hadwiger Number)",
    challenge_2: "challenge_2 (Excluded Minors of GF(pʳ)-representable matroids)",
    challenge_3: "challenge_3 (Ramsey Numbers)",
    challenge_4: "challenge_4 (Sidorenko Conjecture for Half-Graphs)",
    challenge_5: "challenge_5 (Erdős–Hajnal Conjecture)",
    challenge_6: "challenge_6 (Better-Quasi-Ordering of Finite Graphs)",
    challenge_7: "challenge_7 (Rota's Basis Conjecture)",
    challenge_8: "challenge_8 (Ryser's Hypergraph Conjecture)",
    challenge_9: "challenge_9 (Union-Closed Sets Conjecture)",
    challenge_10: "challenge_10 (The Unfriendly Partition Conjecture)",
  };

  const problemTitle = problemTitles[problemId] || problemId;

  // Build issue body in the format expected by evaluate_challenge.py
  const filesJson = JSON.stringify(
    files.map((f) => ({ name: f.name, content: f.content })),
    null,
    2
  );

  const body = [
    `### Submission`,
    "",
    `**Nickname:** ${nickname}`,
    `**Name:** ${name || ""}`,
    `**Problem:** ${problemId}`,
    `**Claim:** ${claim}`,
    `**Parameter:** ${parameter}`,
    "",
    "### Nickname",
    nickname,
    "",
    "### Name",
    name || "",
    "",
    "### Problem",
    problemId,
    "",
    "### Claim",
    claim,
    "",
    "### Chosen parameter",
    parameter,
    "",
    "### Files",
    "```json",
    filesJson,
    "```",
  ].join("\n");

  const title = `[submission] ${nickname} — ${problemTitle} (${claim} for r = ${parameter})`;

  const response = await fetch(
    `https://api.github.com/repos/${env.submissionsRepo}/issues`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${env.githubToken}`,
        Accept: "application/vnd.github+json",
        "Content-Type": "application/json",
        "X-GitHub-Api-Version": "2022-11-28",
      },
      body: JSON.stringify({
        title,
        body,
        labels: ["submission"],
      }),
    }
  );

  if (!response.ok) {
    const errorBody = await response.text();
    throw new TRPCError({
      code: "INTERNAL_SERVER_ERROR",
      message: `Failed to create GitHub issue: ${response.status} ${errorBody}`,
    });
  }

  const data = (await response.json()) as GitHubIssueResponse;
  return {
    issueNumber: data.number,
    issueUrl: data.html_url,
  };
}

/**
 * Fetch the leaderboard from the public leaderboard repo.
 */
async function fetchLeaderboard(): Promise<LeaderboardData> {
  try {
    const response = await fetch(env.leaderboardUrl, {
      headers: {
        Accept: "application/vnd.github.v3.raw",
        // Add cache-busting for freshness
        ...(env.githubToken
          ? { Authorization: `Bearer ${env.githubToken}` }
          : {}),
      },
    });

    if (response.ok) {
      const data = (await response.json()) as LeaderboardData;
      return data;
    }

    // If the file doesn't exist yet (empty leaderboard), return empty
    if (response.status === 404) {
      return { entries: [] };
    }

    console.error("Failed to fetch leaderboard:", response.status);
    return { entries: [] };
  } catch (err) {
    console.error("Error fetching leaderboard:", err);
    return { entries: [] };
  }
}

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
      // Create a GitHub issue with the submission
      const { issueNumber, issueUrl } = await createGitHubIssue(
        input.nickname,
        input.name,
        input.problemId,
        input.claim,
        input.parameter,
        input.files
      );

      return {
        status: "submitted",
        message: `Submission created! Your proof will be evaluated by the CI. Track progress: ${issueUrl}`,
        issueNumber,
        issueUrl,
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
      // Fetch leaderboard from the public leaderboard repo
      const lb = await fetchLeaderboard();

      let entries = lb.entries;

      // Filter by problem if requested
      if (input?.problemId && input.problemId !== "all") {
        entries = entries.filter((e) => e.problem === input.problemId);
      }

      return entries;
    }),

  getById: publicQuery
    .input(z.object({ id: z.number() }))
    .query(async () => {
      // Not used in the new model; return null
      return null;
    }),
});