import Defs_and_Lems.BQO
import Defs_and_Lems.AlphaWQO

/-!
# Better-Quasi-Ordering of Finite Graphs — Universal Statement

The graph minor theorem (Robertson–Seymour) shows that finite graphs are
well-quasi-ordered under the minor relation. The stronger conjecture is
whether they form a *better*-quasi-order (BQO).

This universal version asks for a proof or disproof of full BQO for the
class of ALL finite simple graphs (of every vertex count) under the minor
relation.

`IsBQO` is the Nash–Williams barrier-based definition from
`Defs_and_Lems/BQO.lean`; `FiniteGraph` and its minor order come from
`Defs_and_Lems/AlphaWQO.lean`.  Note that the parametrized ladder in
`challenge_06` uses the finite-level `IsAlphaWQO` hierarchy; on paper BQO
implies every finite level, but that bridge (Nash–Williams theory) is not
formalized in this repository, so the two slots are formally independent
statements about the same conjecture.
-/

/-- BQO of finite graphs of all sizes under the minor relation. -/
theorem challenge_6_univ : IsBQO FiniteGraph.MinorLE := sorry
