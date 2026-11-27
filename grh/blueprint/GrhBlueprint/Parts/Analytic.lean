/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Comparator.Grh.Solution

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "The one-sided criterion and the five conclusions" =>

%%%
htmlSplit := .never
tag := "guide-analytic"
%%%

The volume comparison controlled a weighted count of prime powers at particular integer cutoffs. To say anything about a given L-function, we need an estimate at every sufficiently large real cutoff and a way of isolating the zeros of that character from the zeros of its quadratic twists. We pass first to real cutoffs, then calculate the residues that a hypothetical zero would produce. The example at modulus five traces the contradiction for one proposed zero. Reflection gives the remaining conclusions about the critical strip.

:::theorem "grh-guide-error" (lean := "New.eventually_primeRemainder_le_rpow") (uses := "grh-guide-cutoffs, grh-pnt-far")
For each positive modulus $`q_0` divisible by 18480 and each prime $`d\equiv q_0/2-1\pmod{q_0}`, and for every positive $`ε`, the remainder is eventually at most `x^(−1/2 + ε)`. The threshold can depend on these choices.
:::

:::proof "grh-guide-error"
Choose a small auxiliary exponent $`\delta` below one hundredth with $`7\delta\le\varepsilon`. At each sufficiently large integer the constructed data have $`m\ge\sqrt{x}`, $`\log b\le 2x^\delta`, and $`\log x_1\ge x^{\delta/12}`. Substitution in the cutoff inequality makes the near-cutoff term at most a constant times $`x^{-1/2+6\delta}`, with smaller errors from the far cutoff. For a real argument use its integer part and the one-sided increment bound. The remaining factor $`x^\delta` eventually absorbs the constants. [Integer estimate and extension to real arguments](/source/New.Reduction.OneSidedBound.html#d-New.eventually_primeRemainder_le_rpow).
:::

# Why an upper bound suffices

:::theorem "grh-polar-transform" (lean := "New.isPolar_primeRemainder")
For a prime $`d\equiv7\pmod8` and a positive modulus coprime to it, the polar transform of the logarithmically reparametrized remainder records the difference between the orders of the untwisted and quadratically twisted L-functions. Away from zero and one the normalizing denominator is $`\varphi(q)s(1-s)`.
:::

:::proof "grh-polar-transform"
Character orthogonality selects the progression. The logarithmic derivative converts the contribution of a prime power to its von Mangoldt weight, and the quadratic factor gives the difference of the ordinary and twisted character sums. Integrate the smoothing weight first where the series converges absolutely. This gives a quotient of meromorphic functions and hence continuation. Near a zero of order $`k` the logarithmic derivative has a simple pole of residue $`k`. The subtracted centering constant removes the apparent singularity at one. [Transform and residue calculation](/source/New.Reduction.Zeros.PrimeError.html#d-New.isPolar_primeRemainder).
:::


Suppose a character has a zero $`ρ` with real part greater than one half and $`ρ` differs from one. Choose a real number $`β` strictly between one half and the real part of $`ρ`. A zero-density argument chooses an auxiliary prime whose quadratic twists have no zero in the rectangle needed for this particular $`ρ`. Such a choice is possible because the remainder estimate holds for every prime in the specified class.

Transform the error after setting `x = exp(v)`. Its Laplace integral with factor `exp((1−s)v)` has a meromorphic continuation in the right half-plane. The untwisted character zeros contribute orders of vanishing to the residue, and twisted character zeros would subtract orders. In the chosen rectangle the latter contributions vanish. At a real candidate pole between $`β` and one the residue has nonnegative sign. Landau’s one-sided argument applies to the polar transform, using the upper bound with exponent `β − 1` and the real-residue sign. It forces the residue at $`ρ` to vanish. Its numerator there counts the orders of the untwisted zeros, including the assumed one. This gives the contradiction. [Criterion with exact hypotheses and residue argument](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/Zeros/Criterion.lean).

:::theorem "grh-zero-free-criterion" (lean := "New.LFunction_ne_zero_of_primeRemainder_le") (uses := "grh-polar-transform")
Let the positive modulus be divisible by eight. Fix a residue class coprime to it and congruent to seven modulo eight, and fix $`\beta>1/2`. Suppose that for each prime in this class the corresponding remainder is eventually at most $`x^{\beta-1}`. Then every character of this modulus is nonvanishing at every point other than one with real part strictly greater than $`\beta`.
:::

:::proof "grh-zero-free-criterion"
The choice of twist may depend on the proposed zero, including its height. The zero-density estimate supplies one prime in the class that removes every twisted zero in the closed region used by the proof. The bound is available for that prime because the hypothesis was quantified over them all. At the proposed point the residue numerator therefore sums the orders of the ordinary characters. Along the real interval between the exponent and one the denominator is positive, giving the sign Landau’s lemma requires. To the right of one the numerator vanishes by known nonvanishing. The lemma forces a zero residue at the proposed point, so no summand can have positive order.
:::

:::theorem "grh-guide-half" (lean := "New.grh, LFunction_ne_zero_of_half_lt_re") (uses := "grh-guide-error, grh-zero-free-criterion")
For a positive modulus, every Dirichlet L-function is nonzero at every point with real part greater than one half, except that the principal character at one is excluded.
:::

:::proof "grh-guide-half"
First fix the proposed zero and an intermediate real part. The analytic criterion uses nonvanishing of the chosen twists to turn a difference of orders into a sum of nonnegative integers in the rectangle. At the proposed zero that sum would be positive. Landau’s lemma forces the residue to vanish, giving a contradiction. To apply the criterion at arbitrary positive modulus one must still provide an admissible auxiliary class and transfer the conclusion back to the given character.
:::

For a character of modulus $`q`, the proof induces it to modulus `18480 q` and takes the auxiliary class `9240 q − 1`. At one, the nonprincipal case uses the known nonvanishing theorem. Elsewhere in the half-plane the finite Euler-factor relation descends nonvanishing from the induced character.

# A test case for the contradiction

Consider the hypothetical point `ρ = 3/4 + 10i` and the nonprincipal quadratic character modulo five. Assume its L-function vanishes at this point. Induction to modulus `q₀ = 18480 × 5 = 92400` preserves the vanishing because it multiplies the value by finitely many Euler factors. Choose `β = 5/8`. The geometric estimate with `ε = 1/8` gives an upper bound `x^(−3/8)` for the remainder for every auxiliary prime congruent to 46199 modulo 92400. The zero-density lemma chooses one such prime for which none of the quadratic twists vanish where the real part is at least `5/8` and the absolute imaginary part is at most ten.

At the point in question the residue is `n(ρ)/(φ(92400) ρ (1−ρ))`. The denominator is nonzero. The integer numerator sums the orders of all untwisted characters at this point, so the assumed vanishing would make it at least one. On the real axis to the right of `5/8` the residues have nonnegative real part, using nonvanishing at and beyond one. The upper bound and Landau’s lemma force the residue at the proposed point to be zero. This contradicts its positive numerator. The specific point illustrates the quantifiers in the formal argument. [Polar transform](/source/New.Reduction.Zeros.PrimeError.html) and [residue criterion](/source/New.Reduction.Zeros.Criterion.html).

# Reflection and specialization

:::theorem "grh-guide-strip" (lean := "LFunction_eq_zero_re, LFunction_eq_zero_re_of_isPrimitive") (uses := "grh-guide-half")
For every positive modulus and every character, each zero in the open strip between real parts zero and one lies on the line of real part one half. The same assertion holds on restricting to primitive characters.
:::

:::proof "grh-guide-strip"
At a zero in the strip the gamma factor is nonzero. The functional equation gives a zero of the inverse character at the reflected point `1 − s`. The half-plane result forces both real parts to be at most one half, hence both equal one half. The primitive theorem restricts this conclusion to primitive characters.
:::

:::theorem "grh-guide-zeta" (lean := "riemannHypothesis, riemannZeta_eq_zero_re") (uses := "grh-guide-half")
Mathlib’s Riemann hypothesis holds. In explicit form every zero of the Riemann zeta function outside one and the negative even integers has real part one half.
:::

:::proof "grh-guide-zeta"
Use the modulus-one character for zeta. Remove the gamma poles at the negative even integers and handle zero using the known value of zeta there. The completed zeta functional equation supplies the reflected zero. The explicit zeta statement and Mathlib’s proposition agree definitionally. [Public theorem signatures](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/Main.lean) and [reflection lemmas](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Main.lean).
:::

The five public declarations originate in the readable edition’s `src/Main.lean`. The blueprint imports their solution mirror, `Comparator.Grh.Solution`, so each formal panel resolves to the declarations checked against the challenge.
