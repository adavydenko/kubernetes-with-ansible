name: doc-adapt-technical-notes-to-textbook-ru
description: Transform technical notes and brief documentation into comprehensive Russian-language educational textbooks for students. Use when user wants to convert technical notes into learning materials in Russian, expand brief technical descriptions for educational purposes, or create student-friendly Russian textbooks with explanations, examples, and exercises.
---

# Adapt Technical Notes to Textbook (RU)

Transform technical notes and brief documentation into comprehensive educational textbooks suitable for students, with expanded explanations, practical examples, learning objectives, and assessment materials. **Output language: Russian.**

## When to Use

- User wants to convert technical notes into educational materials in Russian
- Need to adapt technical documentation for Russian-speaking students
- User requests to create a textbook or learning guide from notes
- Technical material is too brief and needs educational expansion
- User mentions "учебник", "учебные материалы", "для студентов", "учебное пособие", or "teaching materials"
- Converting expert-level notes into beginner-friendly Russian content
- Creating course materials from technical documentation
- When you only need to improve readability without educational structure — use `doc-enhance-technical-markdown-ru`
- Use for a single document; for organizing multiple materials into a course use `edu-structure-learning-materials`

## Instructions

### 1. Analyze Source Material

Before transformation:
- Read the entire source document completely
- Identify document structure (headings, sections, lists, tables, code blocks)
- Note all technical terms and concepts that need explanation
- Identify brief descriptions that need expansion
- Understand the technical domain and target audience level
- Note existing examples, links, and references
- Determine learning objectives for each section

### 2. Design Educational Structure

Create logical learning progression:

**Document Structure:**
- **Introduction** - overview, learning objectives, prerequisites
- **Theoretical Foundation** - core concepts with explanations
- **Practical Examples** - step-by-step tutorials with explanations
- **Knowledge Checks** - questions and exercises
- **Additional Resources** - links to documentation, videos, courses
- **Glossary** - key terms definitions
- **FAQ** - common questions and answers
- **Troubleshooting** - common problems and solutions

**Learning Progression:**
- Start with basics and build complexity gradually
- Each section should have clear learning objectives
- Connect concepts logically (prerequisites → concepts → application)
- Include practical exercises after each major concept

### 3. Expand Technical Content

Transform brief technical notes into educational explanations:

**Expansion Pattern:**
1. **What** - clear definition and context
2. **Why** - real-world problems it solves, use cases
3. **How** - step-by-step explanation with examples
4. **When** - appropriate scenarios for application
5. **Best Practices** - recommendations and tips
6. **Common Mistakes** - what to avoid

**Example Transformation:**

**Before (technical note):**
```markdown
MetalLB - load balancer для bare metal кластеров
IP пул: 10.0.2.240-10.0.2.250
Установка: ansible-playbook --tags metallb
```

**After (educational textbook):**
```markdown
## Что такое MetalLB?

MetalLB - это специальный инструмент, который решает проблему балансировки нагрузки в Kubernetes кластерах, развернутых на обычных серверах (bare metal), а не в облаке.

### Зачем это нужно?

В облачных средах (AWS, GCP, Azure) Kubernetes автоматически создает внешние IP-адреса для сервисов типа LoadBalancer. Но что делать, если у вас кластер на собственных серверах? MetalLB приходит на помощь!

### Как это работает?

1. **IP Address Pool** - резервирует диапазон IP-адресов (в нашем случае 10.0.2.240-10.0.2.250)
2. **Layer 2 Mode** - использует стандартные сетевые протоколы для назначения IP
3. **Автоматическое назначение** - когда создается LoadBalancer сервис, MetalLB автоматически назначает ему свободный IP

### Практическое применение

Представьте, что у вас есть веб-приложение, которое должно быть доступно из интернета. Без MetalLB это невозможно на bare metal кластере. С MetalLB - это делается одной командой!

## Установка MetalLB

### Шаг 1: Запуск Ansible playbook
```bash
ansible-playbook -i inventory.yml site.yml --tags metallb
```

**Что происходит:** Ansible автоматически устанавливает MetalLB компоненты в кластер Kubernetes.

### Шаг 2: Проверка установки
```bash
kubectl get pods -n metallb-system
```

**Ожидаемый результат:** Все поды MetalLB должны быть в статусе Running.

### Шаг 3: Создание тестового приложения
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

**Что происходит:** Создается тестовое приложение и LoadBalancer сервис, которому MetalLB автоматически назначит внешний IP.

## Проверь свои знания

1. Что такое bare metal кластер?
2. Почему MetalLB нужен только для bare metal?
3. Какой диапазон IP используется в нашем примере?
4. Что происходит при создании LoadBalancer сервиса?

## Дополнительные ресурсы

- [Официальная документация MetalLB](https://metallb.universe.tf/)
- [Видео: Understanding MetalLB](https://youtube.com/...)
- [Практикум: Load Balancing in Kubernetes](https://katacoda.com/...)
```

### 4. Add Educational Elements

Enrich content with educational components:

**Learning Objectives (Цели обучения):**
- Add clear learning objectives at the start of each major section
- Format: "После изучения этого раздела вы сможете:"
- List 3-5 specific skills or knowledge points

**Practical Examples:**
- Include 2-3 concrete examples per major concept
- Show real-world scenarios
- Provide step-by-step walkthroughs
- Include expected outputs and verification steps

**Knowledge Checks (Проверка знаний):**
- Add questions after each section (3-5 questions)
- Mix question types: multiple choice, short answer, practical tasks
- Include difficulty levels: basic, intermediate, advanced
- Provide answers or hints where appropriate

**Visual Aids:**
- Describe diagrams and visualizations (architecture, flowcharts)
- Use tables for comparisons
- Include code examples with comments
- Add screenshots descriptions where helpful

**Glossary (Глоссарий):**
- Define all technical terms when first introduced
- Create comprehensive glossary at the end
- Include pronunciation guides for complex terms
- Cross-reference terms throughout document

### 5. Enhance Readability

Apply educational writing principles:

**Language:**
- Use accessible language (avoid jargon, explain when necessary)
- Prefer active voice
- Keep sentences short (12-18 words average)
- Use simple, clear vocabulary
- Explain complex concepts in simple terms first

**Structure:**
- Break long paragraphs into shorter ones (3-5 sentences)
- Use subheadings to organize content
- Use bullet points for lists of concepts
- Add visual breaks between sections
- Use formatting (bold, italic) strategically

**Progression:**
- Start with basics, build to advanced
- Connect new concepts to previously learned ones
- Use analogies for complex technical concepts
- Provide context before diving into details

### 6. Add Practical Exercises

Create hands-on learning opportunities:

**Exercise Types:**
- **Guided Practice** - step-by-step tutorials with explanations
- **Independent Practice** - tasks to complete without full instructions
- **Problem Solving** - real-world scenarios to solve
- **Experimentation** - tasks encouraging exploration
- **Review Questions** - knowledge checks

**Exercise Structure:**
- Clear objective
- Prerequisites
- Step-by-step instructions (for guided practice)
- Expected results
- Verification steps
- Troubleshooting tips

### 7. Include Additional Resources

Add learning support materials:

**Resource Types:**
- Official documentation links
- Video tutorials
- Interactive labs (Katacoda, Play with Kubernetes)
- Community forums
- Related courses
- Books and articles

**Resource Organization:**
- Group by topic
- Indicate difficulty level
- Note prerequisites
- Include brief descriptions

### 8. Create Assessment Materials

Add knowledge validation:

**Question Types:**
- Multiple choice (with explanations)
- Short answer
- Practical tasks
- Essay questions (for advanced topics)
- True/False with explanations

**Assessment Structure:**
- Questions aligned with learning objectives
- Mix of difficulty levels
- Answers or answer keys
- Explanations for correct answers

### 9. Apply Transformation

Process the document:

1. **Read source file** completely
2. **Identify learning objectives** for each section
3. **Expand technical notes** following expansion pattern
4. **Add educational elements** (objectives, examples, exercises)
5. **Enhance readability** (language, structure, progression)
6. **Create practical exercises** for key concepts
7. **Add resources and glossary**
8. **Include assessment materials**
9. **Verify structure** - ensure all links, code blocks preserved
10. **Check educational value** - ensure material is suitable for students

## Best Practices

- ✅ Start with learning objectives for each section
- ✅ Explain concepts before diving into technical details
- ✅ Use real-world analogies for complex technical concepts
- ✅ Provide step-by-step examples with explanations
- ✅ Include knowledge checks after each major concept
- ✅ Create practical exercises aligned with learning objectives
- ✅ Define technical terms when first introduced
- ✅ Maintain technical accuracy while improving accessibility
- ✅ Preserve all code blocks, links, and technical details
- ✅ Structure content for progressive learning (basics → advanced)
- ✅ Include troubleshooting and common mistakes sections
- ✅ Add visual aids descriptions and diagrams

## Transformation Pattern (RU)

### Pattern: Technical Note → Educational Section

**Input (technical note):**
```markdown
## Feature Name
Brief technical description.
Command: `example-command`
```

**Output (educational textbook, Russian):**
```markdown
## Feature Name

### Цели обучения
После изучения этого раздела вы сможете:
- Понимать назначение и применение Feature Name
- Настраивать Feature Name в практических сценариях
- Решать типичные проблемы при работе с Feature Name

### Что это такое?

[Четкое определение с контекстом]

### Зачем это нужно?

[Какие реальные задачи решает, сценарии применения]

### Как это работает?

[Пошаговое объяснение с примерами]

### Практический пример

```bash
example-command
```

**Что происходит:** [Объяснение, что делает команда]

**Ожидаемый результат:** [Что должно получиться]

### Проверь свои знания

1. [Вопрос 1]
2. [Вопрос 2]
3. [Вопрос 3]

### Практическое задание

**Цель:** [Цель задания]

**Шаги:**
1. [Шаг 1]
2. [Шаг 2]
3. [Шаг 3]

**Проверка:** [Как проверить результат]

### Дополнительные ресурсы

- [Ресурс 1]
- [Ресурс 2]
```

## Example Transformation (RU)

### Before (Technical Note):

```markdown
# Kubernetes Deployment

## Key Features

**Automated Deployments**: Using Deployment for gradual application rollout with rollback capability.

**Scaling**: Horizontal Pod Autoscaler adjusts replica count based on metrics.

**Health Checks**: Liveness and readiness probes monitor container health.
```

### After (Educational Textbook, Russian):

```markdown
# Kubernetes Deployment

Этот раздел познакомит вас с механизмами развертывания приложений в Kubernetes. Вы узнаете, как Kubernetes обеспечивает надежное и автоматизированное управление приложениями в production-средах.

## Цели обучения

После изучения этого раздела вы сможете:
- Понимать принципы автоматизированного развертывания в Kubernetes
- Настраивать автоматическое масштабирование приложений
- Конфигурировать проверки здоровья контейнеров
- Применять лучшие практики для production-развертываний

## Ключевые концепции

### Автоматизированные развертывания

В production-средах приложения должны оставаться доступными непрерывно. Когда вы обновляете приложение до новой версии, вы не можете просто остановить его, обновить компоненты и перезапустить - это приведет к простою (периоду недоступности системы).

**Решение:** Kubernetes использует автоматизированные механизмы постепенного обновления (rolling updates) через ресурс Deployment.

**Как это работает:**
1. Kubernetes создает новые поды с новой версией приложения
2. Постепенно перенаправляет трафик на новые поды
3. Удаляет старые поды после успешного переключения
4. При проблемах автоматически откатывает изменения

**Практический пример:**

```bash
kubectl create deployment my-app --image=nginx:1.20
kubectl set image deployment/my-app nginx=nginx:1.21
```

**Что происходит:** Kubernetes начинает rolling update, создавая новые поды с nginx:1.21 и постепенно заменяя старые.

**Проверка:**
```bash
kubectl rollout status deployment/my-app
kubectl get pods -l app=my-app
```

### Масштабирование

Приложения испытывают различную нагрузку в течение дня. Статическое количество реплик не может эффективно обрабатывать всплески трафика или периоды низкой нагрузки.

**Решение:** Horizontal Pod Autoscaler (HPA) автоматически регулирует количество реплик подов на основе метрик (CPU, память, кастомные метрики).

**Как это работает:**
1. HPA мониторит указанные метрики с заданными интервалами
2. Сравнивает текущие значения с целевыми порогами
3. Увеличивает количество реплик, если метрики превышают цели
4. Уменьшает количество реплик, если метрики ниже целей

**Практический пример:**

```bash
kubectl autoscale deployment my-app --cpu-percent=70 --min=2 --max=10
```

**Что происходит:** HPA будет поддерживать использование CPU на уровне 70%, автоматически масштабируя от 2 до 10 реплик.

### Проверки здоровья

Контейнеры могут выходить из строя различными способами: краши приложения, зависания, или становятся неотзывчивыми. Без мониторинга здоровья Kubernetes может продолжать направлять трафик на неработающие контейнеры.

**Решение:** Kubernetes использует проверки здоровья (probes) для непрерывного мониторинга состояния контейнеров.

**Типы проверок:**
- **Liveness probe** - определяет, работает ли контейнер. При неудаче Kubernetes перезапускает контейнер.
- **Readiness probe** - определяет, готов ли контейнер принимать трафик. При неудаче Kubernetes прекращает отправку трафика до успешной проверки.

**Практический пример:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: app
    image: nginx
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
```

## Проверь свои знания

1. Почему нельзя просто остановить приложение для обновления в production?
2. Как работает rolling update в Kubernetes?
3. Какие метрики может использовать HPA для масштабирования?
4. В чем разница между liveness и readiness probe?
5. Как Kubernetes обрабатывает неудачную проверку здоровья?

## Практические задания

### Задание 1: Rolling Update

**Цель:** Научиться выполнять безопасное обновление приложения.

**Шаги:**
1. Создайте deployment с nginx:1.20
2. Обновите до nginx:1.21
3. Наблюдайте за процессом обновления
4. Проверьте статус обновления

**Проверка:** Все поды должны быть в статусе Running с новой версией.

### Задание 2: Автомасштабирование

**Цель:** Настроить автоматическое масштабирование приложения.

**Шаги:**
1. Создайте deployment с ресурсными ограничениями
2. Настройте HPA для масштабирования по CPU
3. Создайте нагрузку на приложение
4. Наблюдайте за автоматическим масштабированием

**Проверка:** Количество реплик должно увеличиваться при нагрузке.

## Глоссарий

- **Deployment** - ресурс Kubernetes для управления развертыванием и обновлением приложений
- **Rolling Update** - стратегия обновления, при которой новые версии постепенно заменяют старые
- **HPA (Horizontal Pod Autoscaler)** - компонент Kubernetes для автоматического масштабирования
- **Liveness Probe** - проверка, определяющая, работает ли контейнер
- **Readiness Probe** - проверка, определяющая, готов ли контейнер принимать трафик

## Дополнительные ресурсы

- [Официальная документация: Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
-.MarshalJSON
