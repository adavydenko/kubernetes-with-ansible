name: doc-i18n-translate-technical-documentation
description: Translate technical documentation (Markdown, README, guides) while preserving code integrity, commands, and configuration syntax. Use when translating deployment guides, API documentation, setup instructions, or any technical content that contains code blocks, commands, or configuration files.
---

# Translate Technical Documentation

Safely translate technical documentation from one language to another while preserving all code blocks, commands, file paths, and configuration syntax to ensure functionality remains intact.

## When to Use

- User requests translation of technical documentation
- Translating README files, deployment guides, or API documentation
- Localizing project documentation (e.g., English to Russian)
- User mentions "translate", "localize", or "convert to [language]"
- Need to translate documentation while keeping code working

## Instructions

### 1. Analyze Document Structure

Before starting translation:
- Read the entire document to understand structure
- Identify different content types:
  - **Code blocks**: bash, yaml, json, python, etc.
  - **Inline code**: commands, file paths, variables
  - **Markdown elements**: headers, links, lists, tables
  - **Text content**: descriptions, instructions, comments
- Map all sections and their purposes

### 2. Identify Non-Translatable Elements

Create inventory of elements that must NOT be translated:

#### Code Blocks
- All code in fenced blocks (```bash, ```yaml, ```json, etc.)
- Commands and their syntax
- Configuration file contents
- Scripts and automation code

#### Inline Code Elements
- File names and paths: `config.yaml`, `/usr/local/bin`
- Command names: `kubectl`, `ansible-playbook`, `docker`
- Command flags: `--output`, `-f`, `--all-namespaces`
- Environment variables: `$HOME`, `$PATH`, `${VARIABLE}`
- Package names: `nginx`, `prometheus`, `metallb`
- API endpoints and URLs
- Placeholders: `{variable}`, `<placeholder>`, `[optional]`

#### Technical Identifiers
- Namespace names: `metallb-system`, `kube-system`
- Resource names: `nginx-demo-service`
- YAML keys and structure
- JSON structure and keys

### 3. Translate Text Content

Translate only human-readable content:

#### Always Translate
- ✅ Document titles and headers
- ✅ Section descriptions and explanations
- ✅ Instructions and step-by-step guides
- ✅ Comments in code (if appropriate for target language)
- ✅ Error messages and troubleshooting text
- ✅ Lists and bullet points (text content)
- ✅ Table headers and cell content (not structure)
- ✅ Notes, warnings, and tips

#### Translate with Care
- ⚠️ Comments in code: Consider if translation helps or hinders
- ⚠️ Code examples: Translate comments but preserve code
- ⚠️ File paths in text: Keep paths but translate descriptions

### 4. Preserve Code Integrity

For each code block:
- Keep all code exactly as-is
- Preserve indentation and formatting
- Maintain syntax correctness
- Keep all commands executable
- Preserve configuration file structure

Example:
```bash
# This comment can be translated
# Этот комментарий можно перевести
kubectl get pods --all-namespaces  # Command stays unchanged
```

### 5. Adapt Technical Terminology

Use consistent terminology:
- Create or reference terminology glossary
- Use standard translations for technical terms
- Maintain consistency across document
- Adapt terms to target language conventions

Common Kubernetes/DevOps terms:
- "Deployment" → "Развертывание" (process) or "Deployment" (K8s object)
- "Service" → "Сервис" or "Service" (K8s object)
- "Pod" → "Pod" (standard term)
- "Load Balancer" → "Балансировщик нагрузки"
- "Namespace" → "Пространство имен" or "Namespace"

### 6. Maintain Markdown Structure

- Preserve all Markdown syntax
- Keep link structure (update link text, preserve URLs)
- Maintain table structure
- Preserve code block language identifiers
- Keep heading hierarchy

### 7. Update Internal Links

If translating to different language:
- Update link text to translated version
- Preserve relative paths
- Update anchor links if headers changed
- Verify all links still work

### 8. Validate Translation

After translation:
- Verify all code blocks are intact
- Check that commands are still executable
- Ensure Markdown syntax is valid
- Test that file paths are correct
- Verify no code was accidentally translated
- Check that all links work

## Best Practices

- ✅ Always preserve code blocks completely
- ✅ Translate comments in code when helpful
- ✅ Use consistent terminology throughout
- ✅ Maintain original document structure
- ✅ Test code examples after translation
- ✅ Keep technical terms consistent with project glossary
- ✅ Preserve all file paths and URLs
- ✅ Maintain formatting and indentation

## Common Patterns

### Pattern 1: Command with Translated Comment
```bash
# Original:
# Run the deployment command
kubectl apply -f deployment.yaml

# Translated (Russian):
# Выполните команду развертывания
kubectl apply -f deployment.yaml
```

### Pattern 2: Configuration File
```yaml
# Original:
# Configuration for MetalLB
metallb_ip_pool:
  start: "10.0.2.240"
  end: "10.0.2.250"

# Translated (Russian):
# Конфигурация для MetalLB
metallb_ip_pool:
  start: "10.0.2.240"
  end: "10.0.2.250"
```

### Pattern 3: Inline Code in Text
```markdown
# Original:
Edit the `config.yaml` file to change settings.

# Translated (Russian):
Отредактируйте файл `config.yaml` для изменения настроек.
```

## What NOT to Do

- ❌ Don't translate code, commands, or file paths
- ❌ Don't translate YAML keys or JSON structure
- ❌ Don't translate package names or tool names
- ❌ Don't translate environment variables
- ❌ Don't modify code syntax or structure
- ❌ Don't translate URLs or API endpoints
- ❌ Don't break Markdown syntax
- ❌ Don't translate placeholders like `{variable}`

## Example Workflow

1. **Read**: Entire document to understand structure
2. **Identify**: All code blocks and non-translatable elements
3. **Translate**: Text content section by section
4. **Preserve**: All code blocks exactly as-is
5. **Adapt**: Technical terminology consistently
6. **Update**: Links and references
7. **Validate**: Code integrity and Markdown syntax
8. **Test**: Verify all commands still work

## Example Output

### Before (English):
```markdown
# Kubernetes Cluster Deployment Guide

## Prerequisites

### System Requirements
- **Control Node**: Ubuntu Desktop 24.10
- **RAM**: Minimum 2GB per node

### Installation

Run the following command:
```bash
kubectl get nodes
```
```

### After (Russian):
```markdown
# Руководство по развертыванию кластера Kubernetes

## Предварительные требования

### Системные требования
- **Управляющий узел**: Ubuntu Desktop 24.10
- **ОЗУ**: Минимум 2 ГБ на узел

### Установка

Выполните следующую команду:
```bash
kubectl get nodes
```
```

## Validation Checklist

- [ ] All code blocks preserved exactly
- [ ] All commands remain executable
- [ ] File paths unchanged
- [ ] Markdown syntax valid
- [ ] Terminology consistent
- [ ] Links updated and working
- [ ] No code accidentally translated
- [ ] Document structure maintained

## References

- [Markdown Syntax](https://www.markdownguide.org/)
- [Technical Writing Best Practices](https://developers.google.com/tech-writing)

