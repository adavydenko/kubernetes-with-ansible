name: doc-optimize-content-format
description: Optimize content format by converting verbose lists to tables, grouping related information, and improving readability while preserving all information. Use when content is hard to navigate or contains repetitive structures.
---

# Optimize Content Format

Optimize content format by converting verbose lists to tables, grouping related information, and improving readability while preserving all information.

## Primary intent

Improve intra-document presentation (tables, grouping, scannability) without changing document scope or file layout.

## Use when

- Content has long, repetitive lists
- Information is hard to navigate
- User mentions "table", "organize", "format", or "optimize"
- Content contains structured data that could be tabular
- Need to improve readability and navigation

## Do NOT use when

- You need to split files or redesign documentation architecture
- You need to move files/directories across the repository
- You need to remove duplicate content across documents
- You need to translate or validate translated documentation

## Use other skills instead when

- Use `doc-technical-documentation-structure` for module/file architecture changes
- Use `doc-reorganize-project-structure` for file moves and path changes
- Use `doc-eliminate-duplication` for cross-file deduplication
- Use `doc-enhance-technical-markdown` for semantic expansion and explanatory depth

## Instructions

### 1. Identify Optimization Opportunities

Look for:
- Long lists with repetitive structure
- Information that could be tabular
- Repeated patterns in content
- Hard-to-navigate sections
- Verbose descriptions that could be condensed

### 2. Convert Lists to Tables

When list items have similar structure:
- **Before**: Bullet points with repeated format
- **After**: Table with columns for each attribute

Example:
```markdown
### Before (List)
- **Diagram 1**: Architecture - Location: Section 1 - Elements: A, B, C
- **Diagram 2**: Process - Location: Section 2 - Elements: D, E, F

### After (Table)
| № | Название | Расположение | Описание | Ключевые элементы |
|---|----------|--------------|----------|-------------------|
| 1 | Architecture | Section 1 | Architecture diagram | A, B, C |
| 2 | Process | Section 2 | Process flow | D, E, F |
```

### 3. Group Related Information

Organize by categories:
- Group similar items together
- Use category headers
- Create logical sections
- Use consistent formatting

### 4. Preserve All Information

Ensure:
- No information is lost
- All details are preserved
- Context is maintained
- Meaning is clear

### 5. Improve Navigation

Add:
- Clear table headers
- Consistent formatting
- Visual separators
- Category grouping

## Best Practices

- ✅ Use tables for structured, repetitive data
- ✅ Group related information together
- ✅ Preserve all information (don't lose details)
- ✅ Use clear, descriptive headers
- ✅ Maintain readability
- ✅ Keep consistent formatting
- ✅ Use emojis for visual navigation (if appropriate)

## Conversion Patterns

### List → Table

**When to convert:**
- Items have 3+ common attributes
- Repetitive structure
- Easy to compare items

**Pattern:**
```markdown
### Before
- Item 1: Attribute A, Attribute B, Attribute C
- Item 2: Attribute A, Attribute B, Attribute C

### After
| Item | Attribute A | Attribute B | Attribute C |
|------|-------------|-------------|-------------|
| Item 1 | Value | Value | Value |
| Item 2 | Value | Value | Value |
```

### Grouped Lists → Categorized Table

**When to convert:**
- Multiple categories
- Items belong to categories
- Need quick lookup

**Pattern:**
```markdown
### Before
**Category 1:**
- Item A: Description
- Item B: Description

**Category 2:**
- Item C: Description
- Item D: Description

### After
| Категория | Элемент | Описание |
|-----------|---------|----------|
| Category 1 | Item A | Description |
| Category 1 | Item B | Description |
| Category 2 | Item C | Description |
| Category 2 | Item D | Description |
```

## Table Design Guidelines

### Column Headers
- Use clear, descriptive names
- Keep headers concise
- Use consistent terminology
- Consider sortability

### Row Content
- Keep cells concise
- Use consistent formatting
- Preserve important details
- Make content scannable

### Table Size
- Limit to 5-7 columns (readability)
- Break large tables into sections
- Use grouping for related rows
- Consider pagination for very large tables

## Example Optimizations

### Index of Diagrams

**Before (Verbose):**
```markdown
#### Diagram 1: Architecture
- Location: Section 1
- Description: Shows architecture
- Elements: A, B, C

#### Diagram 2: Process
- Location: Section 2
- Description: Shows process
- Elements: D, E, F
```

**After (Table):**
```markdown
| № | Название | Расположение | Описание | Ключевые элементы |
|---|----------|--------------|----------|-------------------|
| 1 | Architecture | Section 1 | Shows architecture | A, B, C |
| 2 | Process | Section 2 | Shows process | D, E, F |
```

### Code Examples Index

**Before:**
```markdown
**Ansible Playbooks:**
- Full deployment: `ansible-playbook -i inventory.yml site.yml`
- MetalLB only: `ansible-playbook -i inventory.yml site.yml --tags metallb`

**Kubernetes Commands:**
- Check nodes: `kubectl get nodes`
- Check pods: `kubectl get pods -n namespace`
```

**After:**
```markdown
| Категория | Команда/Пример | Описание |
|-----------|----------------|----------|
| Ansible Playbooks | `ansible-playbook -i inventory.yml site.yml` | Full deployment |
| Ansible Playbooks | `ansible-playbook -i inventory.yml site.yml --tags metallb` | MetalLB only |
| Kubernetes Commands | `kubectl get nodes` | Check nodes |
| Kubernetes Commands | `kubectl get pods -n namespace` | Check pods |
```

## What NOT to Do

- ❌ Don't lose information when converting
- ❌ Don't create overly wide tables (>7 columns)
- ❌ Don't use tables for non-tabular data
- ❌ Don't break formatting consistency
- ❌ Don't remove important context

## Validation Checklist

Before completing:
- [ ] All information is preserved
- [ ] Table headers are clear
- [ ] Formatting is consistent
- [ ] Content is more readable
- [ ] Navigation is improved
- [ ] No information was lost
- [ ] Tables are appropriately sized

