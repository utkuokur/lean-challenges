import { useState } from "react";
import { trpc } from "@/providers/trpc";
import { problems } from "@/data/problems";

// Submissions are filed as GitHub Issues on the submissions repo
// (see api/lib/env.ts -> submissionsRepo). The link below opens the
// issue form pre-filled.
const SUBMISSIONS_REPO = "utkuokur/lean-challenges-submissions";
const NEW_ISSUE_URL = `https://github.com/${SUBMISSIONS_REPO}/issues/new?template=submit.yml`;

function App() {
  const [openProblemId, setOpenProblemId] = useState<string | null>(null);
  const [activeLbTab, setActiveLbTab] = useState("all");

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
    result: `${s.claim === "prove" ? "holds" : "fails"} for ${s.parameter}`,
    date: s.date || "",
  }));

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
          <p style={{ fontSize: 15, color: "#333", marginBottom: 16 }}>
            Submissions are filed as GitHub issues on the{" "}
            <code>{SUBMISSIONS_REPO}</code> repository. The CI fetches
            your Lean file, runs <code>lake build</code> against the pinned
            toolchain, and on success appends your entry to the leaderboard.
          </p>

          <div className="submit-section">
            <ol style={{ paddingLeft: 20, fontSize: 15, color: "#333", lineHeight: 1.7 }}>
              <li>
                Host your <code>challenge_NN.lean</code> file publicly &mdash;
                a GitHub repository or a public gist works. The file must
                contain a complete proof (no <code>sorry</code>).
              </li>
              <li>
                Open a <strong>Submit a proof</strong> issue on the
                submissions repo using the link below. The form asks for
                the URL of your file, which problem you&rsquo;re targeting,
                prove/disprove, your chosen <code>r</code>, and a nickname.
              </li>
              <li>
                Wait a few minutes for the CI to fetch and build. The bot
                comments on the issue with the result and, on success,
                you appear on the leaderboard above.
              </li>
            </ol>

            <div style={{ display: "flex", gap: 12, marginTop: 24, flexWrap: "wrap" }}>
              <a
                className="btn"
                href={NEW_ISSUE_URL}
                target="_blank"
                rel="noopener noreferrer"
              >
                Submit on GitHub &rarr;
              </a>
              <a
                className="btn btn-secondary"
                href={`https://github.com/${SUBMISSIONS_REPO}`}
                target="_blank"
                rel="noopener noreferrer"
              >
                Browse submissions repo
              </a>
            </div>

            <p style={{ fontSize: 13, color: "#888", marginTop: 16, fontStyle: "italic" }}>
              {problems.length} problems shown. The issue form's dropdown also
              includes universal (&forall;r) variants for each problem &mdash;
              pick <code>challenge_N_univ</code> there to submit a proof of the
              full conjecture.
            </p>
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
