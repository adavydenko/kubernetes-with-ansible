name: doc-reorganize-project-structure
description: Safely reorganize project structure while preserving all important information, dependencies, and links. Use when user wants to restructure files, organize documentation, or separate automation code from documentation.
---

# Reorganize Project Structure

Safely reorganize project files and directories while preserving all important information, dependencies, and ensuring all links remain functional.

## When to Use

- User requests project reorganization or restructuring
- Need to separate automation code from documentation
- Organizing files into logical categories
- Moving files to new directory structure
- User mentions "organize", "restructure", "reorganize", or "move files"

## Instructions

### 1. Analyze Current State

Before making any changes:
- Read and understand the current project structure
- List all files and their locations
- Identify important sections in documentation (especially in README.md)
- Map dependencies between files (links, imports, references)
- Check git history if needed to understand original content

### 2. Create Backup

- Create a git commit before starting changes: `git add -A && git commit -m "Backup before reorganization"`
- Or note the current state for potential rollback

### 3. Plan New Structure

- Define categories for files (e.g., automation, documentation, examples, scripts)
- Create a clear directory hierarchy
- Plan the order of file movements
- Identify which files belong to which category

### 4. Preserve Important Information

When updating files (especially README.md and key docs), follow the procedure from skill `doc-preserve-important-info`: checklist of important sections, compare before/after versions, restore from git if needed (`git show <commit>:<file>`).

### 5. Move Files Gradually

- Move files in logical groups (e.g., all roles, then all docs)
- Update links immediately after moving each group
- Test that everything still works after each step
- Don't move everything at once

### 6. Update All References

- Update paths in scripts and commands
- Fix all markdown links to reflect new structure
- Update relative paths correctly (use `../` for parent directories)
- Verify all target files exist

### 7. Validate

- Check that all files are in their new locations
- Verify all links work correctly
- Ensure no important information was lost
- Test that commands still work with new paths

## Best Practices

- ✅ Always create a backup/commit before starting
- ✅ Move files gradually, not all at once
- ✅ Update links immediately after moving files
- ✅ Preserve all important information from original files
- ✅ Use relative paths for portability
- ✅ Test after each major step
- ✅ Compare before/after to catch missing information

## Common Patterns

### Separating Automation from Documentation

```
project/
├── automation/          # Code, scripts, configs
│   ├── playbooks/
│   ├── roles/
│   └── scripts/
└── docs/                # Documentation
    ├── getting-started/
    ├── guides/
    └── reference/
```

### Organizing by Category

```
docs/
├── getting-started/     # Quick start guides
├── deployment/          # Deployment guides
├── components/          # Component-specific docs
├── learning/            # Educational materials
└── reference/           # Reference materials
```

## What NOT to Do

- ❌ Don't delete important sections from README.md
- ❌ Don't move all files at once without testing
- ❌ Don't forget to update links after moving files
- ❌ Don't create duplicate files with same information
- ❌ Don't skip validation steps

## Related Skills

- `doc-preserve-important-info` - Checklist and comparison when updating README or key docs
- `qa-validate-and-fix-links` - Fix links after moving files

## Example Workflow

1. Analyze: `list_dir` to see current structure
2. Backup: `git commit` current state
3. Plan: Create new directory structure
4. Move: Move files group by group
5. Update: Fix all links and paths (use `qa-validate-and-fix-links` as needed)
6. Validate: Check everything works
7. Clean: Remove any duplicate files

