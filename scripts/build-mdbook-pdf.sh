#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

IMAGE_TAG="${IMAGE_TAG:-kubernetes-with-ansible-mdbook:0.4.40}"

docker build -t "$IMAGE_TAG" docs
docker run --rm -v "$ROOT:/workspace" -w /workspace "$IMAGE_TAG" build docs

mkdir -p docs/dist
(
  cd docs/book
  command -v weasyprint >/dev/null 2>&1 || {
    echo "weasyprint not found. Install: sudo apt install weasyprint" >&2
    exit 1
  }
  weasyprint print.html ../dist/study-guide.pdf
)

# After docker build, docs/book may be root-owned; use sudo for writes into it.
sudo mkdir -p docs/book/assets
sudo cp docs/dist/study-guide.pdf docs/book/assets/study-guide.pdf
sudo chown "$(id -u):$(id -g)" docs/book/assets/study-guide.pdf

echo "PDF written to docs/dist/study-guide.pdf"
echo "Stable Pages path: docs/book/assets/study-guide.pdf"
