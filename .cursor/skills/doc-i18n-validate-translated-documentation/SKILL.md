name: doc-i18n-validate-translated-documentation
description: Validate translated technical documentation to ensure code integrity, correct terminology, and proper Markdown syntax. Use after translation work, when user reports issues, or before finalizing translated documentation.
---

# Validate Translated Documentation

Comprehensive validation of translated technical documentation to ensure code blocks are intact, terminology is consistent, and all functionality is preserved.

## Primary intent

Quality-assure already translated technical documentation for correctness, consistency, and markdown integrity.

## Use when

- After completing translation work
- When user reports issues with translated documentation
- Before finalizing or committing translated files
- When checking documentation quality
- User mentions "validate", "check translation", or "verify documentation"

## Do NOT use when

- The translation itself has not been done yet
- The request is to build a terminology glossary from scratch
- The request is to rewrite content for readability in the same language
- The request is project/file structure reorganization

## Use other skills instead when

- Use `doc-i18n-translate-technical-documentation` to perform the translation
- Use `doc-i18n-create-terminology-glossary` for term standardization
- Use `qa-validate-and-fix-links` for non-translation link fixes after file moves

## Instructions

### 1. Validate Code Blocks

Check all code blocks:
- ✅ All code blocks are preserved exactly
- ✅ No code was accidentally translated
- ✅ Commands are still executable
- ✅ Syntax is correct (bash, yaml, json, etc.)
- ✅ Indentation is preserved
- ✅ File paths are unchanged
- ✅ Variables and placeholders intact

**Check for:**
- Translated commands (should be in original language)
- Translated file paths (should remain unchanged)
- Translated YAML keys (should remain in English)
- Broken syntax in code blocks

### 2. Validate Terminology

Check terminology consistency:
- ✅ Terms match glossary (if available)
- ✅ Consistent translations throughout document
- ✅ Tool names not translated
- ✅ Technical terms used correctly
- ✅ Context-appropriate translations

**Check for:**
- Inconsistent term usage
- Translated tool names
- Mixed translations of same term
- Incorrect technical term usage

### 3. Validate Markdown Syntax

Check Markdown structure:
- ✅ Valid Markdown syntax
- ✅ Headers properly formatted
- ✅ Links work correctly
- ✅ Tables properly formatted
- ✅ Code blocks properly fenced
- ✅ Lists properly formatted

**Check for:**
- Broken Markdown syntax
- Invalid link syntax
- Malformed tables
- Unclosed code blocks

### 4. Validate Links

Check all links:
- ✅ All internal links work
- ✅ Relative paths are correct
- ✅ External links are valid
- ✅ Anchor links work (if headers changed)
- ✅ Link text matches target

**Check for:**
- Broken relative paths
- Links to non-existent files
- Incorrect anchor references
- Updated link text matches new header text

### 5. Validate File Paths

Check file references:
- ✅ All file paths unchanged
- ✅ Relative paths still correct
- ✅ File extensions preserved
- ✅ Directory structures intact

**Check for:**
- Translated file paths
- Broken relative paths
- Changed file extensions

### 6. Validate Commands

Test commands (when possible):
- ✅ Commands are syntactically correct
- ✅ File paths in commands are valid
- ✅ Flags and options unchanged
- ✅ Command structure intact

**Check for:**
- Syntax errors in commands
- Invalid file paths
- Translated command flags
- Broken command structure

### 7. Validate Structure

Check document structure:
- ✅ All sections preserved
- ✅ Header hierarchy maintained
- ✅ Table of contents accurate (if present)
- ✅ Document flow logical

**Check for:**
- Missing sections
- Broken hierarchy
- Inconsistent formatting

## Best Practices

- ✅ Validate immediately after translation
- ✅ Check code blocks first (most critical)
- ✅ Use automated tools when possible
- ✅ Test commands in safe environment
- ✅ Review terminology systematically
- ✅ Validate links programmatically
- ✅ Check Markdown with linter

## Validation Checklist

### Code Integrity
- [ ] All code blocks preserved exactly
- [ ] No code translated
- [ ] Commands executable
- [ ] Syntax correct
- [ ] File paths unchanged
- [ ] Variables intact

### Terminology
- [ ] Terms consistent with glossary
- [ ] Tool names not translated
- [ ] Technical terms correct
- [ ] Context-appropriate translations
- [ ] No mixed translations

### Markdown
- [ ] Valid syntax
- [ ] Headers formatted correctly
- [ ] Links work
- [ ] Tables formatted
- [ ] Code blocks fenced properly
- [ ] Lists formatted

### Links
- [ ] Internal links work
- [ ] Relative paths correct
- [ ] External links valid
- [ ] Anchors work
- [ ] Link text matches

### Commands
- [ ] Syntax correct
- [ ] File paths valid
- [ ] Flags unchanged
- [ ] Structure intact

### Structure
- [ ] All sections present
- [ ] Hierarchy maintained
- [ ] Flow logical
- [ ] Formatting consistent

## Common Issues to Check

### Issue 1: Translated Code
```bash
# ❌ Wrong:
кубектл получить поды

# ✅ Correct:
kubectl get pods
```

### Issue 2: Translated File Paths
```markdown
# ❌ Wrong:
Отредактируйте файл `конфиг.ямл`

# ✅ Correct:
Отредактируйте файл `config.yaml`
```

### Issue 3: Inconsistent Terminology
```markdown
# ❌ Wrong:
Развертывание кластера... Deployment готов...

# ✅ Correct:
Развертывание кластера... Развертывание готово...
```

### Issue 4: Broken Links
```markdown
# ❌ Wrong:
[Guide](DEPLOYMENT_GUIDE.md)  # File moved but link not updated

# ✅ Correct:
[Guide](../deployment/DEPLOYMENT_GUIDE.md)
```

## Automated Validation

### Script Example
```bash
#!/bin/bash
# validate-translation.sh

# Check for translated code patterns
grep -r "кубектл\|докер\|ансибл" *.md && echo "ERROR: Found translated commands"

# Check for translated file paths
grep -r "\.ямл\|\.джейсон" *.md && echo "ERROR: Found translated file extensions"

# Validate Markdown syntax
markdownlint *.md

# Check for broken links
find . -name "*.md" -exec grep -l "\[.*\](.*)" {} \; | while read file; do
  # Validate links in file
done
```

## Example Workflow

1. **Code Blocks**: Verify all code preserved
2. **Terminology**: Check against glossary
3. **Markdown**: Validate syntax
4. **Links**: Test all links
5. **Commands**: Verify command syntax
6. **Structure**: Check document completeness
7. **Report**: Document any issues found

## Output Format

### Validation Report
```markdown
## Translation Validation Report

### ✅ Passed
- Code blocks: All preserved correctly
- Markdown syntax: Valid
- File paths: All unchanged

### ⚠️ Warnings
- Terminology: 2 inconsistent terms found
  - "Deployment" used as both "Развертывание" and "Deployment"
  - "Service" translated inconsistently

### ❌ Errors
- Code: 1 command accidentally translated
  - Line 45: "кубектл" should be "kubectl"
- Links: 2 broken links
  - Line 120: Link to moved file
  - Line 145: Invalid anchor reference
```

## References

- [Markdown Linting](https://github.com/DavidAnson/markdownlint)
- [Link Validation Tools](https://github.com/tcort/markdown-link-check)

