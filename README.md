# Journal of Niche NLP

<https://nichenlp.com>

The **Journal of Niche NLP** is an international, open-access, peer-reviewed journal dedicated to research beyond the mainstream of Natural Language Processing. We welcome work on underrepresented languages, historical data, interdisciplinary applications, unconventional approaches, and critical perspectives on prevailing research directions. The journal publishes research articles, position papers, and short commentaries. Publication is completely free, and submissions are welcome from researchers worldwide.

## LaTeX template

This repository contains the one-column submission template for the journal. [main.tex](main.tex) is an example manuscript and [journalofnichenlp.cls](journalofnichenlp.cls) contains the journal styling. The supplied [logo.png](logo.png) and [by.png](by.png) are included automatically on the camera-ready first page.

## Modes

At the top of `main.tex`, choose exactly one mode:

```tex
\documentclass[review]{journalofnichenlp} % anonymous submission
% \documentclass[camera]{journalofnichenlp} % final published article
```

Review mode replaces author and affiliation information with an anonymous notice and suppresses citation metadata. Camera mode displays author information, the journal identity, and a bottom-of-page article citation with no volume, issue, or page range.

Set `\citationauthors{...}` to the APA-formatted author list that should appear in the camera-ready citation. If it is omitted, the displayed author information is used, with `\and` rendered as an inline “and” separator. Explicit citation author lists are used unchanged.

The minimal [multiple-author regression example](tests/multiple-authors.tex) deliberately omits `\citationauthors`. Run `python3 tests/check-citations.py` to compile it and the supplied manuscript in review and camera modes, including explicit citation overrides. The check requires `pdflatex`, `bibtex`, and `pdftotext`; PDFs and logs are written under `build/`. CI also reproduces the original camera-mode failure before checking the fixed class.

## Citations and bibliography

Keep references in `references.bib` and cite with `\cite`, `\citet`, `\citep`, `\citeauthor`, `\citeyear`, or `\citealt`. The template uses `natbib` author--date commands and the APA-style `apalike` BibTeX style. BibTeX outputs only cited entries (do not use `\nocite{*}` if that is the desired policy).

Compile with:

```text
pdflatex main
bibtex main
pdflatex main
pdflatex main
```

The class numbers and styles `\section`, `\subsection`, `\subsubsection`, and `\paragraph` (the fourth level). Use `\paragraph{Heading}` without a blank line before its following text.

## Preparing a submission

Replace the sample title, author information, text, table, figure, and bibliography entries with your own. Keep all cited sources in `references.bib`, compile the document using the sequence above, and submit the resulting PDF together with the `.tex`, `.bib`, and any figure files requested by the journal.

