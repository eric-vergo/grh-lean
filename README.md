# GRH for Dirichlet L-functions, in Lean 4

This fork adds a mathematical blueprint and a Lean 4.36 port of the readable edition of the GRH research artifact. Start with [From zeros to a comparison of volumes](grh/blueprint/GrhBlueprint/Parts/Orientation.lean). The chapters follow the proof from short theta lifts and the spanning argument to a determinant inequality, a one-sided estimate for primes, and the five theorems about zeros. The [edition guide](grh/README.md) links the chapters and the formal statements.

The original proof is Levent Alpöge’s, with Claude. Luke Sernau describes the shorter version as a collaboration with his Anthropic colleagues and Claude. The upstream edition credits Claude with writing its Lean text and documents. Eric Vergo and OpenAI Codex authored the blueprint chapters. [Original author’s account](https://alpo.ge/remark.pdf) and [upstream repository](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207).

## Two editions

| Edition | Toolchain | Where to start |
| --- | --- | --- |
| Readable, approximately 300,000 lines of Lean code | Lean 4.36.0 and Mathlib v4.36.0 | [Blueprint and build instructions](grh/README.md) · [Port details](grh/PORT.md) |
| Compact, approximately 76,000 lines of Lean code | Original Lean 4.35.0 and Mathlib 56a00585 | [Compact reading guide](grh-compact/GUIDE.md) · [Compact build and checks](grh-compact/README.md) |

Each edition is its own Lake project. The compact edition retains its upstream source and pins. Both expose the same five theorem signatures. Some intermediate constructions and proofs differ.

## Verification and attribution

The upstream authors report machine checks for both original editions. They say that no mathematician has read the proof through and no paper accompanies this rewriting. The readable edition documents the checks for the fork separately. [Readable verification notes](grh/README.md#checks).

The upstream research artifact is distributed under Apache 2.0, copyright 2026 Anthropic, PBC. See the [license](LICENSE), [readable notices](grh/NOTICE), [readable attribution](grh/ATTRIBUTION.md), [compact notices](grh-compact/NOTICE), and [compact attribution](grh-compact/ATTRIBUTION.md).
