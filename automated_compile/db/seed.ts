import { getDb } from "../api/queries/connection";
import { submissions } from "./schema";

async function seed() {
  const db = getDb();

  // Check if there's already data
  const existing = await db.select().from(submissions);
  if (existing.length > 0) {
    console.log("Database already seeded.");
    return;
  }

  const sampleSubmissions = [
    {
      nickname: "alice_prover",
      name: "Alice Smith",
      problemId: "challenge_1",
      problemTitle: "Hadwiger Number",
      claim: "prove" as const,
      parameter: "r = 2",
      status: "accepted",
      resultMessage: "Submission verified: no sorry found, theorem statement preserved.",
      fileNames: "challenge_1.lean, GraphMinor.lean",
    },
    {
      nickname: "graph_formalist",
      name: null,
      problemId: "challenge_3",
      problemTitle: "Ramsey Numbers",
      claim: "disprove" as const,
      parameter: "r = 2",
      status: "accepted",
      resultMessage: "Submission verified: no sorry found, theorem statement preserved.",
      fileNames: "challenge_1.lean",
    },
    {
      nickname: "bob_prover",
      name: "Bob Chen",
      problemId: "challenge_5",
      problemTitle: "Erdos-Hajnal Conjecture",
      claim: "prove" as const,
      parameter: "r = 3",
      status: "accepted",
      resultMessage: "Submission verified: no sorry found, theorem statement preserved.",
      fileNames: "challenge_1.lean, Lemmas.lean, InducedSubgraph.lean",
    },
    {
      nickname: "matroid_fan",
      name: null,
      problemId: "challenge_8",
      problemTitle: "Rota's Basis Conjecture",
      claim: "prove" as const,
      parameter: "r = 2",
      status: "accepted",
      resultMessage: "Submission verified: no sorry found, theorem statement preserved.",
      fileNames: "challenge_1.lean, MatroidLemmas.lean",
    },
    {
      nickname: "combinator",
      name: "Eva Kowalska",
      problemId: "challenge_10",
      problemTitle: "Union-Closed Sets Conjecture",
      claim: "disprove" as const,
      parameter: "r = 3",
      status: "accepted",
      resultMessage: "Submission verified: no sorry found, theorem statement preserved.",
      fileNames: "challenge_1.lean, SetFamily.lean, Counterexample.lean",
    },
  ];

  for (const sub of sampleSubmissions) {
    await db.insert(submissions).values(sub);
  }

  console.log(`Seeded ${sampleSubmissions.length} sample submissions.`);
}

seed().catch(console.error);
