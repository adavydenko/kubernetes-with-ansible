from __future__ import annotations

import subprocess
from pathlib import Path


DIAGRAM_FILES = [
    "diagram-01-kubernetes-architecture",
    "diagram-02-kubernetes-objects-hierarchy",
    "diagram-03-ansible-roles-structure",
    "diagram-04-cluster-deployment-process",
    "diagram-05-network-architecture",
    "diagram-06-kubernetes-service-types",
    "diagram-07-storage-architecture",
    "diagram-08-persistentvolume-lifecycle",
    "diagram-09-monitoring-architecture",
    "diagram-10-monitoring-data-flow",
    "diagram-11-monitoring-components",
    "diagram-12-cluster-conceptual-view",
    "diagram-13-troubleshooting-process",
    "diagram-14-security-principles",
    "diagram-15-advanced-topics-map",
    "diagram-16-kubernetes-certifications-map",
]


def render_one(repo_root: Path, src_puml: Path, images_dir: Path, output_stem: str) -> None:
    src_dir = src_puml.parent
    for stale_svg in src_dir.glob("*.svg"):
        stale_svg.unlink()

    docker_mount = str(repo_root).replace("\\", "/")
    container_file = f"/work/docs/diagram-assets/src/{src_puml.name}"
    command = [
        "docker",
        "run",
        "--rm",
        "-v",
        f"{docker_mount}:/work",
        "plantuml/plantuml",
        "-tsvg",
        container_file,
    ]
    subprocess.run(command, check=True)

    generated_svgs = list(src_dir.glob("*.svg"))
    if len(generated_svgs) != 1:
        raise RuntimeError(f"Не удалось однозначно определить SVG для {src_puml.name}")

    target = images_dir / f"{output_stem}.svg"
    generated_svgs[0].replace(target)


def main() -> None:
    repo_root = Path(__file__).resolve().parent.parent
    src_dir = repo_root / "docs" / "diagram-assets" / "src"
    images_dir = repo_root / "docs" / "diagram-assets" / "images"
    images_dir.mkdir(parents=True, exist_ok=True)

    for existing in images_dir.glob("*.svg"):
        existing.unlink()

    for stem in DIAGRAM_FILES:
        src_puml = src_dir / f"{stem}.puml"
        if not src_puml.exists():
            raise FileNotFoundError(f"Не найден файл: {src_puml}")
        render_one(repo_root, src_puml, images_dir, stem)

    print("Готово: SVG сгенерированы в docs/diagram-assets/images")


if __name__ == "__main__":
    main()
