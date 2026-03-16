name: doc-technical-documentation-structure
description: Create modular structure for technical documentation by splitting large documents into logical modules organized by topic, audience level, and purpose. Use when documentation is too large, hard to navigate, or needs to serve different audiences.
---

# Technical Documentation Structure

Create a modular, well-organized structure for technical documentation that improves readability, navigation, and serves different audience levels.

## When to Use

- User requests to improve documentation structure
- Documentation files are too large (exceeding token limits)
- Multiple audience levels need different detail levels
- Documentation is hard to navigate or find information
- User mentions "organize documentation", "split files", "modular structure"
- Creating new technical documentation from scratch

## Instructions

### 1. Analyze Current Documentation

Before restructuring:
- Read all existing documentation files
- Identify main topics and themes
- Map dependencies between sections
- Determine audience levels (beginner, intermediate, advanced)
- Estimate file sizes to avoid token limit issues
- List all cross-references and links

### 2. Define Module Categories

Organize content into logical modules:
- **Core Concepts**: Fundamental topics for beginners
- **Advanced Topics**: Detailed guides for experienced users
- **Reference Materials**: Glossaries, versioning, API references
- **Practical Guides**: Step-by-step tutorials and examples
- **Component-Specific**: Documentation for specific components

### 3. Create Directory Structure

Organize files in a clear hierarchy:
```
docs/
├── getting-started/      # Quick start guides
├── concepts/             # Core concepts
├── guides/               # Detailed guides
├── components/           # Component-specific docs
├── reference/            # Reference materials
│   ├── glossary.md
│   ├── versioning.md
│   └── diagrams.md
└── examples/             # Practical examples
```

### 4. Split Large Documents

When splitting files:
- **By Topic**: Each major topic gets its own file
- **By Audience**: Separate beginner and advanced content
- **By Purpose**: Separate tutorials from reference
- **By Component**: One file per component/system

Example split:
- `K8S.md` → Core Kubernetes concepts
- `K8S_ORCHESTRATION.md` → Advanced resource orchestration
- `K8S_LINUX.md` → Linux integration specifics
- `MULTI_GPU_SUPPORT.md` → GPU-specific documentation

### 5. Create Navigation

Add navigation elements:
- **README.md**: Main entry point with links to all modules
- **Table of Contents**: In each major document
- **Cross-references**: Links between related topics
- **Index**: Quick reference to find topics

### 6. Maintain Consistency

Ensure consistent structure across modules:
- Same section headers where applicable
- Consistent formatting and style
- Standardized code examples
- Uniform cross-reference format

### 7. Add Reference Materials

Create supporting documents:
- **Glossary**: Centralized term definitions
- **Versioning**: Compatibility and changelog
- **Diagrams**: Visual representations
- **Scripts**: Validation and utility scripts

When physically moving or renaming files, use `doc-reorganize-project-structure`; after restructuring run `qa-validate-and-fix-links`.

## Best Practices

- ✅ Split files when they exceed ~1000 lines or token limits
- ✅ One main topic per file
- ✅ Clear, descriptive file names
- ✅ Logical directory hierarchy
- ✅ Consistent navigation structure
- ✅ Cross-reference related topics
- ✅ Separate reference materials from guides
- ✅ Consider audience level when organizing

## Common Patterns

### By Topic
```
docs/
├── kubernetes-basics.md
├── resource-orchestration.md
├── networking.md
└── storage.md
```

### By Audience
```
docs/
├── beginner/
│   └── getting-started.md
├── intermediate/
│   └── advanced-topics.md
└── expert/
    └── deep-dive.md
```

### By Component
```
docs/
├── components/
│   ├── metallb.md
│   ├── prometheus.md
│   └── nvidia-gpu.md
```

## What NOT to Do

- ❌ Don't split files arbitrarily - use logical boundaries
- ❌ Don't create too many small files - balance granularity
- ❌ Don't forget to update all links after splitting
- ❌ Don't duplicate content across files - use links instead
- ❌ Don't ignore navigation - users need to find information
- ❌ Don't mix audience levels in same file

## Example Workflow

1. **Analyze**: Read all documentation, identify topics
2. **Plan**: Design directory structure and file organization
3. **Split**: Divide large files into logical modules
4. **Organize**: Place files in appropriate directories
5. **Link**: Add cross-references and navigation
6. **Validate**: Check all links work, no content lost
7. **Document**: Update README with new structure

## Related Skills

- `qa-validate-and-fix-links` - Fix links after restructuring
- `doc-eliminate-duplication` - Remove duplicate content
- `doc-preserve-important-info` - Ensure nothing is lost

