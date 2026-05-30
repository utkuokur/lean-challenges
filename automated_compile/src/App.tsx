import { useState, useRef, useCallback } from "react";
import { trpc } from "@/providers/trpc";
import { problems, type Problem } from "@/data/problems";

function App() {
  const [openProblemId, setOpenProblemId] = useState<string | null>(null);
  const [activeLbTab, setActiveLbTab] = useState("all");
  const [selectedProblem, setSelectedProblem] = useState<Problem | null>(null);
  const [selectedFiles, setSelectedFiles] = useState<File[]>([]);
  const [submitResult, setSubmitResult] = useState<{
    status: string;
    message: string;
  } | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const dropAreaRef = useRef<HTMLDivElement>(null);

  // tRPC
  const utils = trpc.useUtils();
  const { data: submissions } = trpc.submission.list.useQuery(
    activeLbTab === "all" ? undefined : { problemId: activeLbTab }
  );
  const createSubmission = trpc.submission.create.useMutation({
    onSuccess: () => {
      utils.submission.list.invalidate();
    },
  });

  const toggleProblem = (id: string) => {
    setOpenProblemId((prev) => (prev === id ? null : id));
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []).filter((f) =>
      f.name.endsWith(".lean")
    );
    setSelectedFiles((prev) => {
      const existing = new Set(prev.map((f) => f.name));
      const newFiles = files.filter((f) => !existing.has(f.name));
      return [...prev, ...newFiles];
    });
  };

  const removeFile = (index: number) => {
    setSelectedFiles((prev) => prev.filter((_, i) => i !== index));
  };

  const readFileAsBase64 = (file: File): Promise<string> => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => {
        const result = reader.result as string;
        const base64 = result.split(",")[1];
        resolve(base64);
      };
      reader.onerror = reject;
      reader.readAsDataURL(file);
    });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setSubmitResult(null);

    const form = e.currentTarget;
    const formData = new FormData(form);
    const nickname = (formData.get("nickname") as string)?.trim();
    const name = (formData.get("name") as string)?.trim();
    const problemId = formData.get("problem") as string;
    const claim = formData.get("claim") as string;
    const parameter = (formData.get("parameter") as string)?.trim();

    if (!nickname) {
      setSubmitResult({ status: "rejected", message: "Please enter a nickname." });
      return;
    }
    if (!problemId) {
      setSubmitResult({ status: "rejected", message: "Please select a problem." });
      return;
    }
    if (!claim) {
      setSubmitResult({ status: "rejected", message: "Please select Prove or Disprove." });
      return;
    }
    if (!parameter) {
      setSubmitResult({ status: "rejected", message: "Please enter the chosen parameter." });
      return;
    }
    if (selectedFiles.length === 0) {
      setSubmitResult({ status: "rejected", message: "Please upload at least one .lean file." });
      return;
    }

    const hasChallengeFile = selectedFiles.some((f) => f.name === "challenge_1.lean");
    if (!hasChallengeFile) {
      setSubmitResult({
        status: "rejected",
        message: "Your submission must include a file named challenge_1.lean containing the theorem challenge_1.",
      });
      return;
    }

    const problemTitle = problems.find((p) => p.id === problemId)?.title || problemId;

    try {
      const filePromises = selectedFiles.map(async (file) => ({
        name: file.name,
        content: await readFileAsBase64(file),
      }));
      const files = await Promise.all(filePromises);

      const result = await createSubmission.mutateAsync({
        nickname,
        name: name || undefined,
        problemId,
        problemTitle,
        claim: claim as "prove" | "disprove",
        parameter,
        files,
      });

      setSubmitResult({ status: result.status, message: result.message });
      if (result.status === "submitted") {
        form.reset();
        setSelectedFiles([]);
      }
    } catch (err) {
      setSubmitResult({
        status: "rejected",
        message: "Submission failed: " + (err instanceof Error ? err.message : String(err)),
      });
    }
  };

  const handleDrop = useCallback(
    (e: React.DragEvent) => {
      e.preventDefault();
      e.stopPropagation();
      const files = Array.from(e.dataTransfer.files).filter((f) =>
        f.name.endsWith(".lean")
      );
      setSelectedFiles((prev) => {
        const existing = new Set(prev.map((f) => f.name));
        const newFiles = files.filter((f) => !existing.has(f.name));
        return [...prev, ...newFiles];
      });
      if (dropAreaRef.current) {
        dropAreaRef.current.style.borderColor = "#ccc";
      }
    },
    []
  );

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (dropAreaRef.current) {
      dropAreaRef.current.style.borderColor = "#000";
    }
  };

  const handleDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (dropAreaRef.current) {
      dropAreaRef.current.style.borderColor = "#ccc";
    }
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

  const hasChallengeFile = selectedFiles.some((f) => f.name === "challenge_1.lean");

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
          <h3 style={{ marginTop: 24, marginBottom: 12, color: "#555" }}>Parametrized Challenges</h3>
          <div>
            {problems.filter((p) => !p.isUniversal).map((p) => (
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
          <h3 style={{ marginTop: 40, marginBottom: 12, color: "#555" }}>Universal Challenges (∀r)</h3>
          <div>
            {problems.filter((p) => p.isUniversal).map((p) => (
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
                      {row.name || "\u2014"}
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
            Upload your Lean 4 files below. One file must be named <code>challenge_1.lean</code> containing the theorem <code>challenge_1</code>.
          </p>

          <div className="submit-section">
            <form onSubmit={handleSubmit}>
              <div className="form-row">
                <div className="form-group">
                  <label className="form-label">Nickname *</label>
                  <input className="form-input" type="text" name="nickname" placeholder="e.g. lean_enjoyer" required />
                </div>
                <div className="form-group">
                  <label className="form-label">Name &amp; Surname <span style={{ color: "#888", textTransform: "none", letterSpacing: 0, fontSize: 11 }}>(optional)</span></label>
                  <input className="form-input" type="text" name="name" placeholder="" />
                </div>
              </div>

              <div className="form-row three-col">
                <div className="form-group">
                  <label className="form-label">Problem *</label>
                  <select
                    className="form-input"
                    name="problem"
                    required
                    defaultValue=""
                    onChange={(e) => {
                      const found = problems.find((p) => p.id === e.target.value);
                      setSelectedProblem(found || null);
                    }}
                  >
                    <option value="">Select a problem...</option>
                    <optgroup label="Parametrized (choose r)">
                      {problems.filter((p) => !p.isUniversal).map((p) => (
                        <option key={p.id} value={p.id}>{p.title}</option>
                      ))}
                    </optgroup>
                    <optgroup label="Universal (prove/disprove for ALL r)">
                      {problems.filter((p) => p.isUniversal).map((p) => (
                        <option key={p.id} value={p.id}>{p.title}</option>
                      ))}
                    </optgroup>
                  </select>
                </div>
                <div className="form-group">
                  <label className="form-label">Claim *</label>
                  <select className="form-input" name="claim" required defaultValue="">
                    <option value="">Prove or Disprove...</option>
                    <option value="prove">Prove</option>
                    <option value="disprove">Disprove</option>
                  </select>
                </div>
                {!selectedProblem?.isUniversal && (
                  <div className="form-group">
                    <label className="form-label">Chosen parameter *</label>
                    <input className="form-input" type="text" name="parameter" placeholder="e.g. 5" required />
                  </div>
                )}
                {selectedProblem?.isUniversal && (
                  <div className="form-group">
                    <label className="form-label">Parameter</label>
                    <input className="form-input" type="text" name="parameter" value="universal" readOnly style={{ background: "#f5f5f5", color: "#888" }} />
                    <span style={{ fontSize: 11, color: "#888", fontStyle: "italic" }}>Universal statements don't need a parameter — prove or disprove for ALL r.</span>
                  </div>
                )}
              </div>

              <div className="form-group">
                <label className="form-label">Lean 4 Files *</label>
                <div
                  ref={dropAreaRef}
                  className={`file-upload-area ${selectedFiles.length > 0 ? "has-files" : ""}`}
                  onClick={() => fileInputRef.current?.click()}
                  onDrop={handleDrop}
                  onDragOver={handleDragOver}
                  onDragLeave={handleDragLeave}
                >
                  <input
                    ref={fileInputRef}
                    type="file"
                    multiple
                    accept=".lean"
                    style={{ display: "none" }}
                    onChange={handleFileSelect}
                  />
                  {selectedFiles.length === 0 ? (
                    <span style={{ fontSize: 14, color: "#555", fontFamily: '"Courier New", Courier, monospace' }}>
                      Click to select .lean files (one must be challenge_1.lean)
                    </span>
                  ) : (
                    <ul style={{ listStyle: "none", padding: 0 }}>
                      {selectedFiles.map((file, index) => (
                        <li
                          key={file.name}
                          style={{
                            display: "flex",
                            justifyContent: "space-between",
                            alignItems: "center",
                            padding: "6px 0",
                            borderBottom: "1px solid #eee",
                            fontFamily: '"Courier New", Courier, monospace',
                            fontSize: 13,
                          }}
                        >
                          <span>
                            {file.name}
                            {file.name === "challenge_1.lean" && " [challenge_1]"}{" "}
                            <span style={{ color: "#888" }}>
                              ({(file.size / 1024).toFixed(1)} KB)
                            </span>
                          </span>
                          <button
                            type="button"
                            style={{ color: "#888", cursor: "pointer", fontSize: 12, background: "none", border: "none", fontFamily: '"Courier New", Courier, monospace' }}
                            onClick={(e) => {
                              e.stopPropagation();
                              removeFile(index);
                            }}
                          >
                            [remove]
                          </button>
                        </li>
                      ))}
                      {!hasChallengeFile && (
                        <li style={{ color: "#888", fontStyle: "italic", fontFamily: '"Courier New", Courier, monospace', fontSize: 13 }}>
                          Warning: no challenge_1.lean file selected
                        </li>
                      )}
                    </ul>
                  )}
                </div>
              </div>

              <div style={{ display: "flex", gap: 12, marginTop: 24 }}>
                <button type="submit" className="btn" disabled={createSubmission.isPending}>
                  {createSubmission.isPending ? "Checking..." : "Submit Solution"}
                </button>
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => {
                    setSelectedFiles([]);
                    setSubmitResult(null);
                  }}
                >
                  Clear
                </button>
              </div>

              {submitResult && (
                <div className={`result-box ${submitResult.status === "submitted" ? "accepted" : "rejected"}`}>
                  <strong>
                    {submitResult.status === "submitted"
                      ? "\u2713 Submitted"
                      : "\u2717 Error"}
                  </strong>
                  <br />
                  {submitResult.message}
                </div>
              )}
            </form>
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
