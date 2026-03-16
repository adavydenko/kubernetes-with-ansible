name: doc-i18n-glossary-generator
description: Generate comprehensive glossaries from technical documentation by extracting terms, organizing by categories, and creating definitions with examples. Use when documentation has many technical terms, needs reference material, or user requests glossary.
---

# Glossary Generator

Create structured glossaries from technical documentation by extracting terms, organizing them, and providing clear definitions with examples.

## When to Use

- User requests glossary or term definitions
- Documentation contains many technical terms
- Need centralized reference for terminology
- User mentions "glossary", "terms", "definitions", "vocabulary"
- Creating reference documentation
- Improving documentation accessibility
- When you need a glossary for consistent translations (e.g. EN→RU) — use `create-terminology-glossary`

## Instructions

### 1. Extract Terms

Identify terms to include:
- **Domain-specific terms**: Kubernetes, Linux, networking
- **Acronyms**: HPA, VPA, RBAC, CNI
- **Technical concepts**: Pods, Services, Deployments
- **Tools and technologies**: Prometheus, Grafana, MetalLB
- **Processes and patterns**: Rolling updates, autoscaling

### 2. Organize by Categories

Group terms logically:
- **Kubernetes Core**: Basic Kubernetes concepts
- **Orchestration**: Resource management terms
- **Networking**: Network-related terms
- **Storage**: Storage and persistence terms
- **Security**: Security and access control
- **Monitoring**: Observability terms
- **Linux/System**: Operating system terms

### 3. Create Definitions

For each term provide:
- **Definition**: Clear, concise explanation
- **Context**: Where/how it's used
- **Examples**: Practical usage examples
- **Related Terms**: Links to related concepts

Format:
```markdown
**Term Name**
- **Definition**: Brief explanation
- **Context**: Where it's used
- **Example**: Practical example
- **Related**: Links to related terms
```

### 4. Alphabetical Organization

Within categories, organize alphabetically:
- Use letter headers (A, B, C, etc.)
- Group terms by first letter
- Maintain consistent formatting

### 5. Add Cross-References

Link related terms:
- Use markdown links: `[Related Term](#term-anchor)`
- Create term index
- Link from main documentation

### 6. Include Usage Examples

Add practical examples:
- Code snippets where applicable
- Command examples
- Configuration examples
- Real-world usage scenarios

### 7. Create Navigation

Add navigation aids:
- Table of contents by category
- Alphabetical index
- Quick reference section
- Search-friendly structure

## Best Practices

- ✅ Organize by logical categories
- ✅ Provide clear, concise definitions
- ✅ Include practical examples
- ✅ Link related terms
- ✅ Maintain alphabetical order within categories
- ✅ Keep definitions up-to-date
- ✅ Use consistent formatting
- ✅ Add pronunciation guides for complex terms

## Glossary Structure

```markdown
# Glossary

## Category 1

### A
**Term A**
- Definition
- Example

### B
**Term B**
- Definition
- Example

## Category 2
...
```

## Term Entry Format

```markdown
**API Server (kube-apiserver)**
- **Definition**: Central component providing RESTful API for cluster operations
- **Role**: Single entry point for all cluster operations
- **Example**: `kubectl` interacts with cluster through API Server
- **Related**: [Control Plane](#control-plane), [etcd](#etcd)
```

## Common Categories

### Kubernetes Terms
- Pods, Services, Deployments
- Controllers, Operators
- Namespaces, RBAC
- Resources, Quotas

### Infrastructure Terms
- Nodes, Clusters
- Control Plane, Data Plane
- CNI, Ingress
- Storage Classes, PVs

### Operations Terms
- Autoscaling, Rolling Updates
- Health Checks, Probes
- Monitoring, Alerting
- Troubleshooting

## What NOT to Do

- ❌ Don't include obvious terms (e.g., "file", "directory")
- ❌ Don't create duplicate definitions
- ❌ Don't use jargon without explanation
- ❌ Don't skip examples
- ❌ Don't forget to update when terms change
- ❌ Don't create overly long definitions

## Example Workflow

1. **Extract**: Identify all technical terms from documentation
2. **Categorize**: Group terms by domain/category
3. **Define**: Write clear definitions with examples
4. **Organize**: Arrange alphabetically within categories
5. **Link**: Add cross-references between terms
6. **Validate**: Check all definitions are accurate
7. **Document**: Add glossary to documentation structure

## Related Skills

- `doc-technical-documentation-structure` - Organize glossary in docs
- `doc-documentation-versioning` - Track term changes over versions
- `doc-i18n-create-terminology-glossary` - For translation terminology glossaries use this skill

