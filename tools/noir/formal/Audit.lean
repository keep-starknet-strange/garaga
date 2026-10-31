module

import Honk
import Lean.Util.CollectAxioms

open Lean Elab Command

-- Only Lean's standard logical foundations are permitted.
-- Compiler-trust and placeholder axioms are rejected.
run_cmd do
  let allowed := [`propext, `Classical.choice, `Quot.sound]
  let mut names := #[`Honk.conditional_math_verifier_equivalence,
    `Honk.bad_challenge_count, `Honk.uniform_failure_fraction,
    `Honk.cancelling_nonzero_residuals, `Honk.remove_identity_commitments,
    `Honk.compact_coordinate, `Honk.recursive_accumulator_equivalence]
  for index in [:31] do
    names := names.push (Name.str `Honk s!"relation_{index}")
    for sample in ["hello", "memory", "recursive", "mutator_set"] do
      names := names.push (Name.str `Honk s!"relation_{sample}_{index}")
  for name in names do
    for axiomName in (← Lean.collectAxioms name) do
      unless allowed.contains axiomName do
        throwError "Forbidden axiom {axiomName} in {name}"
  logInfo m!"Audited {names.size} theorem dependencies. No placeholder or compiler-trust axioms."
