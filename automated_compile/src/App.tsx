import { useState } from "react";
import { trpc } from "@/providers/trpc";
import { problems } from "@/data/problems";

// Submissions are filed as GitHub Issues on the submissions repo
// (see api/lib/env.ts -> submissionsRepo). The form fields below are
// cosmetic: clicking "Submit on GitHub" constructs a pre-filled URL to
// the issue template using the same field ids, but the user can still
// edit/clear the prefilled values on the GitHub side before submitting.
const SUBMISSIONS_REPO = "utkuokur/lean-challenges-submissions";
const ISSUE_TEMPLATE_BASE = `https://github.com/${SUBMISSIONS_REPO}/issues/new?template=submit.yml`;

/**
 * Map (problem_id chosen in the React form, claim) -> the actual
 * problem id in the issue-template dropdown.
 *
 * Parametrized problems (challenge_1..challenge_10) don't have a
 * separate disprove slot, so claim is ignored for them. Universal
 * problems (challenge_N_univ) have a `_disprove` companion in the
 * dropdown, selected when claim === "disprove".
 */
function resolveProblemDropdownId(problemId: string, claim: string): string {
  if (problemId.endsWith("_univ") && claim === "disprove") {
    return `${problemId}_disprove`;
  }
  return problemId;
}

/** Compose the issue template URL with prefilled values. */
function buildPrefilledUrl(args: {
  problemId: string;
  claim: string;
  parameter: string;
  nickname: string;
  fullName: string;
}): string {
  const resolved = resolveProblemDropdownId(args.problemId, args.claim);
  const params = new URLSearchParams();
  if (resolved) params.set("problem_id", resolved);
  if (args.claim) params.set("claim", args.claim);
  if (args.parameter) params.set("parameter", args.parameter);
  if (args.nickname) params.set("nickname", args.nickname);
  if (args.fullName) params.set("full_name", args.fullName);
  return `${ISSUE_TEMPLATE_BASE}&${params.toString()}`;
}

function App() {
  const [openProblemId, setOpenProblemId] = useState<string | null>(null);
  const [activeLbTab, setActiveLbTab] = useState("all");

  // Cosmetic submission-form state. These don't actually submit
  // anything; they only seed the GitHub issue template via URL query
  // parameters when the user clicks "Submit on GitHub".
  const [subNickname, setSubNickname] = useState("");
  const [subName, setSubName] = useState("");
  const [subProblem, setSubProblem] = useState("");
  const [subClaim, setSubClaim] = useState("");
  const [subParameter, setSubParameter] = useState("");

  // tRPC
  const { data: submissions } = trpc.submission.list.useQuery(
    activeLbTab === "all" ? undefined : { problemId: activeLbTab }
  );

  const toggleProblem = (id: string) => {
    setOpenProblemId((prev) => (prev === id ? null : id));
  };

  // Leaderboard data processing — entries already come ranked from leaderboard.json
  const lbEntries = (submissions || []).map((s) => ({
    rank: s.rank,
    nickname: s.nickname,
    name: s.name || "",
    problem: s.problem,
    result: `${s.claim === "prove" ? "holds" : "fails"} for r = ${s.parameter}`,
    date: s.date || "",
  }));

  const githubUrl = buildPrefilledUrl({
    problemId: subProblem,
    claim: subClaim,
    parameter: subParameter,
    nickname: subNickname,
    fullName: subName,
  });

  return (
    <>
      {/* Header */}
      <header className="header">
        <span className="header-title">Parametrized Problems in Lean</span>
        <nav>
          <ul className="header-nav">
            <li><a href="#problems">Problems</a></li>
            <li><a href="#rules">Rules</a></li>
            <li><a href="#leaderboard">Leaderboard</a></li>
            <li><a href="#submit">Submit</a></li>
          </ul>
        </nav>
      </header>

      <main className="main">
        {/* Intro */}
        <section className="intro">
          <h1 style={{ fontSize: 28, fontWeight: "normal", fontStyle: "italic", marginBottom: 16, lineHeight: 1.3 }}>
            Parametrized Problems in Lean 4
          </h1>
          <p style={{ fontSize: 16, color: "#333", maxWidth: 640 }}>
            A collection of formal mathematics challenges. Select a problem, prove or disprove your bounds, and submit your solution.
          </p>
        </section>

        {/* Problems */}
        <section id="problems">
          <h2 className="section-heading">Open Problems</h2>
          <p style={{ fontSize: 15, color: "#333", marginBottom: 20 }}>
            Click a problem to view its statement and details.
          </p>
          <div>
            {problems.map((p) => (
              <div key={p.id}>
                <div
                  className={`problem-item ${openProblemId === p.id ? "active" : ""}`}
                  onClick={() => toggleProblem(p.id)}
                >
                  <div style={{ display: "flex", alignItems: "baseline", justifyContent: "space-between", gap: 16, flexWrap: "wrap" }}>
                    <span style={{ fontSize: 16, fontWeight: "bold" }}>{p.title}</span>
                    <span style={{ fontSize: 13, color: "#555", fontFamily: '"Courier New", Courier, monospace' }}>
                      largest r so far: {p.largestParameterKnown}
                    </span>
                  </div>
                  <p style={{ marginTop: 8, fontSize: 15, color: "#333", lineHeight: 1.6 }}>
                    {p.shortDesc}
                  </p>
                </div>
                <div className={`detail-panel ${openProblemId === p.id ? "active" : ""}`}>
                  <span
                    style={{ fontSize: 13, color: "#555", cursor: "pointer", marginBottom: 16, display: "inline-block", fontFamily: '"Courier New", Courier, monospace' }}
                    onClick={(e) => { e.stopPropagation(); setOpenProblemId(null); }}
                  >
                    &larr; back to list
                  </span>
                  <h3>{p.title}</h3>
                  <iframe
                    src={p.pdfPath}
                    style={{ width: "100%", height: "500px", border: "1px solid #ddd", borderRadius: "4px", marginBottom: "12px" }}
                    title={`${p.title} – full problem statement`}
                  />
                  <div className="info-box">
                    <div className="info-box-label">Status in Mathlib4</div>
                    <p><strong>{p.status}</strong></p>
                    <p style={{ fontSize: 14 }}>{p.info}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Rules */}
        <section id="rules">
          <h2 className="section-heading">Rules</h2>
          <p>Your Lean 4 code must compile without errors and without any instances of <code>sorry</code> tactics.</p>
          <p style={{ marginTop: 12 }}>Contributions may be written by AI, human, or the collaboration of both.</p>
          <div className="code-block">
            <span className="comment">-- This is what we want to see:</span>
            <br />
            <span className="keyword">theorem</span> parametrized_bound (G : SimpleGraph V) : parameter G ≤ bound := <span className="keyword">by</span>
            <br />
            <span className="comment">&nbsp;&nbsp;-- Your complete proof here</span>
            <br />
            <span className="error-line">&nbsp;&nbsp;sorry</span> <span className="check">-- NOT ALLOWED</span>
          </div>
        </section>

        {/* Leaderboard */}
        <section id="leaderboard">
          <h2 className="section-heading">Leaderboard</h2>
          <div style={{ display: "flex", gap: 4, marginBottom: 16, flexWrap: "wrap" }}>
            <button
              className={`lb-tab ${activeLbTab === "all" ? "active" : ""}`}
              onClick={() => setActiveLbTab("all")}
            >
              All
            </button>
            {problems.map((p) => (
              <button
                key={p.id}
                className={`lb-tab ${activeLbTab === p.id ? "active" : ""}`}
                onClick={() => setActiveLbTab(p.id)}
              >
                {p.title}
              </button>
            ))}
          </div>
          <table className="data-table">
            <thead>
              <tr>
                <th>Rank</th>
                <th>Nickname</th>
                <th>Name</th>
                <th>Problem</th>
                <th>Result</th>
                <th>Date</th>
              </tr>
            </thead>
            <tbody>
              {lbEntries.length === 0 ? (
                <tr>
                  <td colSpan={6} style={{ textAlign: "center", color: "#888", padding: "20px" }}>
                    No submissions yet.
                  </td>
                </tr>
              ) : (
                lbEntries.map((row) => (
                  <tr key={row.rank + row.nickname + row.problem}>
                    <td>{row.rank}</td>
                    <td>{row.nickname}</td>
                    <td style={{ color: row.name ? "#000" : "#888" }}>
                      {row.name || "—"}
                    </td>
                    <td>{row.problem}</td>
                    <td>{row.result}</td>
                    <td>{row.date}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </section>

        {/* Submit */}
        <section id="submit">
          <h2 className="section-heading">Submit Your Solution</h2>
          <p style={{ fontSize: 15, color: "#333", marginBottom: 20 }}>
            Fill in the form below and click <strong>Submit on GitHub</strong>.
            That opens a pre-filled issue on the submissions repo where you
            paste the public URL of your <code>challenge_NN.lean</code> file
            (a GitHub-hosted file or a public gist). CI runs <code>lake build</code>{" "}
            against the pinned toolchain and posts the verdict back on the issue.
          </p>

          <div className="submit-section">
            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Nickname *</label>
                <input
                  className="form-input"
                  type="text"
                  name="nickname"
                  value={subNickname}
                  onChange={(e) => setSubNickname(e.target.value)}
                  placeholder="e.g. lean_enjoyer"
                />
              </div>
              <div className="form-group">
                <label className="form-label">
                  Name &amp; Surname{" "}
                  <span style={{ color: "#888", textTransform: "none", letterSpacing: 0, fontSize: 11 }}>
                    (optional)
                  </span>
                </label>
                <input
                  className="form-input"
                  type="text"
                  name="name"
                  value={subName}
                  onChange={(e) => setSubName(e.target.value)}
                  placeholder=""
                />
              </div>
            </div>

            <div className="form-row three-col">
              <div className="form-group">
                <label className="form-label">Problem *</label>
                <select
                  className="form-input"
                  name="problem"
                  value={subProblem}
                  onChange={(e) => setSubProblem(e.target.value)}
                >
                  <option value="">Select a problem...</option>
                  <optgroup label="Parametrized (choose r)">
                    {problems.map((p) => (
                      <option key={p.id} value={p.id}>{p.title}</option>
                    ))}
                  </optgroup>
                  <optgroup label="Universal (∀ r)">
                    {problems.map((p) => (
                      <option key={`${p.id}_univ`} value={`${p.id}_univ`}>
                        {p.title} (universal)
                      </option>
                    ))}
                  </optgroup>
                </select>
              </div>
              <div className="form-group">
                <label className="form-label">Claim *</label>
                <select
                  className="form-input"
                  name="claim"
                  value={subClaim}
                  onChange={(e) => setSubClaim(e.target.value)}
                >
                  <option value="">Prove or Disprove...</option>
                  <option value="prove">Prove</option>
                  <option value="disprove">Disprove</option>
                </select>
              </div>
              <div className="form-group">
                <label className="form-label">Chosen parameter *</label>
                <input
                  className="form-input"
                  type="text"
                  name="parameter"
                  value={subParameter}
                  onChange={(e) => setSubParameter(e.target.value)}
                  placeholder="e.g. 5 (or 'universal')"
                />
              </div>
            </div>

            <div style={{ display: "flex", justifyContent: "center", marginTop: 24 }}>
              <a
                className="btn"
                href={githubUrl}
                target="_blank"
                rel="noopener noreferrer"
              >
                Submit on GitHub &rarr;
              </a>
            </div>
          </div>
        </section>
      </main>

      <footer className="footer">
        <span>Parametrized Problems in Lean 4</span>
        <span>Built for the formal mathematics community</span>
      </footer>
    </>
  );
}

export default App;
