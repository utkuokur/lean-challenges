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
  databaseUrl: process.env.DATABASE_URL ?? "",
  githubToken: process.env.GITHUB_TOKEN ?? "",
  submissionsRepo: process.env.SUBMISSIONS_REPO ?? "utkuokur/lean-challenges-submissions",
  leaderboardUrl:
    process.env.LEADERBOARD_URL ??
    "https://raw.githubusercontent.com/utkuokur/lean-challenges-leaderboard/main/site-data/leaderboard.json",
  solutionsDir: process.env.SOLUTIONS_DIR ?? "./solutions_archive",
};
