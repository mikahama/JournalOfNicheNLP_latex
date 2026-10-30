#!/usr/bin/env python3
"""Compile real PDFs and check citation text and review anonymity.

Run from any directory with pdflatex, bibtex and pdftotext on PATH.
Use --baseline-class PATH to verify the original missing authors and fallback error.
"""
import argparse
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--baseline-class', type=Path)
args = parser.parse_args()


def run(command, directory):
    return subprocess.run(command, cwd=directory, text=True,
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT)


def check(name, source, mode, override=None, baseline=False, bibliography=False):
    directory = ROOT / 'build' / name
    directory.mkdir(parents=True, exist_ok=True)
    for filename in ('logo.png', 'by.png', 'references.bib'):
        shutil.copy2(ROOT / filename, directory)
    shutil.copy2(args.baseline_class if baseline else ROOT / 'journalofnichenlp.cls',
                 directory / 'journalofnichenlp.cls')
    if override is not None:
        source = source.replace(r'\begin{document}',
                                r'\citationauthors{' + override + '}\n' + r'\begin{document}')
    (directory / 'article.tex').write_text(
        r'\PassOptionsToClass{' + mode + r'}{journalofnichenlp}' + '\n' + source)
    command = ['pdflatex', '-interaction=nonstopmode', '-halt-on-error', 'article.tex']
    result = run(command, directory)
    (directory / 'console.txt').write_text(result.stdout)
    if baseline and mode == 'camera' and override == '':
        assert result.returncode != 0, 'Original camera fallback unexpectedly compiled'
        assert 'Misplaced \\crcr.' in result.stdout, result.stdout
        print(f'{name}: reproduced Misplaced \\crcr. with an empty override at shipout', flush=True)
        return
    assert result.returncode == 0, result.stdout
    if bibliography:
        result = run(['bibtex', 'article'], directory)
        assert result.returncode == 0, result.stdout
    for _ in range(2):
        result = run(command, directory)
        assert result.returncode == 0, result.stdout
    log = (directory / 'article.log').read_text()
    assert not any(s in log for s in ('LaTeX Error:', 'Undefined control sequence',
                                      'Overfull', 'undefined references',
                                      'undefined citations')), log
    result = run(['pdftotext', '-layout', 'article.pdf', 'article.txt'], directory)
    assert result.returncode == 0, result.stdout
    text = ' '.join((directory / 'article.txt').read_text().split())
    if mode == 'review':
        assert 'Anonymous submission' in text and 'Review copy.' in text, text
        assert all(s not in text for s in ('Citation:', 'Ada Author',
                                          'Richard Researcher', 'Example University',
                                          'Sample College', 'Author, A.')), text
    else:
        assert 'Ada Author' in text and 'Richard Researcher' in text, text
        citation = text.split('Citation:', 1)[1]
        if baseline and override is None:
            assert citation.startswith(' (2026).'), citation
            assert 'Ada Author' not in citation and 'Richard Researcher' not in citation, citation
            print(f'{name}: reproduced missing authors when override is omitted', flush=True)
            return
        if override:
            assert 'Author, A., & Researcher, R. (2026).' in citation, citation
            assert 'Ada Author' not in citation, citation
        elif bibliography:
            assert 'Author, A., & Researcher, R. (2026).' in citation, citation
        else:
            assert ('Ada Author1 and Richard Researcher2 (2026). '
                    'Multiple Author Regression. Journal of Niche NLP.') in citation, citation
        assert text.count('Citation:') == 1, text
    print(f'{name}: PASS', flush=True)


minimal = (ROOT / 'tests/multiple-authors.tex').read_text()
override = r'Author, A., \& Researcher, R.'
if args.baseline_class:
    for mode in ('review', 'camera'):
        check(f'baseline-{mode}', minimal, mode, baseline=True)
    check('baseline-override', minimal, 'camera', override, baseline=True)
    check('baseline-empty-override', minimal, 'camera', '', baseline=True)
for mode in ('review', 'camera'):
    check(f'fallback-{mode}', minimal, mode)
    check(f'override-{mode}', minimal, mode, override)
    check(f'empty-override-{mode}', minimal, mode, '')
    check(f'main-{mode}', (ROOT / 'main.tex').read_text().replace(
        r'\documentclass[review]', r'\documentclass'), mode, bibliography=True)
