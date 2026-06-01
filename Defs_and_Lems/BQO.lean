import Mathlib.Data.List.Sort
import Mathlib.Order.Monotone.Basic

/-!
# Better-Quasi-Ordering (Nash–Williams)

A *better-quasi-order* (BQO) is a strengthening of WQO. Whereas WQO forbids
bad **sequences** `ℕ → α`, BQO forbids bad **arrays**: maps from a *barrier*
into `α`, compared along the Nash–Williams shift relation.

We model a barrier as a prefix-free family of strictly increasing finite
sequences of naturals (`List ℕ`) that meets every infinite subset of `ℕ`.
Using `ℕ` as the base set is the standard "barrier on `ℕ`" presentation; it
is equivalent to the general definition over arbitrary infinite base sets,
since any barrier relativizes along the increasing enumeration of its union.
For the same reason we take *fronts* (prefix-free) rather than the stronger
*barriers* (also subset-free): the induced notion of BQO is the same.

References: Nash–Williams (1965), Simpson, "BQO theory".
-/

namespace BQO

/-- The length-`n` initial segment of the infinite subset of `ℕ` enumerated
by a strictly monotone `f`, i.e. `[f 0, f 1, …, f (n-1)]`. -/
def initSeg (f : ℕ → ℕ) (n : ℕ) : List ℕ := (List.range n).map f

/-- A *barrier* (front) on `ℕ`: a prefix-free family of nonempty, strictly
increasing finite sequences such that every infinite subset of `ℕ` has an
initial segment in the family. -/
structure IsBarrier (B : Set (List ℕ)) : Prop where
  /-- Every block is nonempty. -/
  nonempty_mem : ∀ s ∈ B, s ≠ []
  /-- Every block is strictly increasing. -/
  sorted_mem : ∀ s ∈ B, s.Pairwise (· < ·)
  /-- Every infinite subset of `ℕ` (given by its increasing enumeration `f`)
  has an initial segment in `B`. -/
  cover : ∀ f : ℕ → ℕ, StrictMono f → ∃ n, 0 < n ∧ initSeg f n ∈ B
  /-- No block is a proper initial segment of another (prefix-free). -/
  prefixFree : ∀ s ∈ B, ∀ t ∈ B, s <+: t → s = t

/-- The Nash–Williams **shift** relation. `Shift s t` holds when, writing
`s = a :: s'`, the blocks `s` and `t` sit on a common increasing sequence with
`t` continuing `s` after dropping its first element `a` (so `s'` and `t` are
prefix-comparable and every element of `t` exceeds `a`). -/
def Shift (s t : List ℕ) : Prop :=
  ∃ a s', s = a :: s' ∧ (s' <+: t ∨ t <+: s') ∧ ∀ x ∈ t, a < x

/-- An *array* `f : List ℕ → α` on a barrier `B` is **good** if some
shift-related pair of blocks is comparable: there are `s, t ∈ B` with
`Shift s t` and `le (f s) (f t)`. Otherwise it is *bad*. -/
def IsGood {α : Type*} (le : α → α → Prop) (B : Set (List ℕ))
    (f : List ℕ → α) : Prop :=
  ∃ s ∈ B, ∃ t ∈ B, Shift s t ∧ le (f s) (f t)

end BQO

/-- A quasi-order `le` is **better-quasi-ordered (BQO)** if every array from
every barrier into it is good. This is strictly stronger than WQO. -/
def IsBQO {α : Type*} (le : α → α → Prop) : Prop :=
  ∀ B : Set (List ℕ), BQO.IsBarrier B → ∀ f : List ℕ → α, BQO.IsGood le B f
