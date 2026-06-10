import Mathlib.Combinatorics.SimpleGraph.Basic
import Defs_and_Lems.Minor

/-!
# α-well-quasi-ordering (Nash–Williams hierarchy) and the minor order

Shared by `challenge_06`, `challenge_06_univ`, and
`challenge_06_univ_disprove`.

`V*_α(Q)` is the cumulative hierarchy over a quasi-order `Q`: level `0` is
`Q` itself, and level `α + 1` consists of the nonempty subsets of level `α`
(the TeX defines `V*_α` for every ordinal, with disjoint unions at limit
stages; the challenge parameter ranges over finite ordinals, where plain
recursion suffices).

`≤*` compares two elements of the hierarchy by a game: from a position
`(X, Y)`, Player I names `X' ∈ X`, Player II answers `Y' ∈ Y`, and play
continues from `(X', Y')`; once both sides are in `Q`, Player II wins iff
`X ≤ Y`. Starting from two elements of the *same* finite level, the two
sides descend in lockstep, so the winning-strategy predicate unfolds into
the simple recursion `leStar` below.

`(Q, ≤)` is **α-well-quasi-ordered** if level `α` is well-quasi-ordered
under `≤*`. Nash–Williams: `(Q, ≤)` is a better-quasi-order iff it is
`α`-well-quasi-ordered for every countable ordinal `α`.
-/

open SimpleGraph

universe u

/-- A quasi-order is well-quasi-ordered when every infinite sequence
contains an increasing pair. -/
def IsWQO {Q : Type u} (le : Q → Q → Prop) : Prop :=
  ∀ f : ℕ → Q, ∃ i j : ℕ, i < j ∧ le (f i) (f j)

/-- Level `n` of the cumulative hierarchy over `Q`: `VStar Q 0 = Q`, and
`VStar Q (n + 1)` is the type of nonempty sets of elements of `VStar Q n`. -/
def VStar (Q : Type u) : ℕ → Type u
  | 0 => Q
  | n + 1 => {S : Set (VStar Q n) // S.Nonempty}

/-- The Nash–Williams relation `≤*` on level `n` of the hierarchy, in its
backward-induction form: at level `0` it is `le` itself, and
`X ≤* Y` at level `n + 1` iff for every Player I move `x ∈ X` Player II has
an answer `y ∈ Y` with `x ≤* y` at level `n`. -/
def leStar {Q : Type u} (le : Q → Q → Prop) : ∀ n, VStar Q n → VStar Q n → Prop
  | 0 => le
  | n + 1 => fun X Y => ∀ x ∈ X.val, ∃ y ∈ Y.val, leStar le n x y

/-- `(Q, le)` is `α`-well-quasi-ordered when level `α` of the cumulative
hierarchy over `Q` is well-quasi-ordered under `≤*`. -/
def IsAlphaWQO {Q : Type u} (le : Q → Q → Prop) (a : ℕ) : Prop :=
  IsWQO (leStar le a)

theorem leStar_zero {Q : Type u} (le : Q → Q → Prop) : leStar le 0 = le := rfl

theorem leStar_refl {Q : Type u} {le : Q → Q → Prop} (hle : ∀ a, le a a) :
    ∀ n (X : VStar Q n), leStar le n X X := by
  intro n
  induction n with
  | zero => exact hle
  | succ k ih =>
    intro X x hx
    exact ⟨x, hx, ih x⟩

/-- `0`-well-quasi-ordering is well-quasi-ordering of `(Q, le)` itself. -/
theorem isAlphaWQO_zero_iff {Q : Type u} (le : Q → Q → Prop) :
    IsAlphaWQO le 0 ↔ IsWQO le :=
  Iff.rfl

/-! ## Finite graphs and the minor order -/

/-- A finite simple graph, packaged with its vertex count. -/
def FiniteGraph : Type :=
  Σ n : ℕ, SimpleGraph (Fin n)

/-- The minor order on finite graphs: `MinorLE G H` when `G` is a minor of
`H`, witnessed by the shared branch-set `Minor` structure (the first
argument of `Minor` is the minor, the second the host). -/
def FiniteGraph.MinorLE (G H : FiniteGraph) : Prop :=
  Nonempty (Minor G.2 H.2)

/-- Planarity via Wagner's theorem: a finite graph is planar iff it has
neither a `K₅` nor a `K₃,₃` minor. We adopt this combinatorial
characterization as the definition. -/
def FiniteGraph.IsPlanar (G : FiniteGraph) : Prop :=
  ¬ Nonempty (Minor (completeGraph (Fin 5)) G.2) ∧
    ¬ Nonempty (Minor (completeBipartiteGraph (Fin 3) (Fin 3)) G.2)

/-- A finite planar simple graph. -/
def PlanarGraph : Type :=
  {G : FiniteGraph // G.IsPlanar}

/-- The minor order on finite planar graphs. -/
def PlanarGraph.MinorLE (G H : PlanarGraph) : Prop :=
  FiniteGraph.MinorLE G.val H.val
