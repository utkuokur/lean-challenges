# Hand-off: bootstrapping `utkuokur/lean-challenges-submissions`

Everything in this `submission-repo-template/` directory belongs in the
**new submissions repo**, not in `lean-challenge` itself. The steps below
walk you through creating that repo and getting it working.

## 1. Create the repo on github.com

Pick **one** of the two paths.

### Path A — Fork `leanprover/lean-eval-submissions` (lighter footprint)

1. Go to <https://github.com/leanprover/lean-eval-submissions>
2. Click **Fork** → owner `utkuokur` → name `lean-challenges-submissions` →
   uncheck "Copy the `main` branch only" so you get all branches.
3. Wait for the fork to finish.
4. **Delete** the existing files that belong to lean-eval (they're for
   a different benchmark and will only confuse things):
   ```
   .audit/
   .github/
   docs/
   results/
   scripts/
   site-data/        (if present)
   README.md
   SECURITY.md
   ```
   You can do this in one PR via the web UI's "Delete file" on each, or
   locally:
   ```bash
   git clone https://github.com/utkuokur/lean-challenges-submissions
   cd lean-challenges-submissions
   git rm -r .audit .github docs results scripts README.md SECURITY.md
   git commit -m "reset: strip lean-eval-specific tree"
   git push
   ```

### Path B — Brand-new empty repo (cleaner)

1. Create <https://github.com/utkuokur/lean-challenges-submissions> as a
   new public repo with no README, no .gitignore, no license.
2. Skip to step 2 below.

## 2. Drop in the files from `submission-repo-template/`

From your local `lean-challenge` checkout:

```bash
cd C:/Users/utkuo/Documents/Claude/lean-challenge
git clone https://github.com/utkuokur/lean-challenges-submissions /tmp/subs
cp -r submission-repo-template/. /tmp/subs/
cd /tmp/subs
git add .
git commit -m "bootstrap: issue template, CI workflow, empty leaderboard"
git push
```

The tree on the submissions repo should now look like:

```
.github/
  ISSUE_TEMPLATE/
    config.yml
    submit.yml
  workflows/
    submission.yml
scripts/
  append_leaderboard.py
site-data/
  leaderboard.json   (initial content: {"entries": []})
README.md
```

## 3. Enable Actions and grant write permission

By default, GitHub Actions on a brand-new repo has **read-only** access
to the repo's contents. The CI needs to push commits to update
`site-data/leaderboard.json`.

1. Submissions repo → **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, select
   **Read and write permissions** and click Save.
3. Optionally tick "Allow GitHub Actions to create and approve pull
   requests" (not used by our workflow, but harmless).

The default `GITHUB_TOKEN` is now sufficient. You do **not** need a PAT
or a GitHub App.

## 4. Sanity-check the issue form

Open <https://github.com/utkuokur/lean-challenges-submissions/issues/new/choose>.
You should see a single template called **"Submit a proof"**. Click it,
fill it in with a dummy URL pointing at any public `.lean` raw URL, and
submit. The CI will run, fail (because the URL isn't a real proof of
challenge_NN), and comment on the issue. Close it after — this is just
the smoke test.

## 5. Update the React app's leaderboard URL (already done locally)

`automated_compile/api/lib/env.ts` is already pointing at
`https://raw.githubusercontent.com/utkuokur/lean-challenges-submissions/main/site-data/leaderboard.json`.
Once step 2 lands, that URL returns `{"entries": []}` (HTTP 200) and the
React leaderboard table is fully live.

## 6. Delete the now-unused `utkuokur/lean-eval-leaderboard` fork (optional)

Your earlier fork of `lean-eval-leaderboard` is no longer wired into
anything. Delete it from github.com → repo Settings → Danger Zone → Delete
this repository, or just leave it sitting there — it doesn't cost
anything.

## 7. Things to know about the workflow

Read `.github/workflows/submission.yml` end-to-end at least once. Key
points:

- Triggered by `issues: types: [labeled]` and gated on the label being
  `submission`. The issue template applies that label automatically.
- Two checkouts: the submissions repo (for `scripts/` and to push
  `site-data/`) and `utkuokur/lean-challenge@universal-challenges` (for
  the lakefile + `Challenges/` directory).
- The user's URL must return plain text. Use the raw URLs:
  - GitHub:
    `https://raw.githubusercontent.com/<owner>/<repo>/<sha>/path/to/challenge_01.lean`
  - Gist:
    `https://gist.githubusercontent.com/<user>/<id>/raw/challenge_01.lean`
- The build runs `lake exe cache get` first to pull Mathlib's prebuilt
  oleans. If that misses, the build takes hours instead of minutes; you
  might want to keep an eye on it the first few times.
- **No identity verification** — `nickname` is whatever the submitter
  types in the form. If you want abuse controls, the GitHub issue
  author is `${{ github.event.issue.user.login }}` and is recorded
  in the issue itself; you could later add it to the leaderboard
  entry.

## 8. When something goes wrong

- **Workflow doesn't run**: check Actions tab → recent runs. If nothing
  appears, the trigger didn't fire — usually means the label
  `submission` wasn't applied. Check that
  `.github/ISSUE_TEMPLATE/submit.yml` has `labels: [submission]` and
  that the label exists on the repo (it's auto-created on first use).
- **Workflow runs but can't push**: re-do step 3 (workflow permissions).
- **Workflow can't find `Challenges/challenge_NN.lean`**: the user's URL
  returned the wrong file. The issue comment will show the build error
  ("file not found" from lake).
- **Mathlib build takes forever**: `lake exe cache get` returned a miss.
  Common cause: the `lean-toolchain` in `utkuokur/lean-challenge` was
  bumped to a version that doesn't have a published cache yet.
