/-- K₅ -/
abbrev K5 := completeGraph (Fin 5)

/-- K₃,₃ -/
abbrev K33 := completeBipartiteGraph (Fin 3) (Fin 3)

/-
Planarity via Wagner's theorem: a finite graph is planar iff it has
neither a `K₅` nor a `K₃,₃` minor.
-/
def SimpleGraph.IsWagnerPlanar [Fintype V] (G : SimpleGraph V) : Prop :=
  ¬ Nonempty (Minor K5 G) ∧ ¬ Nonempty (Minor K33 G)
