"""Check the published atlas, links and proof-verification results. SPDX-License-Identifier: Apache-2.0."""
import json
import re
import sys
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import parse_qs, unquote, urljoin, urlsplit


class Page(HTMLParser):
    def __init__(self, file):
        super().__init__()
        self.base = None
        self.navigation = set()
        self.ids = set()
        self.graph_nodes = set()
        self.hrefs = set()
        self.classes = Counter()
        self.tags = Counter()
        self.verdicts = {}
        self.line_depth = 0
        self.line = []
        self.lines = []
        self.line_number = False
        self.source_links = []
        self.feed(file.read_text())
        self.close()

    def handle_starttag(self, tag, attrs):
        self.tags[tag] += 1
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
        if 'data-bp-node-name' in attrs:
            self.graph_nodes.add(attrs['data-bp-node-name'])
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        if tag == 'base' and self.base is None and attrs.get('href') is not None:
            self.base = attrs['href']
        if tag == 'a' and attrs.get('href') is not None:
            self.navigation.add(attrs['href'])
        if attrs.get('href') is not None:
            self.hrefs.add(unquote(attrs['href']))
        self.classes.update((attrs.get('class') or '').split())

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


def check_navigation(site):
    project_url = 'https://eric-vergo.github.io/grh-lean/'
    root = urlsplit(project_url)
    ids = {}
    graphs = {}
    static = dynamic = 0
    for file in site.rglob('*.html'):
        relative = file.relative_to(site)
        if relative.parts[0] == 'source':
            continue
        page = Page(file)
        page_url = urljoin(project_url, relative.as_posix())
        base = urljoin(page_url, page.base or page_url)
        for href in page.navigation:
            target = urlsplit(urljoin(base, href))
            if target.scheme not in ('http', 'https') or target.netloc != root.netloc:
                continue
            path = unquote(target.path)
            check(path.startswith(root.path), f'{relative}: link escapes project path: {href}')
            dest = site / path.removeprefix(root.path)
            if dest.is_dir():
                dest = dest / 'index.html'
            check(dest.is_file(), f'{relative}: missing target {href} ({dest})')
            fragment = unquote(target.fragment)
            if fragment.startswith(('ego=', 'node=')):
                if dest not in graphs:
                    graphs[dest] = Page(dest).graph_nodes
                fields = parse_qs(target.fragment)
                mode = 'ego' if fragment.startswith('ego=') else 'node'
                labels = fields.get(mode, [])
                check(len(labels) == 1 and labels[0] in graphs[dest],
                      f'{relative}: missing graph node in {href}')
                dynamic += 1
                continue
            if fragment.startswith(('--informal-preview-', '--informal-external-decl-')):
                # VersoBlueprint opens these preview/declaration targets in its client runtime.
                dynamic += 1
                continue
            if fragment and dest.suffix == '.html':
                if dest not in ids:
                    ids[dest] = Page(dest).ids
                check(fragment in ids[dest], f'{relative}: missing fragment {href} ({dest})')
            static += 1
    print(f'Checked {static} local navigation links under {root.path} and '
          f'{dynamic} client-managed graph or preview links')


class Chapter(HTMLParser):
    """Read chapter narrative and informal proof bodies, excluding the Lean panels."""

    def __init__(self, filepath):
        super().__init__()
        self.facets = {}
        self.opening = []
        self.section_depth = 0
        self.past_opening = False
        self.in_opening_paragraph = False
        self.divs = []
        self.proof = None
        self.proof_body = False
        self.feed(filepath.read_text())
        self.close()

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == 'section':
            self.section_depth += 1
            if self.section_depth > 1:
                self.past_opening = True
        if tag == 'p' and self.section_depth == 1 and not self.past_opening and 'panel' not in self.divs:
            self.in_opening_paragraph = True
        if tag == 'div':
            facet = attrs.get('data-bp-facet')
            node = attrs.get('data-bp-node')
            role = ''
            if facet and node:
                role = 'panel'
                if facet == 'proof':
                    self.proof = node
                    self.facets.setdefault(node, [])
            if 'bp_kind_proof_content' in attrs.get('class', '').split():
                role = 'proof-body'
                self.proof_body = True
            self.divs.append(role)

    def handle_data(self, data):
        if self.in_opening_paragraph:
            self.opening.append(data)
        if self.proof_body and self.proof:
            self.facets[self.proof].append(data)

    def handle_endtag(self, tag):
        if tag == 'section':
            self.section_depth -= 1
        elif tag == 'p':
            self.in_opening_paragraph = False
        elif tag == 'div' and self.divs:
            role = self.divs.pop()
            if role == 'proof-body':
                self.proof_body = False
            elif role == 'panel':
                self.proof = None


def check_chapters(site):
    links = [line.split('\t') for line in Path('blueprint/section-links.tsv').read_text().splitlines()]
    chapters = {Path(path).parts[0] for path, _ in links}
    check(len(chapters) == 7 and len(links) == 22, 'Incomplete chapter or published subsection inventory')
    pages = {name: Page(site / name / 'index.html') for name in chapters}
    narrative = {name: Chapter(site / name / 'index.html') for name in chapters}
    for name, page in narrative.items():
        check(''.join(page.opening).strip(), f'{name}: chapter opens without explanatory prose')
    for path, anchor in links:
        name = Path(path).parts[0]
        check(anchor in pages[name].ids, f'{name}: missing in-chapter section {anchor}')
        alias = Page(site / path / 'index.html')
        check('../#' + anchor in alias.hrefs, f'Missing public subsection redirect: {path}')

    manifest = json.loads((site / '-verso-data/blueprint-manifest.json').read_bytes())
    nodes = {node['label']: node for graph in manifest['graphs'] for node in graph['nodes']}
    previews = {(p['authoredLabel'], p['facet']): p for p in manifest['previews']}
    important = ('error', 'half', 'strip', 'zeta', 'cutoffs', 'star', 'twists', 'long',
                 'moments', 'spanning', 'vacuum', 'seesaw', 'short')
    for label in important:
        check(('grh-guide-' + label, 'proof') in previews, f'Missing original proof: {label}')
    proofs = 0
    for label, node in nodes.items():
        if node['kind'] not in ('theorem', 'lemma', 'proposition', 'corollary'):
            continue
        check(node['leanNames'] and all(d['present'] for d in node['leanNames']),
              f'{label}: no resolved Lean declaration')
        proof = previews.get((label.strip('«»'), 'proof'))
        check(proof and not proof['codeOnlyPreview'], f'{label}: missing authored informal proof')
        dest = urlsplit(proof['href'])
        chapter = dest.path.strip('/')
        check(chapter in pages and unquote(dest.fragment) in pages[chapter].ids,
              f'{label}: proof does not appear in a continuous chapter')
        check(''.join(narrative[chapter].facets.get(label, [])).strip(),
              f'{label}: rendered proof contains no mathematical prose')
        proofs += 1

    results = Page(site / 'reading/index.html')
    coverage = Path('blueprint/coverage.tsv').read_text().splitlines()
    indexed = {line.split('\t')[2] for line in coverage}
    for label in indexed:
        statement = previews.get((label, 'statement'))
        check(statement and '../' + statement['href'] in results.hrefs, f'Missing result link: {label}')
    check(len(coverage) == 90, 'Expected the 81 indexed argument steps and nine final results')
    print(f'Verified {len(chapters)} continuous chapters, {len(links)} subsection redirects, '
          f'{len(nodes)} entries, {proofs} informal proofs and {len(coverage)} indexed results')


def check_reading_pages(site):
    for document in ('GUIDE', 'INDEX', 'REFERENCES'):
        markdown = Path(document + '.md').read_text()
        page = Page(site / 'reading' / (document.lower() + '.html'))
        lines = markdown.splitlines()
        rows = sum(line.startswith('|') and not re.fullmatch(r'[| :\-]+', line) for line in lines)
        check(page.tags['tr'] == rows, f'{document}: expected all {rows} table rows')
        check(page.tags['h2'] == sum(line.startswith('## ') for line in lines),
              f'{document}: missing section')
        for name in set(re.findall(r'`((?:New|Lib)/[A-Za-z0-9_/]+)`', markdown)):
            if (Path('src') / (name + '.lean')).is_file():
                check('../source/' + name.replace('/', '.') + '.html' in page.hrefs,
                      f'{document}: no atlas link for {name}')
        check(any(h.endswith('/grh/' + document + '.md') for h in page.hrefs),
              f'{document}: missing upstream provenance link')


def check_atlas(site):
    atlas = site / 'source'
    index = Page(atlas / 'index.html')
    catalog = dict(json.loads((atlas / 'catalog.json').read_text()))
    sources = {'.'.join(p.relative_to('src').with_suffix('').parts): p for p in Path('src').rglob('*.lean')}
    check(catalog.keys() == sources.keys(), 'Source atlas module coverage mismatch')
    indexed = {module: set(names) for module, names in catalog.items()}
    total_lines = total_links = 0
    for module, source in sources.items():
        filename = module + '.html'
        check(filename in index.hrefs, 'Missing module link: ' + module)
        page = Page(atlas / filename)
        compiler = json.loads((Path('.lake/build/lib/lean') / source.relative_to('src').with_suffix('.ilean')).read_text())
        expected = set(compiler['decls'])
        check(set(catalog[module]) == expected, 'Incomplete declaration search: ' + module)
        check(all('d-' + d in page.ids for d in expected), 'Missing declaration anchor: ' + module)
        lines = source.read_text().splitlines()
        total_lines += len(lines)
        total_links += len(page.source_links)
        check(page.lines == lines, 'Published text differs from Lean source: ' + module)
        for href in page.source_links:
            target, anchor = href.split('#', 1)
            target_module = target.removesuffix('.html') if target else module
            check(anchor.startswith('d-') and anchor[2:] in indexed.get(target_module, set()),
                  'Unknown source reference in ' + module + ': ' + href)
        check(all('L' + str(n) in page.ids for n in range(1,len(lines)+1)), 'Missing line: ' + module)
        check(all(not h.startswith('#') or h[1:] in page.ids for h in page.hrefs), 'Broken local link: ' + module)
    return len(sources), sum(map(len, catalog.values())), total_lines, total_links


site = Path(sys.argv[1])
if sys.argv[2:] == ['--atlas-only']:
    modules, declarations, lines, links = check_atlas(site)
    print(f'Verified {modules} modules, {declarations:,} declaration anchors, {lines:,} source lines '
          f'and {links:,} linked references')
    sys.exit(0)
check_navigation(site)
if sys.argv[2:] == ['--links-only']:
    sys.exit(0)
check_reading_pages(site)
if sys.argv[2:] == ['--reading-only']:
    sys.exit(0)
check_chapters(site)
modules, declarations, _, _ = check_atlas(site)
landing = Page(site / 'index.html')
check('source/index.html' in landing.hrefs, 'Landing page has no source atlas link')
check({'reading/guide.html', 'reading/guide.html#2-glossary', 'reading/guide.html#3-sizes',
       'reading/index.html', 'reading/references.html'} <= landing.hrefs,
      'Landing page does not link to all readable companions')
stats = Page(site / 'Project-Stats/index.html')
judged = json.loads(Path('Comparator/Grh/comparator.json').read_text())['theorem_names']
check(all('source/Main.html#d-' + name in landing.hrefs for name in judged),
      'Landing page does not link to each canonical theorem')
check(stats.verdicts == dict.fromkeys(judged, 'proved'), 'Comparator theorem verdicts mismatch')
check(stats.classes['bp_stats_replay_accepted'] > 0, 'Kernel replay has not accepted the export')
sizes = Counter()
for file in site.rglob('*'):
    if not file.is_file():
        continue
    relative = file.relative_to(site)
    check(file.suffix != '.ndjson', 'Private kernel export in the published site: ' + str(relative))
    if relative.parts[0] == 'source':
        group = 'indexed source atlas'
    elif file.suffix == '.html':
        group = 'blueprint HTML pages'
    elif relative.parts[0] == '-verso-data' and file.suffix == '.json':
        group = 'blueprint JSON data'
    else:
        group = 'shared assets and other files'
    sizes[group] += file.stat().st_size
size = sizes.total()
for group, value in sorted(sizes.items()):
    print(f'{group}: {value:,} bytes')
check(size < 1_000_000_000, f'Published site exceeds the 1 GB budget ({size:,} bytes)')
print(f'Verified {modules} modules, {declarations:,} declaration anchors, and {size:,} published bytes')
