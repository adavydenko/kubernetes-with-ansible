name: edu-create-practical-exercises
description: Create practical exercises with clear objectives, practical importance justification, success criteria, and hints (not full solutions). Use when creating educational materials, tutorials, or training content.
---

# Create Practical Exercises

Create practical exercises with clear objectives, practical importance justification, success criteria, and helpful hints (not full solutions).

## When to Use

- Creating educational materials or tutorials
- Adding exercises to learning guides
- Creating training content
- User mentions "exercises", "practice", "hands-on", or "lab"
- Need to reinforce learning with practical application

## Instructions

### 1. Define Exercise Objective

For each exercise:
- Identify the learning goal
- Determine what skill/concept it teaches
- Set clear, measurable objectives
- Define target difficulty level (beginner/intermediate/advanced)

### 2. Write Exercise Description

Create clear instructions:
- **Title**: Descriptive and specific
- **Objective**: What the student will learn/achieve
- **Prerequisites**: What knowledge is needed
- **Steps**: Clear, numbered instructions
- **Expected Result**: What success looks like

### 3. Add Practical Importance

**Critical**: Every exercise must include 1-3 sentences explaining:
- Why this exercise is important
- What real-world problem it addresses
- How it relates to professional practice
- What practical skill it develops

Example:
```markdown
**Практическая важность:** Это упражнение развивает навыки 
настройки RBAC, которые критически важны для обеспечения 
безопасности в production-окружениях. Понимание принципов 
разграничения доступа необходимо каждому DevOps-инженеру.
```

### 4. Create Success Criteria

Define clear success criteria:
- [ ] Specific, measurable outcomes
- [ ] Observable results
- [ ] Testable conditions
- [ ] Multiple checkpoints for complex exercises

### 5. Provide Hints (Not Solutions)

For self-study exercises:
- **Hints**: Point in right direction without giving answer
- **Code snippets**: Show structure, not full solution
- **Links**: Reference relevant documentation
- **Common pitfalls**: Warn about typical mistakes

Example:
```markdown
### 💡 Подсказки
- Используйте `kubectl create role` для создания роли
- Обратите внимание на параметр `--verb` для действий
- Проверьте документацию: [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
```

### 6. Structure Self-Study Exercises

For advanced/self-study exercises:
```markdown
## 🎯 Задача
[Clear objective]

## 📋 Требования
- [Requirement 1]
- [Requirement 2]

## 💡 Подсказки
[Hints and code snippets]

## 🔗 Полезные ресурсы
- [Link to documentation]
- [Link to examples]

## ✅ Критерии успеха
- [ ] Criterion 1
- [ ] Criterion 2
```

## Best Practices

- ✅ Always justify practical importance (1-3 sentences)
- ✅ Provide hints, not full solutions
- ✅ Create clear success criteria
- ✅ Link to relevant documentation
- ✅ Include code examples in hints (not full solutions)
- ✅ Warn about common pitfalls
- ✅ Grade difficulty appropriately
- ✅ Test all commands/examples before including

## Exercise Structure Patterns

### Basic Exercise
```markdown
## Exercise 1: [Title]

**Цель:** [What student will learn]

**Практическая важность:** [1-3 sentences]

**Шаги:**
1. [Step 1]
2. [Step 2]

**Проверка:**
- [ ] [Success criterion 1]
- [ ] [Success criterion 2]
```

### Advanced Self-Study Exercise
```markdown
## Exercise X: [Title]

**Практическая важность:** [1-3 sentences]

### 🎯 Задача
[Objective]

### 📋 Требования
- [Requirement]

### 💡 Подсказки
```yaml
# Example structure, not full solution
apiVersion: v1
kind: Role
# ... complete yourself
```

### 🔗 Полезные ресурсы
- [Documentation link]

### ✅ Критерии успеха
- [ ] [Criterion]
```

## Practical Importance Templates

### Security Exercises
"Это упражнение развивает навыки [skill], которые критически важны для [use case]. Понимание [concept] необходимо для [professional context]."

### Infrastructure Exercises
"Данное упражнение демонстрирует практическое применение [technology] в реальных сценариях. Навыки [skill] востребованы при [professional scenario]."

### Development Exercises
"Это упражнение помогает освоить [concept], который является основой для [advanced topic]. Практический опыт работы с [tool] необходим для [professional task]."

## What NOT to Do

- ❌ Don't create exercises without practical importance justification
- ❌ Don't provide full solutions (use hints instead)
- ❌ Don't skip success criteria
- ❌ Don't use untested commands/examples
- ❌ Don't create exercises without clear objectives
- ❌ Don't forget to link to documentation

## Validation Checklist

Before completing:
- [ ] Exercise has clear objective
- [ ] Practical importance is justified (1-3 sentences)
- [ ] Success criteria are defined
- [ ] Hints are provided (not full solutions)
- [ ] All commands/examples are tested
- [ ] Links to documentation are included
- [ ] Difficulty level is appropriate
- [ ] Prerequisites are listed

