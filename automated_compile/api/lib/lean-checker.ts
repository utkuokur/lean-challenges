import { promises as fs } from "fs";
import path from "path";
import { exec } from "child_process";
import { promisify } from "util";

const execAsync = promisify(exec);

const WORKSPACE_DIR = path.resolve(process.cwd(), "uploads");
const LEAN_PROJECT_DIR =
  process.env.LEAN_PROJECT_DIR || "/home/uokur/hadwiger-challenge";
const CHALLENGES_DIR = path.join(LEAN_PROJECT_DIR, "Challenges");
const LAKE_TIMEOUT_MS = parseInt(process.env.LAKE_TIMEOUT_MS || "300000");

const VALID_CHALLENGE_RE = /^challenge_(0[1-9]|10)\.lean$/;

interface LeanCheckResult {
  status: "accepted" | "rejected";
  message: string;
  details: {
    sorryCount: number;
    filesChecked: number;
    theoremSignatureMatch: boolean;
    originalSignature: string;
    submittedSignature: string;
    compilationOutput: string;
    compilationExitCode: number | null;
  };
}

const ORIGINAL_THEOREM_SIGNATURE =
  "theorem challenge_1 (G : SimpleGraph V) :\n  0=0 := by";

export async function ensureWorkspace(): Promise<void> {
  try {
    await fs.access(WORKSPACE_DIR);
  } catch {
    await fs.mkdir(WORKSPACE_DIR, { recursive: true });
  }
}

export async function saveSubmissionFiles(
  submissionId: number,
  files: Array<{ name: string; content: string }>
): Promise<string> {
  const submissionDir = path.join(WORKSPACE_DIR, String(submissionId));
  await fs.mkdir(submissionDir, { recursive: true });

  for (const file of files) {
    const filePath = path.join(submissionDir, file.name);
    await fs.mkdir(path.dirname(filePath), { recursive: true });
    await fs.writeFile(filePath, file.content, "utf-8");
  }

  return submissionDir;
}

async function copyFilesToLeanProject(
  submissionDir: string,
  files: Array<{ name: string }>
): Promise<void> {
  for (const file of files) {
    const srcPath = path.join(submissionDir, file.name);
    const dstPath = path.join(CHALLENGES_DIR, file.name);
    await fs.mkdir(path.dirname(dstPath), { recursive: true });
    const content = await fs.readFile(srcPath, "utf-8");
    await fs.writeFile(dstPath, content, "utf-8");
  }
}

async function cleanUpLeanProject(files: Array<{ name: string }>): Promise<void> {
  for (const file of files) {
    const dstPath = path.join(CHALLENGES_DIR, file.name);
    try {
      await fs.unlink(dstPath);
    } catch {
      // ignore
    }
  }
}

async function runLakeBuild(moduleName: string): Promise<{
  exitCode: number | null;
  stdout: string;
  stderr: string;
}> {
  try {
    const { stdout, stderr } = await execAsync(`lake build ${moduleName}`, {
      cwd: LEAN_PROJECT_DIR,
      timeout: LAKE_TIMEOUT_MS,
      env: {
        ...process.env,
        PATH: `${process.env.HOME}/.elan/bin:${process.env.PATH}`,
      },
    });
    return { exitCode: 0, stdout, stderr };
  } catch (error: unknown) {
    const err = error as {
      code?: number;
      stdout?: string;
      stderr?: string;
    };
    return {
      exitCode: err.code ?? 1,
      stdout: err.stdout ?? "",
      stderr: err.stderr ?? "",
    };
  }
}

export async function checkSubmission(
  files: Array<{ name: string; content: string }>
): Promise<LeanCheckResult> {
  await ensureWorkspace();

  const details = {
    sorryCount: 0,
    filesChecked: 0,
    theoremSignatureMatch: false,
    originalSignature: ORIGINAL_THEOREM_SIGNATURE,
    submittedSignature: "",
    compilationOutput: "",
    compilationExitCode: null as number | null,
  };

  const leanFiles = files.filter((f) => f.name.endsWith(".lean"));
  details.filesChecked = leanFiles.length;

  if (leanFiles.length === 0) {
    return {
      status: "rejected",
      message: "No .lean files found in submission.",
      details,
    };
  }

  for (const file of leanFiles) {
    const sorryMatches = file.content.match(/\bsorry\b/g);
    if (sorryMatches) {
      details.sorryCount += sorryMatches.length;
    }
  }

  if (details.sorryCount > 0) {
    return {
      status: "rejected",
      message: `Found ${details.sorryCount} occurrence(s) of 'sorry'. All proofs must be complete.`,
      details,
    };
  }

  // Accept only challenge_01.lean ... challenge_10.lean
  const challengeFile = leanFiles.find((f) => VALID_CHALLENGE_RE.test(f.name));

  if (!challengeFile) {
    return {
      status: "rejected",
      message:
        "Required file not found. Your submission must include exactly one file named challenge_01.lean, challenge_02.lean, ..., or challenge_10.lean.",
      details,
    };
  }

  // Extract module name, e.g. challenge_01
  const moduleName = challengeFile.name.replace(".lean", "");

  const theoremMatch = challengeFile.content.match(
    /(theorem\s+challenge_1\s*\([^)]*\)\s*:\s*[\s\S]*?)(?=\s*:=\s*by|\s*:=)/
  );

  if (!theoremMatch) {
    return {
      status: "rejected",
      message: "Could not find theorem 'challenge_1' in " + challengeFile.name + ".",
      details,
    };
  }

  details.submittedSignature = theoremMatch[1].trim();

  if (!details.submittedSignature.includes("0=0")) {
    return {
      status: "rejected",
      message: "The theorem statement has been modified.",
      details,
    };
  }

  details.theoremSignatureMatch = true;

  try {
    const timestamp = Date.now();
    const submissionDir = path.join(WORKSPACE_DIR, String(timestamp));
    await fs.mkdir(submissionDir, { recursive: true });

    for (const file of files) {
      const filePath = path.join(submissionDir, file.name);
      await fs.mkdir(path.dirname(filePath), { recursive: true });
      await fs.writeFile(filePath, file.content, "utf-8");
    }

    await copyFilesToLeanProject(submissionDir, files);

    const buildResult = await runLakeBuild(`Challenges.${moduleName}`);
    details.compilationExitCode = buildResult.exitCode;
    details.compilationOutput = buildResult.stdout + "\n" + buildResult.stderr;

    await cleanUpLeanProject(files);

    if (buildResult.exitCode !== 0) {
      const truncated =
        details.compilationOutput.length > 2000
          ? details.compilationOutput.substring(0, 2000) + "..."
          : details.compilationOutput;

      return {
        status: "rejected",
        message: `Compilation failed (exit ${buildResult.exitCode}): ${truncated}`,
        details,
      };
    }
  } catch (err) {
    const errorMsg = err instanceof Error ? err.message : String(err);
    await cleanUpLeanProject(files).catch(() => {});
    return {
      status: "rejected",
      message: `Failed to compile: ${errorMsg}`,
      details,
    };
  }

  return {
    status: "accepted",
    message: "Submission verified and compiled successfully.",
    details,
  };
}