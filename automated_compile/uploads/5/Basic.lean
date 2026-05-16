/-
# Hadwiger Number Challenge

A Lean 4 formalization challenge. Fill in the sorries below.

## The Problem

The Hadwiger number `h(G)` of a graph `G` is the largest integer `t`
such that the complete graph `K_t` is a minor of `G`.

Hadwiger's Conjecture (1943): every graph with no `K_t` minor is `(t-1)`-colorable.

This file challenges you to prove a special case for `k = 2`.

## What you need to do

1. Replace `sorry` in `hadwigerNumber` with a proper definition.
2. Replace `sorry` in `hadwiger_challenge` with a complete proof.

No other `sorry` tactics are permitted in your submission.
-/

import Mathlib

-- The challenge parameter
-- We fix k = 2: prove the statement for graphs with Hadwiger number at most 2.
def k : ℕ := 2

-- Define the Hadwiger number of a graph.
-- This is the largest t such that K_t is a minor of G.
def hadwigerNumber {V : Type} [Fintype V] [DecidableEq V] (G : SimpleGraph V) : ℕ :=
  sorry

-- Challenge: Prove that every graph with Hadwiger number at most k is (k+1)-colorable.
--
-- For k = 2, this reads:
--   If the largest complete minor of G has size at most 2,
--   then G is 3-colorable.
--
-- Equivalently: a graph with no K_3 minor is 3-colorable.
-- (This is a special case of Hadwiger's conjecture.)
theorem hadwiger_challenge {V : Type} [Fintype V] [DecidableEq V] (G : SimpleGraph V) :
    hadwigerNumber G ≤ k → G.Colorable (k + 1) := by
  sorry
