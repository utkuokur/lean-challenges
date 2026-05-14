export interface Problem {
  id: string;
  title: string;
  shortDesc: string;
  largestParameterKnown: string;
  description: string;
  status: string;
  info: string;
}

export const problems: Problem[] = [
  {
    id: "challenge_1",
    title: "Hadwiger Number",
    shortDesc: "The largest integer t such that K_t is a minor of G. The Hadwiger Conjecture (1943) states that every graph with no K_t minor is (t-1)-colorable.",
    largestParameterKnown: "r = 1",
    description: `The Hadwiger number h(G) of a graph G is the largest integer t such that the complete graph K_t is a minor of G. It is one of the most natural measures of graph complexity.\n\nThe Hadwiger Conjecture (1943) states that every graph with no K_t minor is (t-1)-colorable — among the most famous open problems in graph theory.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Hadwiger number and Hadwiger's conjecture are not currently in Mathlib4. Participants must build all definitions from scratch.",
  },
  {
    id: "challenge_2",
    title: "Excluded Minors of GF(r)-representable matroids",
    shortDesc: "Characterize the excluded minors for representability over the finite field GF(r). A fundamental problem in matroid theory.",
    largestParameterKnown: "r = 1",
    description: `A matroid is GF(r)-representable if it can be represented by a matrix over the finite field with r elements. The excluded minors are the minimal obstructions to such representability.\n\nFor r = 2 (binary matroids), the only excluded minor is U_{2,4} (Tutte, 1958). For r = 3 (ternary matroids), the excluded minors are U_{2,5}, U_{3,5}, F_7, and F_7^* (Rado's theorem). Beyond this, the problem remains wide open.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Matroid theory is under active development in Mathlib4. Basic definitions exist, but excluded minor characterizations are not yet formalized.",
  },
  {
    id: "challenge_3",
    title: "Ramsey Numbers",
    shortDesc: "The smallest n such that every graph on n vertices contains either a clique of size s or an independent set of size t.",
    largestParameterKnown: "r = 1",
    description: `The Ramsey number R(s,t) is the smallest integer n such that every graph on n vertices contains either a clique of size s or an independent set of size t. Even R(5,5) remains unknown (bounds: 43 to 48).\n\nFor the parametrized version, one seeks exact values or tight bounds for families of Ramsey numbers.`,
    status: "Partially formalized in Mathlib4.",
    info: "Basic Ramsey theory results exist in Mathlib4, but exact computations for specific values and parametrized bounds remain open.",
  },
  {
    id: "challenge_4",
    title: "Sidorenko Conjecture for Half-Graphs",
    shortDesc: "Does every graph contain asymptotically at least as many copies of a half-graph as a random graph of the same edge density?",
    largestParameterKnown: "r = 1",
    description: `Sidorenko's conjecture states that for every bipartite graph H, the number of copies of H in any graph G is asymptotically at least the expected number in a random graph with the same edge density.\n\nThe half-graph is a specific bipartite graph that serves as an important test case. Proving or disproving Sidorenko for half-graphs would be a significant step.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Graph homomorphism counting and extremal graph theory concepts are not yet formalized in Mathlib4.",
  },
  {
    id: "challenge_5",
    title: "Erdos-Hajnal Conjecture",
    shortDesc: "For every graph H, there exists a constant c > 0 such that every graph excluding H as an induced subgraph has a clique or stable set of size n^c.",
    largestParameterKnown: "r = 1",
    description: `The Erdos-Hajnal conjecture asserts that for every fixed graph H, there exists a constant c = c(H) > 0 such that every graph on n vertices that does not contain H as an induced subgraph has either a clique or a stable set of size at least n^c.\n\nThis is known for only a handful of graphs H. The conjecture remains one of the central open problems in structural graph theory.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Induced subgraphs and the Erdos-Hajnal property are not yet in Mathlib4. Basic graph theory definitions exist as building blocks.",
  },
  {
    id: "challenge_6",
    title: "Unfriendly Partition Conjecture",
    shortDesc: "Does every countable graph admit a partition of its vertices into two sets such that each vertex has at least as many neighbors in the other set as in its own?",
    largestParameterKnown: "r = 1",
    description: `The unfriendly partition conjecture states that every countable graph admits a partition of its vertex set into two parts such that every vertex has at least as many neighbours in the other part as in its own.\n\nThis is known to hold for locally finite graphs and certain other classes, but the general countable case remains open. The uncountable case is independent of ZFC.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Partition problems in graph theory are not yet formalized. Basic neighbourhood and degree definitions exist in Mathlib4.",
  },
  {
    id: "challenge_7",
    title: "Better-Quasi-Ordering of Finite Graphs under Minor Relation",
    shortDesc: "Is the class of finite graphs better-quasi-ordered under the graph minor relation?",
    largestParameterKnown: "r = 1",
    description: `A quasi-order is a better-quasi-order (BQO) if it has no bad sequences. The graph minor theorem of Robertson and Seymour shows that finite graphs are well-quasi-ordered under minors.\n\nThe stronger question of whether they form a BQO remains open. A positive answer would have deep consequences for the logical structure of minor-closed graph classes.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Well-quasi-ordering theory is not yet formalized in Mathlib4. The graph minor theorem itself is a massive undertaking that remains open.",
  },
  {
    id: "challenge_8",
    title: "Rota's Basis Conjecture",
    shortDesc: "Given n bases in a rank-n matroid, can one always partition their union into n disjoint rainbow bases?",
    largestParameterKnown: "r = 1",
    description: `Rota's basis conjecture states that if B_1, B_2, ..., B_n are n bases of a rank-n matroid, then their multiset union can be partitioned into n disjoint rainbow bases (each containing exactly one element from each B_i).\n\nThis was proved for large n and for certain special cases, but the general conjecture was only recently settled (for large n) and the exact statement for all n remains of interest.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Matroid basis theory exists in Mathlib4 at a basic level, but Rota's conjecture and related combinatorial results are not formalized.",
  },
  {
    id: "challenge_9",
    title: "Ryser's Hypergraph Conjecture",
    shortDesc: "In every r-partite r-uniform hypergraph, the covering number is at most (r-1) times the matching number.",
    largestParameterKnown: "r = 1",
    description: `Ryser's conjecture states that in every r-partite r-uniform hypergraph, the vertex cover number tau is at most (r-1) times the matching number nu. For r=2 this is Konig's theorem. For r=3 it was proved by Aharoni (2001). The general case remains open.\n\nDisproving the conjecture for some r would also be a major result.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Hypergraph theory is largely unformalized in Mathlib4. Matching and covering results for graphs exist as foundations.",
  },
  {
    id: "challenge_10",
    title: "Union-Closed Sets Conjecture",
    shortDesc: "In any finite union-closed family of sets, some element belongs to at least half of the sets.",
    largestParameterKnown: "r = 1",
    description: `The union-closed sets conjecture (also called the Frankl conjecture) asserts that for any finite family of sets that is closed under union, there exists an element that belongs to at least half of the sets in the family.\n\nThe conjecture has been verified for families up to certain sizes, and various special cases are known. A general proof or counterexample would be a major result in extremal combinatorics.`,
    status: "Not yet formalized in Mathlib4.",
    info: "Set family combinatorics and extremal set theory are not yet formalized in Mathlib4.",
  },
];
