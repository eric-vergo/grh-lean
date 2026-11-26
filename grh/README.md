# The Generalized Riemann Hypothesis for Dirichlet L-functions, in Lean 4

This fork ports the readable research artifact to Lean 4.36.0 and adds a mathematical blueprint. The upstream project describes its research release as unmaintained and closed to contributions.

The proof is Levent Alpöge's, with Claude.
The upstream README credits Claude (AI) with writing its Lean text and documents. Eric Vergo and OpenAI Codex authored the blueprint chapters.

This project holds a Lean 4 proof of the Riemann Hypothesis. It also proves the Generalized Riemann Hypothesis for Dirichlet L-functions. The proof builds on Mathlib. It uses only the axioms `propext`, `Classical.choice` and `Quot.sound`.

This project is a shorter rewriting of Levent Alpöge's Lean proof (see <https://alpo.ge/remark.pdf>). It follows that proof's method; many steps are proved by other arguments, and parts of it, mostly background material, were ported from there and then rewritten.

This is the readable edition, about 300,000 lines of code. A compact edition, about 76,000 lines, is in [../grh-compact](../grh-compact/); some of its steps use other arguments.

## Read the blueprint

[Open the online blueprint](https://eric-vergo.github.io/grh-lean/) or read the chapter sources below.

1. [From zeros to a comparison of volumes](blueprint/GrhBlueprint/Parts/Orientation.lean)
2. [Theorem A. Short lifts and their denominators](blueprint/GrhBlueprint/Parts/ShortForms.lean)
3. [Theorem B. Filling the target by translates](blueprint/GrhBlueprint/Parts/Spanning.lean)
4. [Theorem C. The cost of a nearly full family](blueprint/GrhBlueprint/Parts/LongForms.lean)
5. [Comparing the two estimates](blueprint/GrhBlueprint/Parts/Cancellation.lean)
6. [The one-sided criterion and the five conclusions](blueprint/GrhBlueprint/Parts/Analytic.lean)
7. [Finding the constructions in either edition](blueprint/GrhBlueprint/Parts/Atlas.lean)

For a glossary and parameter sizes, read the [upstream guide](GUIDE.md). Use the [result index](INDEX.md) to identify the relevant formal statement and its source. The blueprint explains the mathematical route. The statements and proofs in Lean determine what the artifact establishes.

## Theorems

`src/Statements.lean` states the theorems in Mathlib's terms. `src/Main.lean` proves five theorems:
- `riemannHypothesis`: Mathlib's `RiemannHypothesis`.
- `riemannZeta_eq_zero_re`: every zero s ≠ 1 of ζ other than −2, −4, … has real part 1/2 (s = 1 is the pole).
- `LFunction_ne_zero_of_half_lt_re`: L(s, χ) ≠ 0 for re s > 1/2, except at s = 1 for the principal character of each modulus (the pole).
- `LFunction_eq_zero_re`: every zero of L(s, χ) with 0 < re s < 1 has real part 1/2.
- `LFunction_eq_zero_re_of_isPrimitive`: the special case of primitive χ.

All moduli N ≥ 1 and all characters are covered, primitive or not. The last three theorems say nothing about zeros with re s ≤ 0. To trust the result, read `src/Statements.lean`, which imports only Mathlib, the five statements in `src/Main.lean`, and the list of axioms, and build or replay the files. All other definitions occur only inside the proof.

## Build

Run these commands in the readable edition directory. The toolchain is Lean v4.36.0. The manifest pins Mathlib and the blueprint dependencies. [Port details](PORT.md).

```sh
lake exe cache get
lake build
lake env lean scripts/PrintAxioms.lean
```

To build and validate the full blueprint and source atlas, run `./scripts/check-blueprint.sh` in this directory. It checks the five challenge declarations against the solution mirror, checks the reported axioms, renders the site, and validates its output. Open `_out/site/html-multi/index.html` after a successful run. [Local verification script](scripts/check-blueprint.sh).

## Checks

**Upstream Lean 4.35.0.** The authors report that both editions compiled and each public theorem used `propext`, `Classical.choice` and `Quot.sound`. For the readable edition, nanoda, con-leche and con-ron accepted an export containing the five theorems and their transitive dependencies, including Mathlib. For the compact edition, the authors replayed every project module through Lean’s kernel. They also ran Comparator v4.35.0 separately on both editions on Linux with a stand-in for its sandbox. The authors say no mathematician has read the proof through. [Readable verification report](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/README.md#checks) and [compact verification report](../grh-compact/README.md#checks).

**This fork’s Lean 4.36.0 checks.** The readable edition compiled locally. Lean reported exactly `propext`, `Classical.choice` and `Quot.sound` for each of the five theorems in canonical `Main`. In a separate local run, three kernel checkers accepted the same export of the five canonical theorems and their transitive dependencies. Con-leche and con-ron each reported 216,488 accepted declarations. With the three permitted axioms on its allowlist, nanoda reported 222,058 declarations checked, zero typechecker errors and exit code 0. Its pretty printer separately reported “Unable to print axioms”. The export’s SHA-256 is `74f65b8109559a26f2e6b8dc07919a9cf805c437ce3900c7c0565bc4833dd85c`. [Port verification details](PORT.md).

The blueprint’s Project Stats page reports five theorem-by-theorem comparisons with the challenge and the result of a fresh kernel replay covering the declarations attached to blueprint nodes and the theorem roots. The workflow also provides an optional Linux job that runs sandboxed Comparator with nanoda. [Project Stats](https://eric-vergo.github.io/grh-lean/Project-Stats/) · [Site verification script](scripts/check-blueprint.sh) · [Workflow](../.github/workflows/grh-blueprint.yml).

In this fork the [challenge](Comparator/Grh/Challenge.lean) fixes the five public statements. The [solution mirror](Comparator/Grh/Solution.lean) represents the declarations from [Main](src/Main.lean) for the comparator and blueprint. The challenge contains placeholders by design. The blueprint imports the solution.

## Layout
About 300,000 lines of code; 433,000 non-blank lines with comments; 477,000 lines in all.
- `src/Lib` (495 files): background results, classed as known in the literature, that Mathlib lacks, with the steps of their proofs. It imports nothing from `src/New`.
- `src/New` (306 files): the set-up and the steps of the argument, in folders that follow its order. The main inequality is in `src/New/Reduction/MainInequality.lean`, the theorem in half-plane form in `src/New/Reduction/OneSidedBound.lean`.
- `src/Lib/Speed.lean` holds the main settings that apply to the whole development (instance priorities, `simp` lemmas taken out of the default set, one added `simp` lemma). With the file emptied, everything still compiled on Lean 4.33.1. `GUIDE.md` explains them.
- `GUIDE.md`: start here. It gives the reading order, a glossary, sizes and conventions. `CONTENTS.md`: every file with its title. `INDEX.md`: the results, with sources or related work and files.
- `REFERENCES.md` lists the citations and says which were compared with their sources.

## Acknowledgements
We thank the colleagues at Anthropic whose direction and suggestions shaped this rewriting.

## License
Apache 2.0; see `LICENSE`, `NOTICE` and `ATTRIBUTION.md`. The project depends on Mathlib (Apache 2.0), which it does not include; some declarations are adapted from it.
