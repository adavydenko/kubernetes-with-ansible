name: doc-enhance-technical-markdown-ru
description: Transform technical Markdown files into expanded, more readable Russian-language versions while preserving technical accuracy and original meaning. Use when user wants to improve documentation readability in Russian, expand brief technical descriptions, or enrich technical content with context and explanations for Russian-speaking readers.
---

# Enhance Technical Markdown (RU)

Transform technical Markdown files into expanded, more readable versions with higher readability index while preserving technical accuracy and original meaning. **Output language: Russian.**

## When to Use

- User wants to improve readability of technical documentation **in Russian**
- Need to expand brief technical descriptions into detailed Russian explanations
- User requests to enrich technical content with additional context
- Documentation is too concise and needs more detail
- User mentions "улучшить читаемость", "расширить описание", "обогатить контент", or "сделать понятнее"
- Technical documentation needs better explanations for non-experts
- Converting brief technical notes into more comprehensive Russian documentation
- When you need a textbook format (learning objectives, exercises, knowledge checks) — use `doc-adapt-technical-notes-to-textbook-ru`

## Instructions

### 1. Read and Analyze Source Document

Before transformation:
- Read the entire Markdown file completely
- Identify document structure (headings, sections, lists, tables)
- Note all code blocks, links, anchors, and relative paths
- Understand the technical domain and terminology
- Identify brief descriptions that need expansion
- Note any existing examples or explanations

### 2. Preserve Document Structure

Maintain original structure:
- **Keep all headings** – preserve hierarchy (##, ###, etc.)
- **Preserve section order** – don't reorganize content
- **Maintain lists** – keep bullet points, numbered lists, nested lists
- **Keep tables** – preserve table structure and data
- **Preserve links** – maintain all internal and external links
- **Keep anchors** – if headings change, update corresponding anchors
- **Maintain code blocks** – don't modify code content (only fix obvious typos)
- **Preserve relative paths** – keep all file paths valid

### 3. Enhance Readability

Apply readability improvements:

**Sentence Structure:**
- Use short sentences (12–18 words on average)
- Prefer active voice over passive
- Break long sentences into shorter ones
- Use simple, clear language

**Paragraph Structure:**
- Keep paragraphs focused (3–5 sentences)
- One main idea per paragraph
- Add subheadings to break up long sections
- Use bullet points for lists of related concepts

**Visual Organization:**
- Add subheadings where appropriate
- Use lists for multiple related points
- Add visual breaks between sections
- Use formatting (bold, italic) strategically

### 4. Expand Brief Descriptions

Transform concise statements into detailed explanations:

**Before (brief):**
```markdown
**Automated Deployments**: Using Deployment for gradual application rollout with rollback capability.
```

**After (expanded, Russian):**
```markdown
**Автоматизированные развертывания**: В production-средах приложения должны оставаться доступными непрерывно. При обновлении до новой версии вы не можете просто остановить приложение, обновить компоненты и запустить его заново — это приведёт к простою (периоду недоступности системы). Вместо этого используются автоматизированные подходы к постепенному обновлению (rolling updates) с возможностью быстрого отката к предыдущей версии. Всё это реализуется через ресурс Deployment, который выступает основной единицей развертывания.
```

**Expansion Guidelines:**
- Explain **what** it is (definition/context)
- Explain **why** it's needed (real-world scenarios, problems it solves)
- Explain **how** it works in practice (practical application)
- Mention **risks/limitations** if relevant
- Include **best practices** where applicable
- Add **common mistakes** to avoid
- Provide **verification methods** (how to check if it works)
- Include **examples** when helpful

### 5. Add Context and Explanations

Enrich content with:

**Real-World Context:**
- Explain practical scenarios where concepts apply
- Describe common problems solved by the approach
- Provide industry context and best practices

**Terminology Definitions:**
- Define technical terms when first introduced
- Use domain-specific terminology correctly
- Add brief explanations in parentheses when helpful

**Practical Examples:**
- Add 1–3 line examples where appropriate
- Include practical tips and recommendations
- Add checklists for verification when useful

### 6. Enhance Document Structure

Add helpful elements:

**Introduction:**
- Add a 2–4 sentence overview/context at the start
- Optionally include a brief TL;DR section if the document is long

**Summary:**
- Add a "Quick Summary" section at the end
- Include a "Glossary" of key terms if the document has 5+ technical terms

**Sections:**
- Add subheadings to break up long paragraphs
- Use lists for multiple related concepts
- Add visual separators between major sections

### 7. Maintain Technical Accuracy

Ensure quality:
- **Don't invent facts** – only expand with general principles and common practices
- **Preserve technical terms** – use correct domain terminology
- **Keep code accurate** – don't modify code blocks unnecessarily
- **Maintain links** – ensure all links remain valid
- **Preserve formatting** – keep original indentation and style

### 8. Apply Transformation

Process the document:

1. **Read the source file** completely
2. **Identify expansion points** – brief descriptions, unclear explanations
3. **Expand each point** following expansion guidelines
4. **Enhance readability** – improve sentence and paragraph structure
5. **Add context** – real-world scenarios, examples, best practices
6. **Verify structure** – ensure all links, anchors, and code blocks are preserved
7. **Check accuracy** – verify no invented facts, correct terminology
8. **Output result** – return only the transformed Markdown file

## Best Practices

- ✅ Always preserve original structure and organization
- ✅ Expand brief descriptions with context and explanations
- ✅ Use short, clear sentences (12–18 words)
- ✅ Prefer active voice and simple language
- ✅ Add real-world context and practical scenarios
- ✅ Define technical terms when first introduced
- ✅ Include examples and practical tips where helpful
- ✅ Maintain all links, anchors, and code blocks
- ✅ Don't invent facts – only expand with known principles
- ✅ Keep technical accuracy and correct terminology

## Transformation Pattern (RU)

### Pattern: Brief Description → Expanded Russian Explanation

**Input (brief):**
```markdown
**Feature Name**: Brief one-line description.
```

**Output (expanded, Russian):**
```markdown
**Feature Name**: В реальных сценариях [контекст, почему это важно]. Когда [типичная ситуация], нельзя просто [наивный подход], потому что это приводит к [проблема]. Вместо этого используется [правильный подход], который опирается на [ключевые концепции]. Дополнительно важно учитывать [сопутствующие аспекты]. Всё это реализуется через [механизм], где [компонент] играет роль [роль].
```

## Example Transformation (RU)

### Before (Brief):

```markdown
# Kubernetes Deployment

## Key Features

**Automated Deployments**: Using Deployment for gradual application rollout with rollback capability.

**Scaling**: Horizontal Pod Autoscaler adjusts replica count based on metrics.

**Health Checks**: Liveness and readiness probes monitor container health.
```

### After (Expanded, Russian):

```markdown
# Kubernetes Deployment

В этом документе рассматриваются ключевые возможности механизмов развертывания приложений в Kubernetes, которые обеспечивают надёжное и автоматизированное управление приложениями в production-средах.

## Ключевые возможности

### Автоматизированные развертывания

В production-средах приложения должны оставаться доступными непрерывно. При обновлении до новой версии вы не можете просто остановить приложение, обновить компоненты и запустить его заново — это приведёт к простою (периоду недоступности системы). Вместо этого используются автоматизированные подходы к постепенному обновлению (rolling updates) с возможностью быстрого отката к предыдущей версии. Всё это реализуется через ресурс Deployment, который выступает основной единицей развертывания.

**Основные преимущества:**
- Обновления без простоя
- Автоматический откат при сбоях
- Постепенное переключение трафика на новую версию

### Масштабирование

Нагрузка на приложения может существенно меняться в течение дня. Фиксированное количество реплик не позволяет эффективно обрабатывать всплески трафика и периоды низкой нагрузки. Ручное масштабирование занимает время и не реагирует достаточно быстро. Horizontal Pod Autoscaler (HPA) автоматически регулирует количество реплик подов на основе наблюдаемых метрик, таких как использование CPU, памяти или пользовательские метрики. Это обеспечивает оптимальное использование ресурсов и стабильную производительность.

### Проверки здоровья

Контейнеры могут выходить из строя по разным причинам: краши приложения, зависания, потеря доступности. Без мониторинга состояния Kubernetes может продолжать направлять трафик на неработоспособные контейнеры, что приводит к деградации сервиса. Проверки здоровья (probes) позволяют Kubernetes автоматически обнаруживать проблемы и предпринимать корректирующие действия.
```

## Validation Checklist

Before completing transformation:
- [ ] Original document structure preserved (headings, sections, order)
- [ ] All links and anchors remain valid
- [ ] Code blocks preserved unchanged
- [ ] Brief descriptions expanded with context
- [ ] Readability improved (short sentences, active voice)
- [ ] Technical terms defined when introduced
- [ ] Real-world context and examples added
- [ ] No invented facts – only expanded with known principles
- [ ] Technical accuracy maintained
- [ ] Document is more readable and comprehensive for Russian readers

## Prompt Template for LLM (RU)

When transforming documents using LLM, use this template:

```
Ты — технический редактор и архитектор, улучшающий техническую документацию для инженеров и SRE-команд.

**Задача:** Преобразовать переданный Markdown-файл в более подробную, понятную и практичную версию на русском языке с улучшенной читаемостью, сохранив техническую точность и исходный смысл.

**Требования:**
- Сохраняй исходную структуру Markdown: порядок секций, заголовки, списки, таблицы, ссылки и якоря
- Не изменяй содержимое кодовых блоков (кроме очевидных опечаток)
- Не выдумывай факты: если точные данные отсутствуют, расширяй за счёт общих принципов, типичных практик и реалистичных сценариев без спекуляций
- Улучшай читаемость: короткие предложения (12–18 слов), активный залог, простой словарь, подзаголовки, маркированные списки, визуальные «разделители» между блоками
- Расширяй краткие тезисы: что это, зачем нужно, как применяется на практике, риски/ограничения, лучшие практики, типичные ошибки, как проверить результат, примеры
- Сохраняй терминологию домена; при первом упоминании давай краткое определение
- Поддерживай валидность ссылок, якорей и относительных путей; если меняется заголовок, обнови соответствующий якорь
- Сохраняй исходные отступы и форматирование; не меняй стиль табуляции/пробелов
- Не удаляй исходные пункты — дополняй и расширяй их
- Язык: русский, деловой дружелюбный тон, без жаргона и эмодзи

**Что добавить:**
- В начале — 2–4 предложения контекста/обзора и при необходимости короткий TL;DR
- По мере необходимости — мини-примеры (1–3 строки), практические советы, чек-листы для проверки
- В конце — «Краткое резюме» и небольшой «Глоссарий» ключевых терминов (если терминов 5+)

**Как переписывать отдельные пункты:**
- Было (тезис): «Automated Deployments: Using Deployment for gradual application rollout with rollback capability.»
- Стало (расширенно): «Автоматизированные развертывания: в production-средах приложения должны оставаться доступными непрерывно. При обновлении до новой версии вы не можете просто остановить приложение — это приведёт к простою (периоду недоступности системы). Вместо этого используются механизмы постепенного обновления (rolling updates) с возможностью быстрого отката. Всё это реализуется через ресурс Deployment, который выступает основной единицей развертывания.»

**Проверки качества перед выводом:**
- Точность: нет ложных фактов, определения корректны
- Читаемость: текст легко сканировать; абзацы короткие; есть подзаголовки и списки
- Полезность: добавлены примеры, риски, лучшие практики, способы проверки
- Формат: валидный Markdown; кодовые блоки и таблицы не повреждены

**Вход:** Ниже приведён исходный Markdown-документ.
**Выход:** Верни только финальную, преобразованную версию Markdown без дополнительных комментариев и преамбул. Не добавляй ничего, кроме обновлённого содержимого файла.
```

## References

- Agent Skills Standard: https://agentskills.io
- Cursor Skills Documentation: https://cursor.com/docs/context/skills
- Technical Writing Best Practices: Clear, concise technical communication

