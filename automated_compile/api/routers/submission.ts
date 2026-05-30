import { z } from "zod";
import { createRouter, publicQuery } from "../middleware";
import { env } from "../lib/env";

interface LeaderboardEntry {
  rank: number;
  nickname: string;
  name: string;
  problem: string;
  claim: string;
  parameter: string;
  date: string;
  issue?: number;
  source_url?: string;
}

interface LeaderboardData {
  entries: LeaderboardEntry[];
}

/**
 * Fetch the leaderboard JSON from the submissions repo's raw URL.
 *
 * The file is maintained by the CI workflow on
 * `utkuokur/lean-challenges-submissions` — every accepted submission
 * issue appends one entry. A 404 (file not yet created) is treated as
 * an empty leaderboard so the UI degrades gracefully during bootstrap.
 */
async function fetchLeaderboard(): Promise<LeaderboardData> {
  try {
    const response = await fetch(env.leaderboardUrl, {
      headers: { Accept: "application/vnd.github.v3.raw" },
    });

    if (response.ok) {
      return (await response.json()) as LeaderboardData;
    }
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
  list: publicQuery
    .input(
      z
        .object({
          problemId: z.string().optional(),
        })
        .optional()
    )
    .query(async ({ input }) => {
      const lb = await fetchLeaderboard();
      let entries = lb.entries;
      if (input?.problemId && input.problemId !== "all") {
        entries = entries.filter((e) => e.problem === input.problemId);
      }
      return entries;
    }),
});
