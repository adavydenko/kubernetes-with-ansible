name: doc-preserve-important-info
description: Preserve all important information when refactoring files, especially README.md. Use when updating documentation, refactoring structure, or when user wants to modify important files.
---

# Preserve Important Information

Ensure no important information is lost when refactoring or updating files, especially documentation files like README.md.

## When to Use

- Refactoring README.md or other important documentation
- Updating file structure
- Reorganizing content
- When user asks to modify important files
- Before making major changes to documentation

## Instructions

### 1. Analyze Source File

Before making changes:
- Read the entire source file completely
- Identify all important sections:
  - Architecture descriptions
  - System requirements
  - Prerequisites
  - Installation instructions
  - Configuration details
  - Usage examples
  - Command references
  - Troubleshooting guides
  - Component descriptions
- Create a checklist of important content

### 2. Create Content Checklist

List all sections that must be preserved:
- [ ] Architecture/Overview
- [ ] System Requirements
- [ ] Prerequisites
- [ ] Installation Steps
- [ ] Configuration
- [ ] Usage Examples
- [ ] Commands Reference
- [ ] Component Descriptions
- [ ] Troubleshooting
- [ ] Links to other documentation

### 3. Refactor with Validation

When making changes:
- Keep the checklist visible
- After each change, verify important sections remain
- Compare original and new versions
- Use git history if needed: `git show <commit>:<file>`

### 4. Restore if Needed

If information was lost:
- Use git history to restore: `git show HEAD~1:README.md`
- Copy missing sections from original
- Ensure all important content is present
- Verify nothing was accidentally removed

### 5. Final Validation

Before completing:
- Compare original and final versions
- Verify all checklist items are present
- Check that formatting is correct
- Ensure links still work

## Critical Sections to Preserve

### In README.md:
- Project description and purpose
- Architecture diagrams/descriptions
- System requirements
- Prerequisites (nodes, Ansible host)
- VM setup and IP addresses
- Component descriptions (roles, services)
- Quick start guide
- Command examples
- Troubleshooting section
- Links to other documentation

### In Documentation Files:
- Overview/Introduction
- Step-by-step instructions
- Code examples
- Configuration details
- Troubleshooting tips
- Related resources

## Best Practices

- ✅ Always read the full file before modifying
- ✅ Create a checklist of important sections
- ✅ Compare before and after versions
- ✅ Use git to track changes
- ✅ When in doubt, preserve rather than remove
- ✅ Ask user if unsure about removing content

## What NOT to Do

- ❌ Don't delete sections without checking importance
- ❌ Don't assume old content is unnecessary
- ❌ Don't skip the comparison step
- ❌ Don't remove content "to clean up" without user approval

## Example Workflow

1. Read: `read_file` to get full content
2. Analyze: Identify important sections
3. Checklist: Create preservation checklist
4. Modify: Make changes while checking checklist
5. Compare: `git diff` or manual comparison
6. Restore: Use git history if needed
7. Validate: Final check against checklist

## Recovery Commands

If information was lost:
```bash
# View previous version
git show HEAD~1:README.md

# Compare versions
git diff HEAD~1 HEAD -- README.md

# Restore specific section from history
git show <commit>:<file> | grep -A 50 "Section Name"
```

