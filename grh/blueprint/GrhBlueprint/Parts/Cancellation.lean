/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Main

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Comparing the two estimates" =>

%%%
tag := "guide-cancellation"
%%%

Take the independent family selected using Theorems A and B. Let $`n` be its size and $`d` the target dimension. Hadamard’s determinant inequality bounds a Gram determinant by the product of its diagonal entries. After taking logarithms the short-vector bound therefore pays once per vector. The index pays once per translate times the source dimension. These are exactly the two quantities bounded in Theorem B.

# Where the main amount goes

The upper estimate has `n (mainAmount − m totalRemainder)` as its leading term. The lower estimate has `d mainAmount`. Since $`n` is at most $`d` and the main amount is nonnegative, the difference of these main contributions has the favorable sign. The lower bound on $`n` keeps the coefficient of the remainder large. The proof absorbs the index and codimension costs into powers of the logarithm. This order of comparison matters because applying separate coarse estimates to the two occurrences of the main amount would lose the arithmetic information.

Several cancellations have already entered the short-vector estimate. The logarithm of the prime normalization offsets the guaranteed divisibilities. The period term and the expected prime sum have the same logarithmic-derivative constant at modulus one. The choice of the level prime compensates for the accumulated excess of the $`m` lifts. Subtracting the two cutoff formulas eliminates a constant depending on the progression. These cancellations are recorded individually in the head of the assembly file. [Main inequality and error accounting](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/MainInequality.lean).

:::theorem "grh-guide-star" (lean := "New.star_inequality") (uses := "grh-guide-short, grh-guide-spanning, grh-guide-long")
For every admissible datum, `m totalRemainder ≤ f a (log b)⁵`. Here $`f` counts infinite places of the CM field and `a = x b`.
:::

# Separating the two cutoffs

Write $`R` for the smoothed prime remainder, with a subscript for its progression modulus. The identity for the total remainder and the proportions of the two types of infinite places yield the following bound.

:::theorem "grh-guide-cutoffs" (lean := "New.Data.primeRemainder_le") (uses := "grh-guide-star")
At the smaller cutoff, `R_q(x) ≤ φ(q) (log b)⁶/m + |R_q(x₁)| + log b |R₁(x₁)|`.
:::

Here the data enforce `(log b)¹⁰⁰ ≤ x`, `x^(10⁶) ≤ x₁`, and `x₁^(10⁶) ≤ b`. For the asymptotic argument the existence theorem chooses the data with further control depending on an arbitrarily small positive exponent. The prime number theorem at the larger cutoff makes its two absolute errors small. Since $`m` is at least the square root of $`x`, the first term yields a saving close to the inverse square root. Passing from the integer part to a real cutoff costs at most `26/x` for large $`x`. [Choice of scales and passage to real cutoffs](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/OneSidedBound.lean).
