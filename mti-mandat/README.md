# MTI Mandat — build & content guide

Pandoc-based DOCX build for `draft.md` (Studi Kasus PT MII — Talent Management,
kerangka DAMA-DMBOK2).

Original file name: DRAFT MANDAT - Tugas 1 v1.1.docx

## Build

Requires [pandoc](https://pandoc.org) ≥ 3.x.

```sh
make          # or `make build` → out/draft.docx
make check    # integrity checks (sections, styles, header/footer refs)
make clean    # remove out/
```

Inspection targets: `make sections`, `make refs`, `make styles`, `make template`.

## Managing figures

- Put image files in `figures/`.
- Reference them in `draft.md` with an explicit `figures/` prefix:

  ```md
  ![](figures/my-figure.png)

  **Gambar N. Caption text**
  ```

- The Makefile passes `--resource-path=figures`, so pandoc also resolves bare
  filenames against `./figures`.
- Caption convention: a bold `**Gambar N. …**` paragraph directly below the image.
- Wide/landscape figures: wrap image + caption in a fenced div (handled by
  `landscape.lua`):

  ```md
  ::: landscape

  ![](figures/wide-figure.png)

  **Gambar N. …**

  :::
  ```

- `figures/gambar1-dummy.png` is a **placeholder** for *Gambar 1* — replace it
  with the real diagram when ready.

## Managing references (BibTeX)

Sources live in `references.bib`; the bibliography is generated automatically by
pandoc `--citeproc` using the APA style (`../assets/csl/apa.csl`).

### Citing in text

| Syntax | Renders as (APA 7) |
| --- | --- |
| `[@dama2017]` | (DAMA International, 2017) |
| `DAMA International [-@dama2017]` | DAMA International (2017) |
| `[@dokumenkoma2025; @dokumenkomb2026]` | (Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026) |

- Parenthetical citations use `[@key]`; narrative citations keep the author in
  prose and use `[-@key]` for the year only.
- The bibliography is rendered at the `# 6. Referensi` heading, where the
  `::: {#refs}` div marks the insertion point.
- APA 7 uses “et al.” for three or more authors, e.g. `[@abraham2019]` →
  (Abraham et al., 2019).

### Adding a source

Add an entry to `references.bib`, then cite it with `[@key]`. Common types:

```bibtex
@book{dama2017,
  author    = {{DAMA International}},
  title     = {{DAMA-DMBOK: Data Management Body of Knowledge}},
  edition   = {2},
  year      = {2017},
  publisher = {{Technics Publications}}
}

@article{abraham2019,
  author  = {Abraham, R. and Schneider, J. and {vom Brocke}, J.},
  title   = {{Data governance: A conceptual framework, structured review, and research agenda}},
  journal = {{International Journal of Information Management}},
  volume  = {49},
  pages   = {424--438},
  year    = {2019},
  doi     = {10.1016/j.ijinfomgt.2019.07.008}
}

@online{microsoft2026a,
  author  = {{Microsoft}},
  title   = {{Learn about sensitivity labels (Microsoft Purview)}},
  year    = {2026},
  url     = {https://learn.microsoft.com/en-us/purview/sensitivity-labels},
  urldate = {2026-10-16}
}
```

Conventions used in this project:

- **Corporate/institutional authors** (e.g. `DAMA International`, `Republik
  Indonesia`, `Microsoft`) are wrapped in double braces `{{…}}` so they are not
  parsed as “Surname, Firstname”.
- **Case protection**: wrap titles in double braces `{{…}}` to keep title case
  and proper nouns (the APA CSL otherwise sentence-cases titles).
- **Multi-part surnames**: use `{vom Brocke}, J.` so the surname stays intact.
- **Informal notes** (e.g. `[Dokumen internal, …]`, `Lembaran Negara …`) are
  appended to the `title` field — the CSL does not render the `note` field.
- The CSL is **English-locale** (access dates render without the old
  `Diakses … dari` wording). Set `lang: id-ID` in the YAML front matter if you
  want localized bibliography terms later.

### Reference keys

| Key | Source |
| --- | --- |
| `abraham2019` | Abraham, Schneider, & vom Brocke (2019) |
| `cvkaryawan2026` | CV karyawan MII (2026) |
| `dama2017` | DAMA International (2017) |
| `dokumenkoma2025` | Dokumen KOM Proyek A (2025) |
| `dokumenkomb2026` | Dokumen KOM Proyek B (2026) |
| `microsoft2026a` | Microsoft (2026a) — sensitivity labels |
| `microsoft2026b` | Microsoft (2026b) — Power Automate |
| `microsoft2026c` | Microsoft (2026c) — SharePoint |
| `porter1985` | Porter (1985) |
| `republikindonesia2022` | Republik Indonesia (2022) — UU PDP |
| `ward2016` | Ward & Peppard (2016) |
