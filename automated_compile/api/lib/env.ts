import "dotenv/config";

function required(name: string): string {
  const value = process.env[name];
  if (!value && process.env.NODE_ENV === "production") {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value ?? "";
}

export const env = {
  isProduction: process.env.NODE_ENV === "production",
  // Submissions are now opened directly as GitHub issues by users
  // (no server-side bot token required). The constants below are the
  // only ones still consumed by the React app and the leaderboard read
  // path in api/routers/submission.ts.
  submissionsRepo: process.env.SUBMISSIONS_REPO ?? "utkuokur/lean-challenges-submissions",
  leaderboardUrl:
    process.env.LEADERBOARD_URL ??
    "https://raw.githubusercontent.com/utkuokur/lean-challenges-submissions/main/site-data/leaderboard.json",
};
