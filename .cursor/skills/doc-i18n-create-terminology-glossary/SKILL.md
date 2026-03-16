name: doc-i18n-create-terminology-glossary
description: Create and maintain a terminology glossary for consistent translations across project documentation. Use when starting translation work, when terminology inconsistencies are found, or when user requests a glossary for technical terms.
---

# Create Terminology Glossary

Create and maintain a comprehensive terminology glossary to ensure consistent translations across all project documentation.

## When to Use

- Starting translation work on a project
- Finding terminology inconsistencies in translations
- User requests a glossary or term reference
- Need to standardize technical term translations
- Working with multiple documents that need consistent terminology
- User mentions "glossary", "terminology", or "consistent terms"
- When you need a reference glossary with definitions and examples only (no translation) — use `doc-i18n-glossary-generator`

## Instructions

### 1. Extract Technical Terms

From existing documentation:
- Identify all technical terms and concepts
- Look for domain-specific terminology (Kubernetes, Ansible, DevOps, etc.)
- Find terms that have multiple possible translations
- Note terms used in code vs. documentation
- Identify acronyms and abbreviations

### 2. Categorize Terms

Organize terms by category:
- **Kubernetes terms**: Pod, Service, Deployment, Namespace
- **DevOps terms**: CI/CD, deployment, provisioning
- **Infrastructure terms**: Load balancer, storage, networking
- **Tool names**: kubectl, Ansible, MetalLB (usually not translated)
- **General technical terms**: configuration, installation, setup

### 3. Determine Standard Translations

For each term:
- Research standard translations in target language
- Consider context (code vs. documentation)
- Check existing project usage
- Decide on single standard translation
- Note when term should NOT be translated (e.g., tool names)

### 4. Create Glossary File

Create structured glossary file:

```yaml
# .cursor/skills/doc-i18n-translate-technical-documentation/resources/glossary.yml
terms:
  kubernetes:
    - english: "Deployment"
      russian: "Развертывание"
      context: "process"
      notes: "When referring to deployment process"
    - english: "Deployment"
      russian: "Deployment"
      context: "kubernetes_object"
      notes: "When referring to K8s Deployment object"
    - english: "Pod"
      russian: "Pod"
      context: "kubernetes_object"
      notes: "Standard term, not translated"
    - english: "Service"
      russian: "Сервис"
      context: "kubernetes_object"
      notes: "Kubernetes Service object"
    - english: "Namespace"
      russian: "Пространство имен"
      context: "kubernetes_object"
      notes: "Can also use 'Namespace' in technical context"
  
  infrastructure:
    - english: "Load Balancer"
      russian: "Балансировщик нагрузки"
      context: "networking"
    - english: "Storage Class"
      russian: "Класс хранилища"
      context: "kubernetes_storage"
    - english: "Persistent Volume"
      russian: "Постоянный том"
      context: "kubernetes_storage"
  
  devops:
    - english: "Deployment Guide"
      russian: "Руководство по развертыванию"
      context: "documentation"
    - english: "Setup"
      russian: "Настройка"
      context: "process"
    - english: "Configuration"
      russian: "Конфигурация"
      context: "general"
    - english: "Installation"
      russian: "Установка"
      context: "process"
  
  tools:
    - english: "kubectl"
      russian: "kubectl"
      context: "tool_name"
      notes: "Tool names not translated"
    - english: "Ansible"
      russian: "Ansible"
      context: "tool_name"
    - english: "MetalLB"
      russian: "MetalLB"
      context: "tool_name"
  
  common_phrases:
    - english: "Run the command"
      russian: "Выполните команду"
    - english: "Configuration file"
      russian: "Файл конфигурации"
    - english: "Prerequisites"
      russian: "Предварительные требования"
    - english: "Troubleshooting"
      russian: "Устранение неполадок"
    - english: "Step-by-step"
      russian: "Пошаговый"
```

### 5. Document Translation Rules

Create translation rules file:

```markdown
# Translation Rules

## Never Translate
- Tool names: kubectl, Ansible, MetalLB, Prometheus
- Command names: get, apply, create, delete
- File extensions: .yaml, .yml, .md, .sh
- Environment variables: $HOME, $PATH
- Code syntax and structure

## Always Translate
- Document titles and headers
- Instructions and descriptions
- Error messages and troubleshooting text
- Comments in code (when helpful)

## Context-Dependent
- "Deployment" → "Развертывание" (process) or "Deployment" (K8s object)
- "Service" → "Сервис" (general) or "Service" (K8s object in code context)
```

### 6. Apply Glossary to Translations

When translating:
- Reference glossary for each term
- Use standard translation consistently
- Note context when term has multiple meanings
- Update glossary if new terms discovered

### 7. Maintain Glossary

Keep glossary updated:
- Add new terms as they appear
- Resolve conflicts when multiple translations exist
- Update based on project conventions
- Review periodically for consistency

## Best Practices

- ✅ One source of truth for terminology
- ✅ Document context for ambiguous terms
- ✅ Separate tool names from concepts
- ✅ Include notes for special cases
- ✅ Organize by category for easy lookup
- ✅ Review and update regularly
- ✅ Use glossary consistently across all translations

## Glossary Structure

### Recommended File Location
```
.cursor/skills/doc-i18n-translate-technical-documentation/resources/
├── glossary.yml              # Main glossary file
└── translation-rules.md      # Translation rules and guidelines
```

### Alternative Locations
- Project root: `.cursor/terminology.yml`
- Documentation: `docs/reference/glossary.yml`
- Skills directory: `.cursor/skills/doc-i18n-translate-technical-documentation/resources/glossary.yml`

## Common Terminology Patterns

### Kubernetes Terms
- Pod → Pod (not translated)
- Service → Сервис or Service (context-dependent)
- Deployment → Развертывание (process) or Deployment (object)
- Namespace → Пространство имен
- ConfigMap → ConfigMap or Конфигурационная карта
- Secret → Secret or Секрет

### Infrastructure Terms
- Load Balancer → Балансировщик нагрузки
- Storage Class → Класс хранилища
- Persistent Volume → Постоянный том
- Node → Узел
- Cluster → Кластер

### Process Terms
- Deployment → Развертывание
- Installation → Установка
- Configuration → Конфигурация
- Setup → Настройка
- Provisioning → Подготовка

## Example Workflow

1. **Extract**: Scan existing documentation for technical terms
2. **Categorize**: Group terms by domain (Kubernetes, DevOps, etc.)
3. **Research**: Find standard translations for each term
4. **Decide**: Choose single translation per term/context
5. **Document**: Create glossary.yml with all terms
6. **Apply**: Use glossary in all translations
7. **Maintain**: Update as new terms appear

## Validation Checklist

- [ ] All common terms documented
- [ ] Context noted for ambiguous terms
- [ ] Tool names marked as non-translatable
- [ ] Glossary organized by category
- [ ] Translation rules documented
- [ ] Glossary accessible to translation process
- [ ] Consistent usage across documents

## Related Skills

- `doc-i18n-glossary-generator` - For reference glossaries with definitions and examples (no translation), use this skill

## References

- [Kubernetes Glossary](https://kubernetes.io/docs/reference/glossary/)
- [Technical Writing: Terminology](https://developers.google.com/tech-writing/one/words)

