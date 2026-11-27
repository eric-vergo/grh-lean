/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import New.Reduction.OneSidedBound

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Comparing the two estimates" =>

%%%
htmlSplit := .never
tag := "guide-cancellation"
%%%

Take the independent family selected using Theorems A and B. Let $`n` be its size and $`d` the target dimension. Hadamard’s determinant inequality bounds a Gram determinant by the product of its diagonal entries. After taking logarithms the short-vector bound therefore pays once per vector. The index pays once per translate times the source dimension. These are exactly the two quantities bounded in Theorem B.

# Where the main amount goes

The main amount itself is `m k directionAmount`. The direction amount sums, over infinite places, the archimedean cost of a derivative at the local weight less the corresponding guaranteed prime divisibility. The product by `k` counts the source-rank contribution at each of the `m` steps. The term is at least `x⁴ f a`, so losing it inside the error would overwhelm the desired bound. [Main amount and its sign](/source/New.Reduction.PrimeSums.html).

The upper estimate has `n (mainAmount − m totalRemainder)` as its leading term. The lower estimate has `d mainAmount`. Since $`n` is at most $`d` and the main amount is nonnegative, the difference of these main contributions has the favorable sign. The lower bound on $`n` keeps the coefficient of the remainder large. The proof absorbs the index and codimension costs into powers of the logarithm. This order of comparison matters because applying separate coarse estimates to the two occurrences of the main amount would lose the arithmetic information.

Several cancellations have already entered the short-vector estimate. The logarithm of the prime normalization offsets the guaranteed divisibilities. The period term and the expected prime sum have the same logarithmic-derivative constant at modulus one. The choice of the level prime compensates for the accumulated excess of the $`m` lifts. Subtracting the two cutoff formulas eliminates a constant depending on the progression. These cancellations are recorded individually in the head of the assembly file. [Main inequality and error accounting](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/MainInequality.lean).

:::theorem "grh-guide-star" (lean := "New.star_inequality") (uses := "grh-guide-short, grh-guide-spanning, grh-guide-long")
For every admissible datum, `m totalRemainder ≤ f a (log b)⁵`. Here $`f` counts infinite places of the CM field and `a = x b`.
:::

:::proof "grh-guide-star"
Write $`M` for the main amount, $`L=f a(\log b)^4` for the archimedean loss, and $`I` for the index allowance per target dimension. From the spanning set of short generators choose a basis of the span of their selected images. Thus the very same independent family has both the index bound $`dI` and the squared-volume bound $`n(M-mR+L)` in logarithmic units, where $`R` is the total remainder. The lower estimate gives

$`d(M-3L) \le n(M-mR+L)+2dI.`

For a concrete calculation, imagine that a family has nine independent vectors in a target of dimension ten. Rearranging would give $`9mR \le -M+39L+20I`. The missing tenth vector contributes a *negative* copy of the large main term. In general $`n(M+L)\le d(M+L)`, so the proof obtains $`n mR\le d(4L+2I)`. The fill bound gives $`d\le 2n` and the target has positive dimension, permitting division. Finally $`I=10\log(1+2b^2)` times the error unit. The scale hypotheses absorb the numerical factors into the fifth power of the logarithm. [The selected basis and comparison](/source/New.Reduction.MainInequality.html#d-New.star_inequality).
:::

# Separating the two cutoffs

Write $`R` for the smoothed prime remainder, with a subscript for its progression modulus. Let `A` and `B` count the a-places and b-places. The total remainder first appears as a sum of actual derivative prime sums minus the common expected value `a (log(a/κ̄) + c₁)` over the a-places, where `κ̄` is the geometric mean of all local weights. Sorting the prime powers by residue class gives the exact identity

$`\mathrm{rem}=a\bigl(B(R_q(x)-R_q(x_1))+A R_1(x_1)\bigr).`

Divide by `a B`. Since `f = φ(q) A` and `A/B ≤ log b`, the main inequality gives the following upper bound. The sign of the last remainder is immaterial after taking absolute values. [Cutoff identity](/source/New.Reduction.PrimeSums.html).

:::theorem "grh-guide-cutoffs" (lean := "New.Data.primeRemainder_le") (uses := "grh-guide-star")
At the smaller cutoff, `R_q(x) ≤ φ(q) (log b)⁶/m + |R_q(x₁)| + log b |R₁(x₁)|`.
:::

Here the data enforce `(log b)¹⁰⁰ ≤ x`, `x^(10⁶) ≤ x₁`, and `x₁^(10⁶) ≤ b`. For the asymptotic argument the existence theorem chooses the data with further control depending on an arbitrarily small positive exponent. The prime number theorem at the larger cutoff makes its two absolute errors small. Since $`m` is at least the square root of $`x`, the first term yields a saving close to the inverse square root. For large real $`x`, the proof bounds the increase `R_q(x) − R_q(⌊x⌋)` from above by `26/x`. [Choice of scales and passage to real cutoffs](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/OneSidedBound.lean).


:::proof "grh-guide-cutoffs"
In the cutoff identity subtract the term with modulus one and divide by the positive product of $`a` and the number of b-places. This isolates the difference of the two remainders for the desired modulus. Insert the bound for the total remainder and use the ratio of place counts to bound the coefficient of the modulus-one term. Replacing the two errors at the far cutoff by their absolute values gives the stated inequality. Only the near cutoff still requires a bound with a specified sign.
:::

:::theorem "grh-pnt-far" (lean := "New.eventually_abs_primeRemainder_le")
Fix an odd prime $`d`, a positive modulus $`q` coprime to it, and a natural number $`B`. For all sufficiently large real $`y` the absolute remainder is at most $`(\log y)^{-B}`.
:::

:::proof "grh-pnt-far"
Change variables to $`v=\log y`. The integral transform of the remainder is a divided difference of the mean logarithmic derivative divided by its argument. The zero-free region controls this function near the line of real part one. A Tauberian theorem uses that control and an estimate for short increments of the remainder to give decay by any fixed inverse power of $`v`. This logarithmic bound is sufficient at the distant cutoff. For instance, if $`\log x_1\ge x^{\delta/12}`, choosing $`B\ge 24/\delta` makes the bound at most $`x^{-2}` for both moduli. [The prime number theorem](/source/New.Reduction.Zeros.PrimeNumberTheorem.html#d-New.eventually_abs_primeRemainder_le) and [its use at the far cutoff](/source/New.Reduction.OneSidedBound.html#d-New.eventually_abs_primeRemainder_exp_le).
:::
