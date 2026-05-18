-- Lean 4 Challenge Setup
-- This file contains example code to demonstrate successful compilation and infoview functionality.

namespace Challenges

/-- A simple greeting message -/
def hello : String := "Lean challenge setup successful!"

/-- Print the greeting to console -/
#eval IO.println hello

/-- Example theorem: simple arithmetic -/
theorem simple_add : 2 + 2 = 4 := by norm_num

/-- Example: working with natural numbers -/
def factorial : Nat → Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorial n

example : factorial 5 = 120 := by norm_num

end Challenges
