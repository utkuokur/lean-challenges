import { promises as fs } from "fs";
import path from "path";
import { exec } from "child_process";
import { promisify } from "util";

const execAsync = promisify(exec);

const WORKSPACE_DIR = path.resolve(process.cwd(), "uploads");

// Configuration: adjust these paths to match your WSL setup
const LEAN_PROJECT_DIR =
  process.env.LEAN_PROJECT_DIR || path.resolve(process.cwd(), "../lean-checker");
const LAKE_TIMEOUT_MS = parseInt(process.env.LAKE_TIMEOUT_MS || "300000"); // 5 minutes default

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
  "theorem challenge_1 (G : SimpleGraph V) :\n  -- hadwigerNumber G ≤ r → G.Colorable (r + 1) := by\n  0=0 := by";

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
): Promise<string> {
  // Copy uploaded files into the lean-checker project
  for (const file of files) {
    const srcPath = path.join(submissionDir, file.name);
    const dstPath = path.join(LEAN_PROJECT_DIR, file.name);

    try {
      const content = await fs.readFile(srcPath, "utf-8");
      await fs.writeFile(dstPath, content, "utf-8");
    } catch {
      // File might be in a subdirectory
      try {
        const content = await fs.readFile(srcPath, "utf-8");
        await fs.mkdir(path.dirname(dstPath), { recursive: true });
        await fs.writeFile(dstPath, content, "utf-8");
      } catch (err) {
        throw new Error(`Failed to copy ${file.name} to project: ${err}`);
      }
    }
  }

  return LEAN_PROJECT_DIR;
}

async function runLakeBuild(): Promise<{
  exitCode: number | null;
  stdout: string;
  stderr: string;
}> {
  try {
    const { stdout, stderr } = await execAsync("lake build", {
      cwd: LEAN_PROJECT_DIR,
      timeout: LAKE_TIMEOUT_MS,
      env: {
        ...process.env,
        // Ensure elan is in PATH
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

  // 1. Check all .lean files for sorry
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
      message: `Found ${details.sorryCount} occurrence(s) of 'sorry' in your files. All proofs must be complete.`,
      details,
    };
  }

  // 2. Find challenge_1.lean and check theorem signature
  const challengeFile = leanFiles.find(
    (f) => f.name === "challenge_1.lean"
  );

  if (!challengeFile) {
    return {
      status: "rejected",
      message:
        "Required file 'challenge_1.lean' not found. Your submission must include this file.",
      details,
    };
  }

  const theoremMatch = challengeFile.content.match(
    /(theorem\s+challenge_1\s*\([^)]*\)\s*:\s*[\s\S]*?)(?=\s*:=\s*by|\s*:=)/
  );

  if (!theoremMatch) {
    return {
      status: "rejected",
      message:
        "Could not find theorem 'challenge_1' in challenge_1.lean. The theorem must be present and named exactly 'challenge_1'.",
      details,
    };
  }

  details.submittedSignature = theoremMatch[1].trim();
  const submitted = details.submittedSignature;

  if (!submitted.includes("theorem challenge_1")) {
    return {
      status: "rejected",
      message:
        "Theorem must be named 'challenge_1'. The statement before := by must not be modified.",
      details,
    };
  }

  const statementBody = submitted
    .replace(/theorem\s+challenge_1\s*\([^)]*\)\s*:\s*/, "")
    .trim();

  const hasOriginalStatement = statementBody.includes("0=0");

  if (!hasOriginalStatement) {
    return {
      status: "rejected",
      message:
        "The theorem statement has been modified. You must not change what the theorem claims — only replace sorry with a complete proof.",
      details,
    };
  }

  details.theoremSignatureMatch = true;

  // 3. Save files and run lake build
  try {
    // Save files to a temporary workspace
    const timestamp = Date.now();
    const submissionDir = path.join(WORKSPACE_DIR, String(timestamp));
    await fs.mkdir(submissionDir, { recursive: true });

    for (const file of files) {
      const filePath = path.join(submissionDir, file.name);
      await fs.mkdir(path.dirname(filePath), { recursive: true });
      await fs.writeFile(filePath, file.content, "utf-8");
    }

    // Copy files into the lean-checker project
    await copyFilesToLeanProject(submissionDir, files);

    // Run lake build
    const buildResult = await runLakeBuild();
    details.compilationExitCode = buildResult.exitCode;
    details.compilationOutput =
      buildResult.stdout + "\n" + buildResult.stderr;

    if (buildResult.exitCode !== 0) {
      // Truncate output for storage
      const truncatedOutput =
        details.compilationOutput.length > 2000
          ? details.compilationOutput.substring(0, 2000) + "..."
          : details.compilationOutput;

      return {
        status: "rejected",
        message: `Compilation failed. lake build exited with code ${buildResult.exitCode}. Error: ${truncatedOutput}`,
        details,
      };
    }
  } catch (err) {
    const errorMsg = err instanceof Error ? err.message : String(err);
    return {
      status: "rejected",
      message: `Failed to compile: ${errorMsg}`,
      details,
    };
  }

  return {
    status: "accepted",
    message:
      "Submission verified: no sorry found, theorem statement preserved, compilation successful.",
    details,
  };
}
