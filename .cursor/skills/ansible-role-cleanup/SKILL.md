---
name: ansible-role-cleanup
description: Analyze and clean up Ansible roles by removing redundant files, empty directories, and unused components. Use when user requests role cleanup, optimization, or when analyzing role structure for improvements.
---

# Ansible Role Cleanup and Optimization

Analyze Ansible roles to identify and remove redundant files, empty directories, unused components, and fix inconsistencies while preserving all functional code.

## Primary intent

Clean existing Ansible roles by removing unused scaffolding and inconsistencies without changing intended behavior.

## Use when

- User requests role cleanup or optimization
- User mentions "избыточные файлы", "удалить неиспользуемые", "очистка роли"
- Analyzing role structure for improvements
- Before refactoring or reorganizing roles
- When role has accumulated unused files over time
- User wants to simplify role structure

## Do NOT use when

- You need to create a new role from scratch
- The primary task is adding new component functionality
- The task is project documentation restructuring
- The task is cluster/infrastructure design rather than Ansible role hygiene

## Use other skills instead when

- Use `ansible-role-development` for new roles or feature expansion in existing roles
- Use `doc-reorganize-project-structure` for documentation/repo file layout changes

## Instructions

### 1. Analyze Role Structure

Before making any changes:
- List all files and directories in the role
- Read contents of each file to understand its purpose
- Check which files are actually used in the role
- Verify role usage in main playbooks (`site.yml`, etc.)
- Map dependencies between files

### 2. Identify Redundant Files

Check for and identify:

#### Empty or Template Files
- `defaults/main.yml` - Contains only comments like "No defaults yet" or template text
- `vars/main.yml` - Contains only comments like "# vars file for role_name"
- `handlers/main.yml` - Contains only comments like "# handlers file for role_name"
- `README.md` - Contains only Ansible Galaxy template without useful information

#### Unused Test Files
- `tests/test.yml` - Test playbook not used in main project
- `tests/inventory` - Test inventory not referenced
- Entire `tests/` directory if unused

#### Unused Directories
- Empty `defaults/` directory (if defaults/main.yml is empty)
- Empty `vars/` directory (if vars/main.yml is empty)
- Empty `handlers/` directory (if handlers/main.yml is empty)
- Empty `templates/` directory
- Empty `files/` directory

### 3. Check File Usage

Verify actual usage:
- Search for role usage in `ansible/playbooks/site.yml`
- Check if defaults are referenced in tasks
- Verify if handlers are called
- Confirm if vars are used
- Check if tests are part of CI/CD

### 4. Identify Code Issues

Look for:
- Incorrect comments (e.g., "tasks file for kubernetes_master" in kubernetes_worker role)
- Outdated or misleading documentation
- Dead code or commented-out sections that are never used
- Inconsistent naming or structure

### 5. Remove Redundant Files

After verification:
- Delete empty files (defaults/main.yml, vars/main.yml, handlers/main.yml if only comments)
- Delete unused test files if not part of testing workflow
- Delete template README.md if it contains no useful information
- Remove empty directories after deleting their files

### 6. Fix Code Issues

- Correct incorrect comments
- Update misleading documentation
- Fix naming inconsistencies
- Remove dead code if appropriate

### 7. Validate After Cleanup

- Verify role still works correctly
- Check that all necessary files are present
- Ensure no broken references
- Confirm role can be executed successfully

## Best Practices

- ✅ **YAGNI Principle**: Don't create files "for future use" - create them when actually needed
- ✅ **Verify Before Delete**: Always check file usage before removing
- ✅ **Preserve Functionality**: Never delete files that are actually used
- ✅ **Keep Essential Files**: Always preserve `tasks/main.yml` and `meta/main.yml` (if contains metadata)
- ✅ **Document Cleanup**: Note what was removed and why
- ✅ **Test After Cleanup**: Verify role still works after cleanup
- ✅ **Apply Consistently**: Use same cleanup approach across all roles

## Common Patterns

### Empty Defaults Pattern

```yaml
# defaults/main.yml - REMOVE if contains only:
---
# defaults file for role_name

# No defaults yet
```

### Empty Vars Pattern

```yaml
# vars/main.yml - REMOVE if contains only:
---
# vars file for role_name
```

### Empty Handlers Pattern

```yaml
# handlers/main.yml - REMOVE if contains only:
---
# handlers file for role_name
```

### Template README Pattern

```markdown
# README.md - REMOVE if contains only Ansible Galaxy template:
Role Name
=========
A brief description of the role goes here.
...
```

### Unused Tests Pattern

```
tests/
├── test.yml      # Not referenced in CI/CD
└── inventory     # Not used
# REMOVE entire directory if unused
```

## What NOT to Do

- ❌ Don't delete `tasks/main.yml` - it's essential
- ❌ Don't delete `meta/main.yml` if it contains actual metadata
- ❌ Don't remove files that are referenced in playbooks
- ❌ Don't delete files without checking their usage
- ❌ Don't remove directories that contain actual files
- ❌ Don't skip validation after cleanup
- ❌ Don't create empty files "for future use"

## Example Workflow

1. **Analyze**: `list_dir` to see role structure
2. **Read**: Contents of each file to understand purpose
3. **Check**: Usage in playbooks and other roles
4. **Identify**: Redundant files and empty directories
5. **Verify**: Files are truly unused before deletion
6. **Remove**: Redundant files and empty directories
7. **Fix**: Code issues (comments, documentation)
8. **Validate**: Role still works correctly

## Example Output Format

```markdown
## Role Cleanup Results

### Removed Files
- `defaults/main.yml` - Empty file with only comments
- `vars/main.yml` - Empty file with only comments
- `handlers/main.yml` - Empty file with only comments
- `tests/test.yml` - Unused test file
- `tests/inventory` - Unused test inventory
- `README.md` - Template without useful information

### Removed Directories
- `defaults/` - Empty after file removal
- `vars/` - Empty after file removal
- `handlers/` - Empty after file removal
- `tests/` - Empty after file removal

### Fixed Issues
- Corrected comment in `tasks/main.yml`: "kubernetes_master" → "kubernetes_worker"

### Final Structure
role_name/
├── meta/
│   └── main.yml
└── tasks/
    └── main.yml

### Metrics
- Files before: 7
- Files after: 2
- Reduction: ~71%
```

## Cleanup Checklist

Before removing any file, verify:
- [ ] File is not referenced in `tasks/main.yml`
- [ ] File is not used in main playbooks (`site.yml`)
- [ ] File is not imported by other roles
- [ ] File is truly empty or contains only template text
- [ ] File is not part of CI/CD testing workflow
- [ ] Directory will be empty after file removal

## Metrics to Track

- Number of files before cleanup
- Number of files after cleanup
- Percentage reduction
- Number of empty directories removed
- Number of code issues fixed

## Apply to Multiple Roles

After cleaning one role, consider applying same cleanup to:
- Other roles in the project
- Similar roles with same structure
- All roles for consistency

## References

- Ansible Role Structure: https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
- YAGNI Principle: https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it
- Ansible Best Practices: https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html

