#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Authors: Eric Vergo, GPT-6.2 (OpenAI)
set -euo pipefail
cd "$(dirname "$0")/.."
lake build Lib New Main Comparator.Grh.Challenge Comparator.Grh.Solution
cmp src/Main.lean Comparator/Grh/Solution.lean
lake exe vbp comparator-check
lake env lean scripts/PrintAxioms.lean > .lake/grh-axioms.txt
cat .lake/grh-axioms.txt
python3 - <<'PY'
import json, pathlib, re
names = json.loads(pathlib.Path('Comparator/Grh/comparator.json').read_text())['theorem_names']
axioms = pathlib.Path('.lake/grh-axioms.txt').read_text()
assert len(names) == len(set(names)) == 5
for name in names:
    match = re.search("^'" + re.escape(name) + r"' depends on axioms: \[([^\]]*)\]$", axioms, re.M)
    if not match or set(match[1].split(', ')) != {'propext','Quot.sound','Classical.choice'}:
        raise SystemExit('Unexpected axiom report for ' + name)
PY
lake build GrhBlueprint
VERSO_BLUEPRINT_KERNEL_REPLAY_RECORD='' lake exe vbp build
lake exe vbp check | tee .lake/grh-site-report.txt
tail -1 .lake/grh-site-report.txt | python3 -c 'import json,sys; assert json.load(sys.stdin)["ok"] is True'
site=_out/site/html-multi
node blueprint/atlas/build.mjs "$site/source"
python3 scripts/check-site.py "$site"
