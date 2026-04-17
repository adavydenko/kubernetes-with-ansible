name: doc-eliminate-duplication
description: Identify and eliminate duplicate information in project documentation. Use when user mentions duplication, wants to consolidate documentation, or when creating new files that might duplicate existing content.
---

# Eliminate Duplication

Identify and remove duplicate information in project documentation, following the "Single Source of Truth" principle.

## Primary intent

Remove duplicated documentation content while keeping exactly one canonical source for each concept.

## Use when

- User mentions duplicate information
- Creating new documentation files
- After reorganizing project structure
- When consolidating documentation
- User asks to "remove duplicates" or "consolidate docs"

## Do NOT use when

- You need to redesign module hierarchy or split docs by audience/topic
- You are physically moving directories/files as the primary task
- You are only improving readability/formatting inside one file
- You are translating content

## Use other skills instead when

- Use `doc-technical-documentation-structure` for modular information architecture
- Use `doc-reorganize-project-structure` for file-system-level moves and renames
- Use `doc-optimize-content-format` for list/table/readability formatting changes

## Instructions

### 1. Identify Duplicates

- Search for similar content across files
- Look for:
  - Duplicate sections in different files
  - Files with overlapping information
  - Repeated instructions or examples
  - Multiple files describing the same thing
- Check file names for similar purposes

### 2. Determine Source of Truth

For each duplicate:
- Identify which file should be the primary source
- Consider:
  - Which file is more complete?
  - Which file is more frequently updated?
  - Which location makes more sense?
  - User's preference if mentioned

### 3. Remove Duplicates

- Delete duplicate files if entire file is duplicate
- Remove duplicate sections from secondary files
- Replace duplicates with links to primary source
- Keep only one version of each piece of information

### 4. Update References

- Update all links to point to the primary source
- Ensure no broken references after removal
- Update any cross-references

### 5. Validate

- Verify all important information is preserved
- Check that links work correctly
- Ensure no information was lost
- Confirm documentation is still complete

## Best Practices

- ✅ Follow "Single Source of Truth" principle
- ✅ Use links instead of copying content
- ✅ One file per topic/concept
- ✅ Consolidate related information
- ✅ Regular cleanup to prevent duplication

## Common Duplication Patterns

### Duplicate Files
- `MIGRATION_GUIDE.md` and `PROJECT_STRUCTURE.md` with overlapping content
- Multiple quick start guides with same information
- Duplicate README files in subdirectories

### Duplicate Sections
- Same "Getting Started" in multiple files
- Repeated installation instructions
- Duplicate troubleshooting sections

## What to Keep vs Remove

### Keep (Primary Source):
- Most complete version
- Most up-to-date version
- Best location for the information
- User-preferred version

### Remove:
- Less complete versions
- Outdated duplicates
- Files in wrong locations
- Redundant documentation

## Example

Before:
```
README.md - Contains full project info
MIGRATION_GUIDE.md - Duplicates README structure section
PROJECT_STRUCTURE.md - Duplicates README structure section
```

After:
```
README.md - Contains full project info
(Other files removed, structure info only in README)
```

## Validation Checklist

- [ ] All duplicates identified
- [ ] Primary source determined
- [ ] Duplicates removed
- [ ] Links updated
- [ ] No information lost
- [ ] Documentation still complete

