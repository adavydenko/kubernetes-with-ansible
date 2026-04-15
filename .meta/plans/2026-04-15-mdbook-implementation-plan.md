# mdBook Publishing Pipeline Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a maintainable `mdBook` publishing pipeline that renders existing `docs/` Markdown content as a web book and exports a PDF artifact from the same source.

**Architecture:** Keep `docs/` as the single source of truth. Add a sync script that materializes a curated mdBook tree in `publishing/mdbook/src/content/`, then build HTML via `mdbook build` and export PDF via Pandoc/XeLaTeX. Automate both outputs in GitHub Actions.

**Tech Stack:** `mdBook`, Python 3 (`pytest` for script tests), Pandoc + XeLaTeX, GitHub Actions, existing Markdown docs in `docs/`.

---

## File Structure and Responsibilities

- `publishing/mdbook/book.toml` — mdBook configuration (title, language, theme hooks).
- `publishing/mdbook/src/SUMMARY.md` — curated book navigation and chapter order.
- `publishing/mdbook/src/README.md` — book landing page.
- `publishing/mdbook/src/content/**` — generated chapter files synced from `docs/**`.
- `publishing/mdbook/theme/custom.css` — visual tweaks for book-like typography.
- `scripts/sync_docs_to_mdbook.py` — deterministic sync from `docs/` to mdBook content tree.
- `scripts/export_mdbook_pdf.py` — compile a single Markdown stream and call Pandoc for PDF.
- `tests/publishing/test_sync_docs_to_mdbook.py` — tests for path mapping and link rewrite logic.
- `tests/publishing/test_export_mdbook_pdf.py` — tests for chapter collection and pandoc command assembly.
- `.github/workflows/mdbook.yml` — CI for sync + HTML build + Pages deploy.
- `.github/workflows/mdbook-pdf.yml` — CI for PDF build and artifact upload.
- `.meta/specs/2026-04-15-mdbook-publishing-design.md` — approved design reference.

### Task 1: Bootstrap mdBook workspace

**Files:**
- Create: `publishing/mdbook/book.toml`
- Create: `publishing/mdbook/src/SUMMARY.md`
- Create: `publishing/mdbook/src/README.md`
- Create: `publishing/mdbook/theme/custom.css`
- Modify: `.gitignore`
- Test: `publishing/mdbook/src/SUMMARY.md` renders with `mdbook build`

- [ ] **Step 1: Create minimal failing build check**

Create `publishing/mdbook/src/SUMMARY.md` with one intentionally missing chapter link:

```markdown
# Summary

- [Введение](README.md)
- [Missing](content/missing.md)
```

- [ ] **Step 2: Run build to verify failure**

Run: `mdbook build publishing/mdbook`  
Expected: FAIL with a message that `content/missing.md` does not exist.

- [ ] **Step 3: Write minimal workspace implementation**

Create these files:

```toml
# publishing/mdbook/book.toml
[book]
title = "Kubernetes with Ansible - Study Guide"
language = "ru"
multilingual = false
src = "src"
```

```markdown
# publishing/mdbook/src/README.md
# Учебное пособие по Kubernetes

Собрано из материалов репозитория `docs/`.
```

```markdown
# publishing/mdbook/src/SUMMARY.md
# Summary

- [Введение](README.md)
```

```css
/* publishing/mdbook/theme/custom.css */
:root {
  --content-max-width: 900px;
}
```

- [ ] **Step 4: Run build to verify pass**

Run: `mdbook build publishing/mdbook`  
Expected: PASS, generated HTML exists in `publishing/mdbook/book`.

- [ ] **Step 5: Commit**

```bash
git add publishing/mdbook .gitignore
git commit -m "chore: bootstrap mdBook workspace for study guide"
```

### Task 2: Implement docs -> mdBook sync with tests

**Files:**
- Create: `scripts/sync_docs_to_mdbook.py`
- Create: `tests/publishing/test_sync_docs_to_mdbook.py`
- Modify: `publishing/mdbook/src/SUMMARY.md`
- Create: `publishing/mdbook/src/content/.gitkeep`
- Test: `tests/publishing/test_sync_docs_to_mdbook.py`

- [ ] **Step 1: Write failing tests for mapping and link rewriting**

Create `tests/publishing/test_sync_docs_to_mdbook.py`:

```python
from pathlib import Path
from scripts.sync_docs_to_mdbook import (
    map_doc_path_to_book_path,
    rewrite_local_markdown_links,
)


def test_map_doc_path_to_book_path():
    src = Path("docs/learning/LEARNING_GUIDE.md")
    assert map_doc_path_to_book_path(src) == Path("content/learning/learning_guide.md")


def test_rewrite_local_markdown_links():
    text = "См. [гайд](../theory/K8S.md)"
    rewritten = rewrite_local_markdown_links(text, Path("docs/learning"))
    assert "(../theory/k8s.md)" in rewritten
```

- [ ] **Step 2: Run tests to verify failure**

Run: `pytest tests/publishing/test_sync_docs_to_mdbook.py -q`  
Expected: FAIL with `ModuleNotFoundError` or missing symbol errors.

- [ ] **Step 3: Write minimal implementation**

Create `scripts/sync_docs_to_mdbook.py`:

```python
from pathlib import Path
import re
import shutil

DOCS_ROOT = Path("docs")
BOOK_SRC = Path("publishing/mdbook/src")
CONTENT_ROOT = BOOK_SRC / "content"


def map_doc_path_to_book_path(src: Path) -> Path:
    rel = src.relative_to(DOCS_ROOT)
    return Path("content") / rel.parent / f"{src.stem.lower()}.md"


def rewrite_local_markdown_links(text: str, current_dir: Path) -> str:
    pattern = re.compile(r"\(([^)]+\.md)\)")

    def _replace(match: re.Match[str]) -> str:
        target = (current_dir / match.group(1)).resolve()
        rel_target = target.relative_to(Path.cwd().resolve())
        mapped = map_doc_path_to_book_path(rel_target)
        return f"({mapped.as_posix()})"

    return pattern.sub(_replace, text)


def main() -> None:
    if CONTENT_ROOT.exists():
        shutil.rmtree(CONTENT_ROOT)
    CONTENT_ROOT.mkdir(parents=True, exist_ok=True)
```

- [ ] **Step 4: Run tests to verify pass**

Run: `pytest tests/publishing/test_sync_docs_to_mdbook.py -q`  
Expected: PASS with 2 passing tests.

- [ ] **Step 5: Commit**

```bash
git add scripts/sync_docs_to_mdbook.py tests/publishing/test_sync_docs_to_mdbook.py publishing/mdbook/src/SUMMARY.md publishing/mdbook/src/content/.gitkeep
git commit -m "feat: add tested docs-to-mdbook sync primitives"
```

### Task 3: Curated table of contents and full sync execution

**Files:**
- Modify: `scripts/sync_docs_to_mdbook.py`
- Modify: `publishing/mdbook/src/SUMMARY.md`
- Create: `publishing/mdbook/src/content/index.md`
- Test: `mdbook build publishing/mdbook`

- [ ] **Step 1: Write failing integration assertion**

Add test to `tests/publishing/test_sync_docs_to_mdbook.py`:

```python
from scripts.sync_docs_to_mdbook import build_summary_markdown


def test_summary_contains_core_sections():
    summary = build_summary_markdown()
    assert "- [Learning Guide](content/learning/learning_guide.md)" in summary
    assert "- [Theory](content/theory/k8s.md)" in summary
```

- [ ] **Step 2: Run tests to verify failure**

Run: `pytest tests/publishing/test_sync_docs_to_mdbook.py -q`  
Expected: FAIL because `build_summary_markdown` is not implemented.

- [ ] **Step 3: Implement full sync and summary generation**

Extend `scripts/sync_docs_to_mdbook.py`:

```python
CURATED_ORDER = [
    "docs/STUDY_GUIDE_OVERVIEW.md",
    "docs/learning/LEARNING_GUIDE.md",
    "docs/learning/EXERCISES.md",
    "docs/learning/QUIZ.md",
    "docs/theory/K8S.md",
    "docs/deployment/DEPLOYMENT_GUIDE.md",
    "docs/reference/RESOURCES.md",
]


def build_summary_markdown() -> str:
    lines = ["# Summary", "", "- [Главная](README.md)"]
    for raw in CURATED_ORDER:
        src = Path(raw)
        target = map_doc_path_to_book_path(src).as_posix()
        lines.append(f"- [{src.stem.replace('_', ' ').title()}]({target})")
    return "\n".join(lines) + "\n"


def main() -> None:
    # existing cleanup...
    for raw in CURATED_ORDER:
        src = Path(raw)
        dst = BOOK_SRC / map_doc_path_to_book_path(src)
        dst.parent.mkdir(parents=True, exist_ok=True)
        text = src.read_text(encoding="utf-8")
        dst.write_text(rewrite_local_markdown_links(text, src.parent), encoding="utf-8")

    (BOOK_SRC / "SUMMARY.md").write_text(build_summary_markdown(), encoding="utf-8")
```

- [ ] **Step 4: Run tests and build**

Run: `pytest tests/publishing/test_sync_docs_to_mdbook.py -q && python scripts/sync_docs_to_mdbook.py && mdbook build publishing/mdbook`  
Expected: PASS tests, sync completes, book build succeeds.

- [ ] **Step 5: Commit**

```bash
git add scripts/sync_docs_to_mdbook.py publishing/mdbook/src/SUMMARY.md publishing/mdbook/src/content/index.md tests/publishing/test_sync_docs_to_mdbook.py
git commit -m "feat: generate curated mdBook content and summary from docs"
```

### Task 4: Add PDF export pipeline from same source

**Files:**
- Create: `scripts/export_mdbook_pdf.py`
- Create: `tests/publishing/test_export_mdbook_pdf.py`
- Create: `publishing/mdbook/pdf/metadata.yaml`
- Test: `tests/publishing/test_export_mdbook_pdf.py`

- [ ] **Step 1: Write failing tests for PDF command assembly**

Create `tests/publishing/test_export_mdbook_pdf.py`:

```python
from scripts.export_mdbook_pdf import build_pandoc_command


def test_build_pandoc_command_contains_xelatex():
    cmd = build_pandoc_command(
        input_file="publishing/mdbook/.tmp/book.md",
        output_file="publishing/mdbook/dist/study-guide.pdf",
        metadata_file="publishing/mdbook/pdf/metadata.yaml",
    )
    assert "--pdf-engine=xelatex" in cmd
    assert "study-guide.pdf" in " ".join(cmd)
```

- [ ] **Step 2: Run tests to verify failure**

Run: `pytest tests/publishing/test_export_mdbook_pdf.py -q`  
Expected: FAIL because exporter module is missing.

- [ ] **Step 3: Implement PDF exporter**

Create `scripts/export_mdbook_pdf.py`:

```python
from pathlib import Path
import subprocess


def build_pandoc_command(input_file: str, output_file: str, metadata_file: str) -> list[str]:
    return [
        "pandoc",
        input_file,
        "--from=gfm",
        "--toc",
        "--number-sections",
        "--metadata-file",
        metadata_file,
        "--pdf-engine=xelatex",
        "-o",
        output_file,
    ]


def main() -> None:
    cmd = build_pandoc_command(
        input_file="publishing/mdbook/.tmp/book.md",
        output_file="publishing/mdbook/dist/study-guide.pdf",
        metadata_file="publishing/mdbook/pdf/metadata.yaml",
    )
    Path("publishing/mdbook/dist").mkdir(parents=True, exist_ok=True)
    subprocess.run(cmd, check=True)
```

Create `publishing/mdbook/pdf/metadata.yaml`:

```yaml
title: "Учебное пособие по Kubernetes"
author: "kubernetes-with-ansible project"
lang: ru-RU
```

- [ ] **Step 4: Run tests and exporter smoke check**

Run: `pytest tests/publishing/test_export_mdbook_pdf.py -q`  
Expected: PASS.

Run: `python scripts/export_mdbook_pdf.py`  
Expected: `publishing/mdbook/dist/study-guide.pdf` is created (with installed Pandoc + XeLaTeX).

- [ ] **Step 5: Commit**

```bash
git add scripts/export_mdbook_pdf.py tests/publishing/test_export_mdbook_pdf.py publishing/mdbook/pdf/metadata.yaml
git commit -m "feat: add mdBook-aligned PDF exporter with tests"
```

### Task 5: Automate CI/CD for web and PDF

**Files:**
- Create: `.github/workflows/mdbook.yml`
- Create: `.github/workflows/mdbook-pdf.yml`
- Modify: `README.md`
- Test: local dry runs of key commands

- [ ] **Step 1: Write failing CI expectation check**

Add test-like command in local checklist script (or manual pre-check command):

```bash
rg "mdbook build publishing/mdbook" .github/workflows/mdbook.yml
```

Run now before file exists.  
Expected: FAIL (file not found).

- [ ] **Step 2: Run check to verify failure**

Run: `rg "upload-pages-artifact" .github/workflows/mdbook.yml`  
Expected: FAIL because workflow is not created yet.

- [ ] **Step 3: Implement workflows**

Create `.github/workflows/mdbook.yml`:

```yaml
name: mdBook Web

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - run: cargo install mdbook
      - run: python scripts/sync_docs_to_mdbook.py
      - run: mdbook build publishing/mdbook
      - uses: actions/upload-pages-artifact@v3
        with:
          path: publishing/mdbook/book
```

Create `.github/workflows/mdbook-pdf.yml`:

```yaml
name: mdBook PDF

on:
  workflow_dispatch:
  push:
    branches: [ main ]

jobs:
  pdf:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: sudo apt-get update && sudo apt-get install -y pandoc texlive-xetex
      - run: python scripts/sync_docs_to_mdbook.py
      - run: python scripts/export_mdbook_pdf.py
      - uses: actions/upload-artifact@v4
        with:
          name: study-guide-pdf
          path: publishing/mdbook/dist/study-guide.pdf
```

- [ ] **Step 4: Run local command verification**

Run: `python scripts/sync_docs_to_mdbook.py && mdbook build publishing/mdbook && python scripts/export_mdbook_pdf.py`  
Expected: all commands pass locally (assuming dependencies installed).

- [ ] **Step 5: Commit**

```bash
git add .github/workflows/mdbook.yml .github/workflows/mdbook-pdf.yml README.md
git commit -m "ci: automate mdBook web deploy and PDF artifact build"
```

### Task 6: Final verification and rollout checklist

**Files:**
- Modify: `README.md`
- Modify: `docs/STUDY_GUIDE_OVERVIEW.md` (add link to published book/PDF once URL known)
- Test: full local verification matrix

- [ ] **Step 1: Write failing link-validation expectation**

Create explicit command list and run before adding links:

```bash
rg "Учебник \\(mdBook\\)" README.md
```

Expected: FAIL (section absent).

- [ ] **Step 2: Run checks to verify failure**

Run: `rg "GitHub Pages" README.md`  
Expected: no mdBook section yet or missing planned links.

- [ ] **Step 3: Implement rollout docs updates**

Add README section with exact commands:

```markdown
## mdBook publishing

~~~bash
python scripts/sync_docs_to_mdbook.py
mdbook serve publishing/mdbook --open
python scripts/export_mdbook_pdf.py
~~~
```

Add short note in `docs/STUDY_GUIDE_OVERVIEW.md`:

```markdown
Публикация материалов доступна в формате mdBook (web) и PDF (artifact).
```

- [ ] **Step 4: Run full verification matrix**

Run:
`pytest tests/publishing -q && python scripts/sync_docs_to_mdbook.py && mdbook build publishing/mdbook && python scripts/export_mdbook_pdf.py`

Expected:
- all tests PASS;
- HTML book generated;
- PDF generated.

- [ ] **Step 5: Commit**

```bash
git add README.md docs/STUDY_GUIDE_OVERVIEW.md
git commit -m "docs: document mdBook workflow and rollout checks"
```

## Self-Review Results

- **Spec coverage:** Covered web pipeline, curated structure, PDF path, CI automation, verification, and risk controls from spec.
- **Placeholder scan:** No `TODO/TBD/implement later` placeholders left.
- **Type consistency:** Script function names are reused consistently across tasks (`map_doc_path_to_book_path`, `build_summary_markdown`, `build_pandoc_command`).

## Notes on sequencing

- Execute tasks in order (Task 1 -> Task 6).
- Keep commits frequent as listed.
- If PDF dependencies are unavailable locally, continue web tasks and verify PDF in CI first.
