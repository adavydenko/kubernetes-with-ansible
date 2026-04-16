# Диаграммы: исходники и рендер

В этой папке хранятся:

- исходники диаграмм в формате PlantUML: `src/`
- сгенерированные SVG для вставки в учебные материалы: `images/`

## Как обновить изображения

Из корня репозитория выполните:

```powershell
python .\scripts\render-diagram-assets.py
```

Скрипт перегенерирует SVG-файлы из `docs/diagram-assets/src/*.puml` в папку `docs/diagram-assets/images`.

## Где используются

Встроенные изображения и ссылки на `.puml` стоят рядом с тематическим текстом:

- `docs/theory/K8S.md` — диаграммы 1–2 (архитектура, объекты), 6 (типы сервисов)
- `docs/STUDY_GUIDE_OVERVIEW.md` — диаграмма 12 (концептуальный кластер)
- `docs/components/README.md` — диаграмма 3 (роли Ansible)
- `docs/deployment/DEPLOYMENT_GUIDE.md` — диаграммы 4, 5, 13
- `docs/components/storage/LOCAL_STORAGE_SUMMARY.md` — диаграммы 7, 8
- `docs/components/monitoring/MONITORING_SUMMARY.md` — диаграммы 9–11
- `docs/theory/K8S_ORCHESTRATION.md` — диаграмма 14
- `docs/reference/README.md` — диаграмма 15
- `docs/reference/RESOURCES.md` — диаграмма 16
- `docs/learning/LEARNING_GUIDE.md` — навигационная таблица «где открыть» схемы 3–16 и индекс в конце главы

Внутри страниц каждая диаграмма содержит:

- встроенное изображение (`.svg`)
- ссылку на исходник PlantUML (`.puml`)
