/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Main

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Theorem B. Filling the target by translates" =>

%%%
tag := "guide-spanning"
%%%

Even when individual vectors are very short, many of them can point in the same direction. The second moment measures the overlap between the image of the Poincaré map and its translates. Write $`B` for the scaled map. An overlap is measured by the squared Hilbert–Schmidt norm of `B* s B`, the sum of the squared absolute values of its matrix entries in orthonormal bases.

# Turning moments into dimension

The calculation needs a lower bound for the projected map in mean square and an upper bound for the sum of the overlaps. For this family of spaces, multiplicity comparison counts the target on a definite group with free level. Unfolding the Poincaré series expresses its matrix coefficients through local integrals. The identity contribution supplies the main term. The estimates for the other terms and for the bad local types control the loss when the two level projectors are applied. These are the inputs to `isSpread_of_second_moment`. [Moment hypotheses and their application](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Spanning/SecondMoment/SpanningTheorem.lean).

For a subspace already spanned, the moment inequality finds a translate whose preimage of that subspace is small. The rest of the translate contributes new dimensions. Repeating the selection reduces the missing dimension and incurs a logarithmic factor in the number of translates. [Finite-dimensional covering argument](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Spanning/SecondMoment/FewTranslates.lean).

:::theorem "grh-guide-spanning" (lean := "New.Data.enough_forms")
Write $`d` for target dimension and $`h` for ramified source dimension. The target has positive dimension. There is a finite set of translates of cardinality $`u` such that `u h ≤ 5 d log(1 + 2 b²)` and the sum of their image spaces has dimension at least `(1 − 4/b²) d`.
:::

Restrict each translate to the spanning family of Theorem A and choose an independent subfamily of the joint image. Its cardinality meets the threshold for Theorem C. The bound on `u h` controls the index budget even if one image overlaps many others.
