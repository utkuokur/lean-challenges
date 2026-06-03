export interface Problem {
  id: string;
  title: string;
  largestParameterKnown: string;
  pdfPath: string;
}

export const problems: Problem[] = [
  {
    id: "challenge_1",
    title: "The Hadwiger Conjecture",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_01.pdf",
  },
  {
    id: "challenge_2",
    title: "Excluded Minors of GF(pʳ)-representable matroids",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_02.pdf",
  },
  {
    id: "challenge_3",
    title: "Ramsey Numbers",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_03.pdf",
  },
  {
    id: "challenge_4",
    title: "Sidorenko Conjecture for Half-Graphs",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_04.pdf",
  },
  {
    id: "challenge_5",
    title: "Erdős–Hajnal Conjecture",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_05.pdf",
  },
  {
    id: "challenge_6",
    title: "Better-Quasi-Ordering of Finite Graphs under Minor Relation",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_06.pdf",
  },
  {
    id: "challenge_7",
    title: "Rota's Basis Conjecture",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_07.pdf",
  },
  {
    id: "challenge_8",
    title: "Ryser's Hypergraph Conjecture",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_08.pdf",
  },
  {
    id: "challenge_9",
    title: "Union-Closed Sets Conjecture",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_09.pdf",
  },
  {
    id: "challenge_10",
    title: "The Unfriendly Partition Conjecture",
    largestParameterKnown: "r = 1",
    pdfPath: "content/pdf/challenge_10.pdf",
  },
];
