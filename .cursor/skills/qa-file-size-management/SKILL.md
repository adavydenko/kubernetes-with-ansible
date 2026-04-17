name: qa-file-size-management
description: Manage file sizes by planning splits or splitting existing large files. Use when planning documentation generation or when existing files are too large (before failures occur).
---

# File Size Management

Manage file sizes during documentation generation to prevent token limit issues and ensure efficient processing.

## Primary intent

Prevent generation/runtime failures by proactively planning and executing size-aware file splits.

## Use when

- Planning documentation generation or splitting existing large files (before hitting limits)
- File generation exceeds token limits
- Files are too large to process efficiently
- User requests to split large files
- Documentation files are hard to edit
- User mentions "file too large", "token limit", "split file"
- Need to optimize file organization

## Do NOT use when

- The failure has already happened and needs recovery handling
- The main task is repo-level file reorganization beyond size concerns
- The main task is deduplicating overlapping content
- The task is translation or localization

## Use other skills instead when

- Use `qa-error-handling-generation` when generation already failed and recovery is required
- Use `doc-technical-documentation-structure` when redesigning information architecture
- Use `doc-reorganize-project-structure` for broad directory moves and path updates

## Instructions

### 1. Assess File Size

Before generating:
- Estimate content size in tokens/characters
- Check token limits (typically 100K-200K tokens)
- Identify large sections that can be split
- Plan split points at logical boundaries

### 2. Determine Split Strategy

Choose appropriate strategy:
- **By Topic**: Split by major topics/themes
- **By Audience Level**: Separate beginner/advanced
- **By Component**: One file per component
- **By Purpose**: Separate guides from reference

### 3. Plan File Structure

Design split structure:
```
docs/
├── core/
│   ├── concepts.md          # ~500 lines
│   ├── architecture.md      # ~400 lines
│   └── basics.md            # ~300 lines
├── advanced/
│   ├── orchestration.md     # ~800 lines
│   └── optimization.md      # ~600 lines
└── reference/
    ├── glossary.md          # ~500 lines
    └── versioning.md        # ~300 lines
```

### 4. Split at Logical Boundaries

When splitting:
- **Section boundaries**: Split between major sections
- **Topic changes**: New file for new major topic
- **Audience changes**: Separate files for different levels
- **Component boundaries**: One file per component

### 5. Maintain Navigation

After splitting:
- Update table of contents
- Add cross-references between files
- Create index/navigation file
- Link related sections

### 6. Validate Split

Check after splitting:
- All content preserved
- Links updated correctly
- No duplicate content
- Files are manageable size
- Navigation works

### 7. Document Structure

Update documentation:
- Explain file organization
- Provide navigation guide
- List file purposes
- Include size guidelines

## Best Practices

- ✅ Split at logical boundaries, not arbitrary points
- ✅ Keep files under ~1000 lines when possible
- ✅ One main topic per file
- ✅ Maintain clear navigation
- ✅ Use descriptive file names
- ✅ Balance granularity with usability
- ✅ Monitor file sizes during generation

## Size Guidelines

### Recommended Limits
- **Small files**: < 500 lines (~50K tokens)
- **Medium files**: 500-1000 lines (~100K tokens)
- **Large files**: 1000-2000 lines (~200K tokens)
- **Maximum**: Avoid files > 2000 lines

### Split Triggers
- File exceeds 1500 lines
- Token count > 150K
- Multiple major topics in one file
- Hard to navigate or find information
- Editor performance issues

## Split Strategies

### By Topic
```
Before: kubernetes-guide.md (3000 lines)
After:
  - kubernetes-basics.md (800 lines)
  - kubernetes-networking.md (600 lines)
  - kubernetes-storage.md (500 lines)
  - kubernetes-security.md (700 lines)
  - kubernetes-monitoring.md (400 lines)
```

### By Audience
```
Before: complete-guide.md (2500 lines)
After:
  - getting-started.md (500 lines)
  - intermediate-guide.md (1000 lines)
  - advanced-topics.md (1000 lines)
```

### By Component
```
Before: all-components.md (4000 lines)
After:
  - metallb-setup.md (400 lines)
  - prometheus-setup.md (500 lines)
  - nvidia-gpu.md (600 lines)
  - storage-setup.md (400 lines)
```

## What NOT to Do

- ❌ Don't split files arbitrarily
- ❌ Don't create too many tiny files
- ❌ Don't split in middle of topic
- ❌ Don't forget to update links
- ❌ Don't duplicate content across files
- ❌ Don't ignore navigation after split

## Example Workflow

1. **Assess**: Check file size and estimate tokens
2. **Plan**: Design split strategy and structure
3. **Split**: Divide at logical boundaries
4. **Organize**: Place files in appropriate directories
5. **Link**: Add cross-references and navigation
6. **Validate**: Check all content preserved, links work
7. **Document**: Update structure documentation

## Related Skills

- `doc-technical-documentation-structure` - Organize split files
- `qa-validate-and-fix-links` - Fix links after splitting
- `qa-error-handling-generation` - Handle size limit errors

