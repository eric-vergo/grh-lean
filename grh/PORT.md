# Lean 4.36 port

The readable proof comes from [lsernau/grh-lean at 72fead1](https://github.com/lsernau/grh-lean/tree/72fead102f663d5c7a407964a13dc0cf9d977207/grh). The upstream source uses Lean 4.35.0 and Mathlib commit `56a005855ea17e0b0958f73ec801ae140b0a1679`. The upstream authors and contributors are credited in [NOTICE](NOTICE) and [ATTRIBUTION.md](ATTRIBUTION.md).

This edition uses Lean 4.36.0 and Mathlib v4.36.0 at `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`. Its blueprint uses the [eric-vergo fork of Verso Blueprint](https://github.com/eric-vergo/verso-blueprint/tree/11afe5e30105914a412551f4e0c042710345c459). The package manifest records the precise revisions of the dependencies.

To inspect the changes to the proof against upstream, run the following command from the repository root.

```sh
git diff 72fead1 -- grh/src
```

## Verification of the readable proof

The verified source is the Git tree `bd3bcd79e73dd7f29288b48378cf496197ca8fb4` at `grh/src`. On arm64 macOS, the default `lake build` succeeded with 803 project modules and 19,858 Lake jobs. The five public theorem statements in `src/Main.lean` and `src/Statements.lean` are byte-for-byte identical to the upstream files. Lean reported exactly `propext`, `Classical.choice` and `Quot.sound` for each theorem.

Lean 4.36.0 commit `611c117bfaf7b7ae1cfcf246ce6fba31e8f509e9` supplied the exporter and checkers. The exporter identified itself as lean4export 3.1.0 and produced one file containing the five theorem roots and their transitive dependencies. The proof export was 4,496,025,939 bytes in 82,519,574 newline-delimited JSON records. Its SHA-256 was `74f65b8109559a26f2e6b8dc07919a9cf805c437ce3900c7c0565bc4833dd85c`.

| Check | Result |
| --- | --- |
| con-leche, verified mode | Accepted 216,488 declarations, exit status 0 |
| con-ron, verified mode | Accepted 216,488 declarations, exit status 0 |
| nanoda, strict three-axiom allowlist | Checked 222,058 declarations with zero typechecker errors, exit status 0 |

Nanoda reported one pretty-printer error, `Unable to print axioms`. Lean’s per-theorem axiom reports and the three axiom records decoded directly from the export identify the same three names. Each checker reports its own declaration count.

The export contains 177,487 theorem records, 36,326 definitions, 2,670 inductive blocks, two opaque declarations, three axioms and four quotient records. Each inductive block groups its associated declarations. The two verified-mode checkers report that they model the `Lean.Syntax` inductive block internally and check its 30 generated records. Their reported declaration totals exclude those generated records and the four quotient records in the file.

### Reproducing the verification

From `grh/`, run the build, inspect the axiom sets, then export the same five declarations.

```sh
lake build
lake env lean scripts/PrintAxioms.lean
mkdir -p .lake/main-kernels
export_file="$PWD/.lake/main-kernels/Main.ndjson"
lake env leanexport Main -- \
  riemannHypothesis riemannZeta_eq_zero_re LFunction_ne_zero_of_half_lt_re \
  LFunction_eq_zero_re LFunction_eq_zero_re_of_isPrimitive > "$export_file"
wc -lc < "$export_file"
shasum -a 256 "$export_file"
```

The following commands use the checker binaries in the active Lean toolchain. The local run used a soft stack limit equal to the operating system's hard stack limit in each checker subprocess.

```sh
checker_bin="$(lean --print-prefix)/bin"
(ulimit -S -s "$(ulimit -H -s)" && "$checker_bin/con-leche" --verified --jobs=2 "$export_file")
(ulimit -S -s "$(ulimit -H -s)" && "$checker_bin/con-ron" --verified --jobs=2 "$export_file")
```

For nanoda, the config below enables the natural-number and string kernel extensions and rejects any axiom outside the three-name allowlist. The Python command writes the absolute export path into the JSON config.

```sh
python3 - "$export_file" > .lake/main-kernels/nanoda.json <<'PY'
import json
import sys

print(json.dumps({
    "export_file_path": sys.argv[1],
    "permitted_axioms": ["propext", "Quot.sound", "Classical.choice"],
    "unpermitted_axiom_hard_error": True,
    "nat_extension": True,
    "string_extension": True,
    "print_success_message": True,
}))
PY
(ulimit -S -s "$(ulimit -H -s)" && "$checker_bin/nanoda_bin" .lake/main-kernels/nanoda.json)
```

| Local macOS arm64 executable | SHA-256 |
| --- | --- |
| leanexport | `f636fac376b5e32381aa32aa90e4a51e4092176b2a9ad28bc7d7c74d61237897` |
| con-leche | `58dec62973c706787b42834f720f00b969f9862948bfc2b7ae6582e5fcb36c63` |
| con-ron | `7465bff67f9fdb1313bae4ad3cd32a876b8271bd09143e28c78ed452649fa6b3` |
| nanoda_bin | `85daddc584afe0d8fa28e18d4c566219bc3c8ddd8b0d43b90285a8f5b35faf2c` |
