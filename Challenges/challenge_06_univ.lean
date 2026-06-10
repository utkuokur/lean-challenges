import Defs_and_Lems.BQO
import Defs_and_Lems.AlphaWQO

/-!
# Better-Quasi-Ordering of Finite Graphs — Universal Statement

The graph minor theorem (Robertson–Seymour) shows that finite graphs are
well-quasi-ordered under the minor relation. The stronger conjecture is
whether they form a *better*-quasi-order (BQO).

This universal version asks for a proof or disproof of full BQO for the
class of ALL finite simple graphs (of every vertex count) under the minor
relation — the `r → ∞` limit of the parametrized ladder in
`challenge_06`.

`IsBQO` is the Nash–Williams barrier-based definition from
`Defs_and_Lems/BQO.lean`; `FiniteGraph` and its minor order come from
`Defs_and_Lems/AlphaWQO.lean`.
-/

/- Import this module from your submission to reuse the definitions above — don't copy them. -/

/-- BQO of finite graphs of all sizes under the minor relation. -/
theorem challenge_6 : IsBQO FiniteGraph.MinorLE := sorry
