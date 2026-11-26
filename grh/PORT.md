# Lean 4.36 port

The readable proof comes from [lsernau/grh-lean at 72fead1](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh). The upstream source uses Lean 4.35.0 and Mathlib commit `56a005855ea17e0b0958f73ec801ae140b0a1679`. The upstream authors and contributors are credited in [NOTICE](NOTICE) and [ATTRIBUTION.md](ATTRIBUTION.md).

This edition uses Lean 4.36.0 and Mathlib v4.36.0 at `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`. Its blueprint uses the [eric-vergo fork of Verso Blueprint](https://github.com/eric-vergo/verso-blueprint/tree/11afe5e30105914a412551f4e0c042710345c459). The package manifest records the precise revisions of the dependencies.

To inspect the changes to the proof against upstream, run the following command from the repository root.

```sh
git diff 72fead1 -- grh/src
```
