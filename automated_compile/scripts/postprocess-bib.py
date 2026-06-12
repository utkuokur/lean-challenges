#!/usr/bin/env python3
"""Restyle LaTeXML bibliographies to match the biblatex/PDF look.

LaTeXML renders reference links as "External Links: Document, Link" plus a
"Cited by:" back-reference block. This rewrites each bibitem, in place, to the
style biblatex prints in the PDF:

    DOI: 10.1112/plms/s2-30.1.264.          (the DOI itself is the link)
    arXiv: 2208.03803 [math.CO].            (the arXiv id is the link)
    URL: https://...                        (only when neither DOI nor arXiv)

and drops the "Cited by:" block entirely. Run by scripts/build-html.sh after
latexmlc; safe to re-run (idempotent: already-restyled items are left alone).
"""

import html
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent  # automated_compile/
BIB = ROOT / "content" / "tex" / "bibliography.bib"
OUT = ROOT / "public" / "content" / "html"

ARXIV_ID = re.compile(r"\b(\d{4}\.\d{4,5})(?:v\d+)?\b")


def eprint_classes(bib_text: str) -> dict[str, str]:
    """Map arXiv eprint id -> primaryClass (e.g. '2208.03803' -> 'math.CO')."""
    classes = {}
    for body in re.findall(r"@\w+\{[^,]+,(.*?)\n\}", bib_text, re.S):
        ep = re.search(r"eprint\s*=\s*\{([^}]+)\}", body)
        pc = re.search(r"primaryClass\s*=\s*\{([^}]+)\}", body)
        if ep:
            classes[ep.group(1).strip()] = pc.group(1).strip() if pc else ""
    return classes


def link(href: str, text: str) -> str:
    return (
        f'<a href="{html.escape(href, quote=True)}" title="{html.escape(href, quote=True)}" '
        f'class="ltx_ref ltx_bib_external"><span class="ltx_text ltx_font_typewriter">'
        f"{html.escape(text)}</span></a>"
    )


def restyle_item(item: str, classes: dict[str, str]) -> str:
    # Drop the "Cited by:" back-reference block (always the tail of the <li>).
    item = re.sub(
        r'\s*<span class="ltx_bibblock ltx_bib_cited">.*?(?=</li>)', "", item, flags=re.S
    )

    m = re.search(
        r'<span class="ltx_bibblock">External Links:.*?(?=<span class="ltx_bibblock|</li>)',
        item,
        flags=re.S,
    )
    if not m:
        return item
    block = m.group(0)

    # Collect identifiers from the LaTeXML-generated link block.
    doi_m = re.search(r'href="https?://dx\.doi\.org/([^"]+)"', block)
    arxiv_m = re.search(r'href="https?://arxiv\.org/abs/([^"]+?)(?:v\d+)?"', block)
    plain = ARXIV_ID.search(re.sub(r"<a [^>]*>.*?</a>", "", block, flags=re.S))
    other = [
        u
        for u in re.findall(r'href="(https?://[^"]+)"', block)
        if "dx.doi.org" not in u and "arxiv.org" not in u
    ]

    doi = None
    if doi_m:
        from urllib.parse import unquote

        doi = unquote(doi_m.group(1))
    eprint = arxiv_m.group(1) if arxiv_m else (plain.group(1) if plain else None)

    parts = []
    if doi:
        parts.append(
            '<span class="ltx_text ltx_font_smallcaps">doi</span>: '
            + link("https://doi.org/" + doi, doi)
            + "."
        )
    if eprint:
        cls = classes.get(eprint, "")
        shown = f"{eprint} [{cls}]" if cls else eprint
        parts.append("arXiv: " + link("https://arxiv.org/abs/" + eprint, shown) + ".")
    if not parts and other:
        parts.append(
            '<span class="ltx_text ltx_font_smallcaps">url</span>: '
            + link(other[0], other[0])
            + "."
        )

    if parts:
        new_block = '<span class="ltx_bibblock">' + " ".join(parts) + "</span>\n"
    else:
        new_block = ""  # nothing resolvable (e.g. ISSN/ISBN only): drop the block
    return item.replace(block, new_block, 1)


def main() -> int:
    classes = eprint_classes(BIB.read_text())
    files = sorted(OUT.glob("challenge_*.html"))
    if not files:
        print(f"error: no HTML files in {OUT}", file=sys.stderr)
        return 1
    for f in files:
        text = f.read_text()
        items = re.findall(r'<li id="bib\.bib\d+".*?</li>', text, re.S)
        n_doi = n_arxiv = n_url = 0
        for item in items:
            new = restyle_item(item, classes)
            text = text.replace(item, new, 1)
            n_doi += "ltx_font_smallcaps\">doi</span>" in new
            n_arxiv += "arXiv: " in new
            n_url += "ltx_font_smallcaps\">url</span>" in new
        f.write_text(text)
        print(
            f"{f.name}: {len(items)} refs -> {n_doi} DOI, {n_arxiv} arXiv, {n_url} URL"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
