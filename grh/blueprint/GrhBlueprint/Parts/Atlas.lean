/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Comparator.Grh.Solution

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Finding the constructions in either edition" =>

%%%
tag := "guide-atlas"
%%%

# Readable edition

Start at `Statements` for the Mathlib propositions. Follow `New.Reduction` for parameters, admissible data, heights, the prime sums and the final comparison. The admissible-data record collects hypotheses for an individual comparison. Its existence theorem constructs such records as the cutoff varies. This separation lets the geometric estimates use explicit inequalities and leaves the asymptotic quantifiers to the analytic reduction.

For Theorem A, `New.Derivatives` treats the formal group expansion, the integral vacuum, the divisibility of derivatives and sharpness. `New.UpperBound` constructs the kernels, source and target, the two lift routes, their seesaw identity and local and complex estimates. For Theorem B, `New.Spanning` organizes the second moment, multiplicities, Bessel functions, unfolding and the estimates for the main and remaining terms. For Theorem C, `New.Determinant` constructs the exchange squares, chain volume and auxiliary forms. `New.OneLift` bounds each single-lift determinant. `New.Congruences` supplies the regular twists through Galois representations, first-order congruences, Selmer bounds and local crystalline lifting. `New.Appendix` supplies discrete series with a large gap. [Readable guide and glossary](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/GUIDE.md).

The background in `Lib` imports independently of `New`. The Weil representation and Siegel–Weil identities enter theta integrals. Adelic integration, trace formulas and discrete series enter the spectral counts. CM periods enter derivative sizes. Class field theory, cohomology, Shimura varieties and local p-adic comparison enter the construction and local control of the Galois representations. Read each local statement with its stated strength. In particular, attachment in this library compares Hecke data on a specified filter of Frobenius elements, and a local polynomial may be an annihilating polynomial. The analytic background supplies the prime number theorem, selection of a quadratic twist and the polar-transform argument. [Results index](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/INDEX.md).

# Reading the compact edition

Both projects expose the same five theorem names and types. The compact edition groups the interfaces of A and B in `New.Endgame.ShortAndEnough`, calling A `Data.short_forms`. Theorem C is in `New.Endgame.LongForms`. The main comparison is in `New.Main`. For the analytic conclusion follow `New.Endgame.PrimeError` and `New.Endgame.OneSidedCriterion`. For the constructions behind A follow `Curve`, `Columns`, `TwistedHecke`, `Core` and `Seesaw`. For B start with `Filling`, `RealPlace` and `DiscreteSeries`. For C follow `Rows`, `Exchange`, `Trace`, `Heights` and the twisting developments `Selmer`, `Patching` and `Lift`. These names denote subtrees under the compact project's `src/New`.

The dictionary changes with the definitions. The progression modulus is called `N₀` in the compact guide. Its rows are good forms on the indefinite group and its columns are forms on the definite group. In the readable data `a = x b`. In the compact construction $`a` is the least multiple of the auxiliary cyclotomic order `N₁` at least `x b`. Compare the theorem interfaces first and then consult the corresponding local construction. The upstream authors explicitly report that some intermediate arguments differ. [Compact reading guide](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact/GUIDE.md) and [compact endgame](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact/src/New/Endgame).

# Comparing an interface directly

Compact Theorem A packages the normalization as an existence statement. It chooses a positive rational scalar and a map equal to that scalar times the projected Poincaré map, then gives both the short generating family and its index bound. Compact Theorem B states that both the column dimension and the row dimension are positive. Its translate budget is `5 rowDim log(1 + b²)` measured against the full column dimension. The readable theorem uses `5 targetDim log(1 + 2 b²)` against the dimension of the ramified source. Both conclusions fill at least the fraction `1 − 4/b²`. [Compact A and B](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact/src/New/Endgame/ShortAndEnough.lean).

In compact C the proof multiplies two height estimates, one for the volume of the rows and one for a squared volume ratio. Their determinant factors multiply to one, whose height is nonnegative. The compact assembly writes the resulting bound as `m remainder ≤ (log b)² budget`. Match `budget` with the scale `f a (log b)³` before comparing it with the readable inequality. [Compact C](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact/src/New/Endgame/LongForms.lean) and [compact comparison](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh-compact/src/New/Main.lean).

# Checking a claim

For a mathematical assertion, compare the panel with its Lean type, then follow its definitions and hypotheses. For the public claims, the edition supplies an axiom-printing script and comparator instructions. Upstream reports the three axioms `propext`, `Classical.choice` and `Quot.sound`. The bibliography separately records whether a source was compared, whether a location was confirmed second-hand, or whether only the work was located. It does not certify every cited correspondence. [Reference audit](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/REFERENCES.md) and [edition build and check instructions](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/README.md).
