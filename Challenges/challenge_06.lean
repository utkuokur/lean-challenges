import Defs_and_Lems.AlphaWQO

/-!
# Better-Quasi-Ordering of Finite Graphs under Minor Relation

The graph minor theorem of Robertson and Seymour shows that finite graphs
are well-quasi-ordered under the minor relation. The stronger conjecture
asks whether they form a *better*-quasi-order (BQO), which by Nash–Williams
is equivalent to being `α`-well-quasi-ordered for every countable ordinal
`α` (see `Defs_and_Lems/AlphaWQO.lean` for `VStar`, `leStar`, and
`IsAlphaWQO`).

The challenge interleaves two ladders, following the problem sheet: for
`r = 2·α` it asserts that finite *planar* graphs are `α`-well-quasi-ordered
under minors, and for `r = 2·α + 1` that *all* finite graphs are. In
particular `r = 0` is the planar graph minor theorem and `r = 1` is the
full Robertson–Seymour theorem.

## How to submit
Don't edit or copy this file. In your own `Submission/Main.lean`, write
`import Challenges.challenge_06` to reuse the definitions instead of
copying them, then state your `r` and `theorem challenge_6` inside
`namespace Submission`. See the submission guide on the website for the
full layout.
-/


/-- The challenge parameter: for `r = 2·α`, finite planar graphs are
`α`-well-quasi-ordered under the minor relation; for `r = 2·α + 1`, all
finite graphs are. -/
def r : ℕ := sorry

/-- `α`-well-quasi-ordering of finite (planar) graphs under minors, for the
chosen `r`: planar graphs at level `r / 2` when `r` is even, all finite
graphs at level `r / 2` when `r` is odd. -/
theorem challenge_6 :
    if r % 2 = 0
    then IsAlphaWQO PlanarGraph.MinorLE (r / 2)
    else IsAlphaWQO FiniteGraph.MinorLE (r / 2) := sorry
