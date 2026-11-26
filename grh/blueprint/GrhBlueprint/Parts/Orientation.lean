/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Main

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "From zeros to a comparison of volumes" =>

%%%
tag := "guide-orientation"
%%%

A Dirichlet character assigns periodic multiplicative weights to integers. Its L-function initially sums those weights divided by powers of the integers. The question concerns the zeros of its continuation. How can the lengths of vectors in an auxiliary space say anything about a zero? The link is a weighted count of prime powers. A hypothetical zero contributes a pole to a transform of the error in that count. The geometric argument limits how positive the error can be. The analytic argument shows that a zero strictly to the right of the critical line is incompatible with this limit.

# The arithmetic encoded in a derivative

Fix an auxiliary modulus divisible by 18480 and a prime in the prescribed residue class. Write the smoothing weight at an integer $`n` as `1/n − 1/x` for $`n` at most $`x`. Here and below the letters designate the quantities in the readable edition. Multiply this weight by the von Mangoldt weight (logarithm of the underlying prime at prime powers, zero otherwise), by `1 − χ_K(n)`, and by the indicator of the class 1 modulo the modulus. Removing an explicit logarithm and a constant gives the remainder. For an unramified inert prime the quadratic character on its odd powers is −1. The same distinction between splitting and inertia enters the divisibility of derivatives of theta functions. This is where a count of prime powers becomes visible inside an estimate of sizes.

# The two routes through the spaces

The data choose a CM field (a totally imaginary quadratic extension of a totally real field), weights at its infinite places and levels for the automorphic forms. The source consists of ramified forms on a definite unitary group of rank $`k`. A Poincaré series sends source forms to forms on a space of rank $`r`. A projection, denoted by `e₀`, keeps the good part at the level primes. Its image in the principal-level forms is the target. A chain of $`m` theta lifts then maps the target into forms of rank `r + mt`. On a second route a source form travels through definite spaces, with a final restriction to the space of that same rank. A seesaw identity relates these routes. It permits estimates on definite spaces to control lifts from the target.

Theorem A constructs integral generators whose normalized images have short lifts. Theorem B supplies enough independent images to approach the full target dimension. Theorem C limits how small the volume of so many lifted vectors can be if their finite-place denominators are controlled. Both estimates contain a large deterministic contribution. Subtraction leaves a multiple of the arithmetic remainder. The number of lifts lies between the square root of $`x` and twice that square root, producing the exponent needed in the analytic criterion.

# What the text checks

The Lean declarations attached to theorem panels are the formal statements. The surrounding explanations, including the interpretation of their mathematics, are editorial prose by Eric Vergo and OpenAI Codex. The upstream project credits the original proof to Levent Alpöge with Claude. Luke Sernau describes the shorter rewriting as a collaboration with his Anthropic colleagues and Claude. The edition README credits Claude with writing its Lean text and documents. The upstream notice credits Anthropic, PBC and identifies adaptations from Mathlib. The upstream README reports machine checks and says that no mathematician has read the proof through. [Upstream account](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/README.md) and [edition credits](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/README.md).
