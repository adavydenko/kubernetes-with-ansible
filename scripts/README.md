# scripts/README

## build-mdbook.ps1

Скрипт собирает книгу `mdBook` из Markdown, используя Docker.

### Если PowerShell блокирует запуск скрипта

Запускайте через `Bypass`:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-mdbook.ps1 -RebuildImage
```

### Запуск

Запускайте из **корня репозитория**:

```powershell
cd c:\Projects\kubernetes-with-ansible
.\scripts\build-mdbook.ps1 -RebuildImage
```

### Повторные сборки

Если Docker-образ уже собран:

```powershell
cd c:\Projects\kubernetes-with-ansible
.\scripts\build-mdbook.ps1
```

### Результат

Собранная HTML-книга попадает в:

- `docs/book/`

### PDF (Linux / WSL)

После сборки HTML нужен [WeasyPrint](https://weasyprint.org/). Скрипт:

```bash
chmod +x scripts/build-mdbook-pdf.sh
./scripts/build-mdbook-pdf.sh
```

Файл: `docs/dist/study-guide.pdf`.

Скрипт также копирует PDF в `docs/book/assets/study-guide.pdf` (стабильный URL на GitHub Pages). После `docker run` каталог `docs/book` может принадлежать `root`, поэтому для копирования используется `sudo`.

На Windows без WSL удобнее скачать PDF из артефакта GitHub Actions (workflow `mdBook PDF`).

