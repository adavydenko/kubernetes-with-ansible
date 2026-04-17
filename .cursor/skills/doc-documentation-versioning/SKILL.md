name: doc-documentation-versioning
description: Add version tracking, compatibility matrices, and changelog to technical documentation. Use when documentation needs to track versions, compatibility with software versions, or when creating release notes.
---

# Documentation Versioning

Add comprehensive version tracking to technical documentation including compatibility matrices, changelog, and migration guides.

## Primary intent

Add and maintain version history, compatibility mapping, and migration context for technical documentation.

## Use when

- User requests version tracking for documentation
- Documentation needs compatibility information
- Creating release notes or changelog
- Tracking changes across documentation versions
- User mentions "versioning", "compatibility", "changelog", "release notes"
- Documentation references specific software versions

## Do NOT use when

- The task is restructuring files/directories
- The task is deduplicating repeated content without version semantics
- The task is translation/localization work
- The task is diagram creation only

## Use other skills instead when

- Use `doc-reorganize-project-structure` for file-level reorganization
- Use `doc-eliminate-duplication` for single-source dedup cleanup
- Use `doc-i18n-translate-technical-documentation` for translation tasks
- Use `doc-plantuml-diagram-generator` for architecture/process diagrams

## Instructions

### 1. Determine Versioning Scheme

Choose appropriate versioning:
- **Semantic Versioning**: Major.Minor.Patch (e.g., 2.1.0)
- **Date-based**: YYYY.MM.DD format
- **Release-based**: Based on software releases

### 2. Create Versioning Document

Create `VERSIONING.md` or similar with:
- Current version and release date
- Status (stable, beta, deprecated)
- Compatibility matrix tables
- Changelog with detailed changes
- Migration guides between versions

### 3. Build Compatibility Matrix

Create compatibility tables:
```markdown
| Documentation Version | Kubernetes | Linux | Status |
|---------------------|------------|-------|--------|
| 2.1.0 | 1.24-1.28 | Ubuntu 20.04-22.04 | ✅ Full |
| 2.0.0 | 1.23-1.27 | Ubuntu 20.04-22.04 | ⚠️ Partial |
```

Include:
- Software versions (Kubernetes, Linux, drivers)
- Status indicators (✅ Full, ⚠️ Partial, ❌ Deprecated)
- Notes about limitations or known issues

### 4. Create Changelog

Document all changes:
- **New Features**: What was added
- **Improvements**: What was enhanced
- **Fixes**: What was corrected
- **Breaking Changes**: What requires migration

Format:
```markdown
### Version 2.1.0 (December 2024)
#### New Features
- Added Multi-GPU support documentation
- Created comprehensive glossary

#### Improvements
- Expanded orchestration resource guide
- Enhanced practical examples

#### Fixes
- Corrected configuration examples
- Updated broken links
```

### 5. Add Migration Guides

For version upgrades:
- Step-by-step migration instructions
- Breaking changes explanation
- Compatibility warnings
- Rollback procedures

### 6. Version Documentation Files

Consider versioning in filenames for major releases:
- `K8S_v2.md` for major version
- Or use versioning document to track all versions

### 7. Update References

Ensure all documentation references:
- Current version number
- Compatibility requirements
- Links to versioning document

## Best Practices

- ✅ Use semantic versioning for clarity
- ✅ Update version with each significant change
- ✅ Maintain compatibility matrix
- ✅ Document breaking changes clearly
- ✅ Provide migration paths
- ✅ Include deprecation notices
- ✅ Link to versioning from main README

## Compatibility Matrix Structure

### Software Versions
```markdown
### Kubernetes
| Doc Version | K8s 1.24 | K8s 1.25 | K8s 1.26 | K8s 1.27 | K8s 1.28 |
|------------|----------|----------|----------|----------|----------|
| 2.1.0 | ⚠️ | ✅ | ✅ | ✅ | ✅ |
| 2.0.0 | ✅ | ✅ | ✅ | ⚠️ | ❌ |
```

### Operating Systems
```markdown
### Linux Distributions
| Doc Version | Ubuntu 20.04 | Ubuntu 22.04 | CentOS 8 | RHEL 8 |
|------------|--------------|--------------|----------|--------|
| 2.1.0 | ✅ | ✅ | ✅ | ✅ |
```

## Changelog Format

```markdown
## Version History

### Version 2.1.0 (December 2024)
**Status**: Stable
**Compatibility**: Kubernetes 1.24-1.28, Ubuntu 20.04-22.04

#### New Features
- Multi-GPU support documentation
- Comprehensive glossary
- PlantUML diagrams

#### Improvements
- Expanded resource orchestration guide
- Enhanced troubleshooting sections

#### Fixes
- Corrected YAML examples
- Fixed broken cross-references

#### Known Issues
- GPU-002: Issues with NVIDIA 470.x drivers
```

## What NOT to Do

- ❌ Don't skip version tracking for technical docs
- ❌ Don't forget to update compatibility matrix
- ❌ Don't omit breaking changes
- ❌ Don't use vague version numbers
- ❌ Don't forget migration guides for major changes

## Example Workflow

1. **Determine**: Choose versioning scheme
2. **Create**: Build versioning document structure
3. **Populate**: Add compatibility matrices
4. **Document**: Write changelog entries
5. **Link**: Add references from main docs
6. **Update**: Keep versioning current with changes

## Related Skills

- `doc-technical-documentation-structure` - Organize documentation
- `doc-reorganize-project-structure` - Preserve key changelog/version context during doc moves

