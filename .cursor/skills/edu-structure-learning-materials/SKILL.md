name: edu-structure-learning-materials
description: Transform unstructured technical notes into organized, hierarchical learning content with clear progression from basics to advanced. Use when creating educational documentation, courses, or tutorials from raw technical material.
---

# Structure Learning Materials

Transform unstructured technical notes into organized, hierarchical learning content with clear progression from basics to advanced concepts.

## Primary intent

Design learning-path architecture across multiple topics/files/modules, including sequencing and navigation.

## Use when

- User wants to create educational documentation from technical notes
- Converting raw technical content into structured learning guides
- Organizing scattered documentation into coherent learning paths
- Creating courses or tutorials
- User mentions "learning guide", "tutorial", "educational material", or "course structure"
- Use for organizing multiple files or sections into a single course or learning path; for transforming one document into a textbook use `doc-adapt-technical-notes-to-textbook`

## Do NOT use when

- The task is a single-document textbook expansion
- The task is translation or terminology standardization
- The task is only formatting or deduplication in existing docs
- The task is generating question banks only

## Use other skills instead when

- Use `doc-adapt-technical-notes-to-textbook` for one-document textbook transformation
- Use `doc-enhance-technical-markdown` for readability expansion without curriculum architecture
- Use `edu-educational-question-generator` for standalone assessment creation

## Instructions

### 1. Analyze Source Material

Before structuring:
- Read all source files to understand content scope
- Identify key topics and concepts
- Map relationships between topics
- Determine target audience (beginners/intermediate/advanced)
- Identify prerequisites for each topic

### 2. Create Learning Roadmap

Design logical progression:
- Start with fundamentals and prerequisites
- Build complexity gradually
- Group related topics together
- Create clear learning path: basics → intermediate → advanced
- Define learning objectives for each section

### 3. Organize Content Structure

Create hierarchical structure:
```
Introduction
├── Learning Objectives
├── Prerequisites
└── Roadmap

Theory Section
├── Basic Concepts
├── Intermediate Topics
└── Advanced Topics

Practice Section
├── Step-by-step Labs
├── Exercises
└── Knowledge Checks

Additional Resources
├── Glossary
├── FAQ
├── Troubleshooting
└── Best Practices
```

### 4. Structure Each Section

For each section:
- **Theory**: Explain concepts clearly, use accessible language
- **Practice**: Provide step-by-step instructions with examples
- **Knowledge Check**: Add questions and exercises
- **Resources**: Include links to documentation, videos, courses

### 5. Add Mandatory Elements

Ensure all learning materials include:
- **Glossary**: Define all technical terms
- **FAQ**: Address common questions
- **Troubleshooting**: Common problems and solutions
- **Best Practices**: Industry standards and recommendations

### 6. Create Navigation

- Add table of contents
- Create cross-references between sections
- Add index for quick lookup
- Use clear section headings

## Best Practices

- ✅ Always start with a learning roadmap
- ✅ Use accessible language (avoid jargon, explain complex terms)
- ✅ Connect theory with practice
- ✅ Provide step-by-step instructions
- ✅ Include visual aids (diagrams, tables)
- ✅ Add knowledge checks after each major topic
- ✅ Create glossary for technical terms
- ✅ Include troubleshooting section
- ✅ Link to additional resources

## Content Organization Patterns

### Progressive Disclosure
```
Basic → Intermediate → Advanced
Simple → Complex
Theory → Practice → Application
```

### Modular Structure
- Each module is self-contained
- Clear dependencies between modules
- Can be studied independently or sequentially

### Multi-Modal Learning
- Text explanations
- Visual diagrams
- Code examples
- Hands-on exercises
- Knowledge checks

## Example Structure

```markdown
# Learning Guide Title

## Introduction and Learning Objectives
- What you'll learn
- Prerequisites
- Learning roadmap

## Theoretical Foundation
### Section 1: Basics
- Concept explanation
- Key principles
- Diagram (if needed)

### Section 2: Intermediate
- Building on basics
- More complex concepts
- Practical applications

## Practical Labs
### Lab 1: Basic Setup
- Step-by-step instructions
- Expected results
- Troubleshooting

### Lab 2: Advanced Configuration
- More complex scenario
- Real-world application

## Knowledge Checks
- Questions
- Exercises
- Solutions

## Additional Resources
- Glossary
- FAQ
- Troubleshooting
- Best Practices
- External Links
```

## What NOT to Do

- ❌ Don't skip the roadmap - it's essential for navigation
- ❌ Don't use jargon without explanation
- ❌ Don't mix theory and practice without clear separation
- ❌ Don't forget mandatory sections (glossary, FAQ, troubleshooting)
- ❌ Don't create content without clear learning objectives

## Validation Checklist

Before completing:
- [ ] Learning roadmap is clear and logical
- [ ] All sections have theory → practice → check structure
- [ ] Glossary includes all technical terms
- [ ] FAQ addresses common questions
- [ ] Troubleshooting section is comprehensive
- [ ] All examples are tested and working
- [ ] Navigation is clear (TOC, cross-references, index)
- [ ] Content is accessible to target audience

