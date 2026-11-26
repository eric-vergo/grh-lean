"""Check the published atlas, links and proof-verification results. SPDX-License-Identifier: Apache-2.0."""
import json
import sys
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote


class Page(HTMLParser):
    def __init__(self, file):
        super().__init__()
        self.ids = set()
        self.hrefs = set()
        self.classes = Counter()
        self.verdicts = {}
        self.line_depth = 0
        self.line = []
        self.lines = []
        self.line_number = False
        self.source_links = []
        self.feed(file.read_text())
        self.close()

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if self.line_depth:
            self.line_depth += 1
        if attrs.get('class') == 'line':
            self.line_depth = 1
            self.line = []
        if attrs.get('class') == 'ln':
            self.line_number = True
        if attrs.get('class') == 'ref':
            self.source_links.append(unquote(attrs['href']))
        if 'data-bp-theorem' in attrs and 'data-bp-verdict' in attrs:
            self.verdicts[attrs['data-bp-theorem']] = attrs['data-bp-verdict']
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        if 'href' in attrs:
            self.hrefs.add(unquote(attrs['href']))
        self.classes.update(attrs.get('class', '').split())

    def handle_data(self, data):
        if self.line_depth and not self.line_number:
            self.line.append(data)

    def handle_endtag(self, tag):
        if self.line_depth:
            self.line_depth -= 1
            if self.line_depth == 0:
                self.lines.append(''.join(self.line))
        if tag == 'a':
            self.line_number = False


def check(condition, text):
    if not condition:
        raise SystemExit(text)


site = Path(sys.argv[1])
atlas = site / 'source'
index = Page(atlas / 'index.html')
catalog = dict(json.loads((atlas / 'catalog.json').read_text()))
sources = {'.'.join(p.relative_to('src').with_suffix('').parts): p for p in Path('src').rglob('*.lean')}
check(catalog.keys() == sources.keys(), 'Source atlas module coverage mismatch')
indexed = {module: set(names) for module, names in catalog.items()}
for module, source in sources.items():
    filename = module + '.html'
    check(filename in index.hrefs, 'Missing module link: ' + module)
    page = Page(atlas / filename)
    compiler = json.loads((Path('.lake/build/lib/lean') / source.relative_to('src').with_suffix('.ilean')).read_text())
    expected = set(compiler['decls'])
    check(set(catalog[module]) == expected, 'Incomplete declaration search: ' + module)
    check(all('d-' + d in page.ids for d in expected), 'Missing declaration anchor: ' + module)
    lines = source.read_text().splitlines()
    check(page.lines == lines, 'Published text differs from Lean source: ' + module)
    for href in page.source_links:
        target, anchor = href.split('#', 1)
        target_module = target.removesuffix('.html') if target else module
        check(anchor.startswith('d-') and anchor[2:] in indexed.get(target_module, set()),
              'Unknown source reference in ' + module + ': ' + href)
    check(all('L' + str(n) in page.ids for n in range(1,len(lines)+1)), 'Missing line: ' + module)
    check(all(not h.startswith('#') or h[1:] in page.ids for h in page.hrefs), 'Broken local link: ' + module)
stats = Page(site / 'Project-Stats/index.html')
judged = json.loads(Path('Comparator/Grh/comparator.json').read_text())['theorem_names']
check(stats.verdicts == dict.fromkeys(judged, 'proved'), 'Comparator theorem verdicts mismatch')
check(stats.classes['bp_stats_replay_accepted'] > 0, 'Kernel replay has not accepted the export')
size = sum(p.stat().st_size for p in site.rglob('*') if p.is_file())
check(size < 1_000_000_000, f'Published site exceeds the 1 GB budget ({size:,} bytes)')
print(f'Verified {len(sources)} modules, {sum(map(len,catalog.values())):,} declaration anchors, and {size:,} published bytes')
