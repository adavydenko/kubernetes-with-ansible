name: qa-validate-and-fix-links
description: Validate all file links in a project and automatically fix broken links. Use when files have been moved, after reorganization, or when user reports broken links.
---

# Validate and Fix Links

Automatically find, validate, and fix all file links in a project to ensure documentation integrity.

## When to Use

- After reorganizing project structure
- When files have been moved
- User reports broken links
- Before finalizing documentation changes
- When user mentions "broken links", "404", or "file not found"

## Instructions

### 1. Find All Links

- Search for markdown links: `\[.*\]\(.*\.md\)`
- Search for relative file paths in code
- Check all documentation files (`.md`, `.mdx`, etc.)
- List all links with their source files

### 2. Validate Each Link

For each link found:
- Determine the absolute path from the source file
- Check if the target file exists
- Verify the path is correct (relative paths work correctly)
- Mark broken links for fixing

### 3. Fix Broken Links

For each broken link:
- Find the correct location of the target file
- Calculate the correct relative path
- Update the link in the source file
- Use proper relative path syntax:
  - `../` for parent directory
  - `./` for current directory
  - No prefix for same directory

### 4. Verify Fixes

- Re-check all fixed links
- Ensure all target files exist
- Test that links work correctly
- Report any remaining issues

## Best Practices

- ✅ Check links after every file move
- ✅ Use relative paths for portability
- ✅ Validate all links before completing task
- ✅ Test links in context (not just file existence)
- ✅ Handle both markdown and code references

## Common Link Patterns

### Markdown Links
```markdown
[Link Text](../path/to/file.md)
[Link Text](./relative/path.md)
[Link Text](same-dir-file.md)
```

### Relative Path Rules
- Same directory: `file.md`
- Parent directory: `../file.md`
- Two levels up: `../../file.md`
- Subdirectory: `subdir/file.md`

## Validation Checklist

- [ ] All markdown links checked
- [ ] All target files exist
- [ ] Relative paths are correct
- [ ] No broken links remain
- [ ] Links tested in context

## Example

Before:
```markdown
[Guide](DEPLOYMENT_GUIDE.md)  # Broken after moving file
```

After:
```markdown
[Guide](../deployment/DEPLOYMENT_GUIDE.md)  # Fixed with correct path
```

