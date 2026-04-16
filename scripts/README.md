# scripts/README

## build-mdbook.ps1

Скрипт собирает книгу `mdBook` из Markdown, используя Docker.

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

