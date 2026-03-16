name: doc-enhance-technical-markdown-en
description: Transform technical Markdown files into expanded, more readable English-language versions while preserving technical accuracy and original meaning. Use when user wants to improve documentation readability in English, expand brief technical descriptions, or enrich technical content with context and explanations for English-speaking readers.
---

# Enhance Technical Markdown (EN)

Transform technical Markdown files into expanded, more readable versions with higher readability index while preserving technical accuracy and original meaning. **Output language: English.**

## When to Use

- User wants to improve readability of technical documentation **in English**
- Need to expand brief technical descriptions into detailed English explanations
- User requests to enrich technical content with context
- Documentation is too concise and needs more detail
- User mentions "improve readability", "expand description", "enrich content", or "make more readable"
- Technical documentation needs better explanations for non-experts
- Converting brief technical notes into more comprehensive English documentation
- When you need a textbook format (learning objectives, exercises, knowledge checks) — use `doc-adapt-technical-notes-to-textbook-en`

## Instructions

### 1. Read and Analyze Source Document

Before transformation:
- Read the entire Markdown file completely
- Identify document structure (headings, sections, lists, tables)
- Note all code blocks, links, anchors, and relative paths
- Understand the technical domain and terminology
- Identify brief descriptions that need expansion
- Note any existing examples or explanations

### 2. Preserve Document Structure

Maintain original structure:
- **Keep all headings** – preserve hierarchy (##, ###, etc.)
- **Preserve section order** – don't reorganize content
- **Maintain lists** – keep bullet points, numbered lists, nested lists
- **Keep tables** – preserve table structure and data
- **Preserve links** – maintain all internal and external links
- **Keep anchors** – if headings change, update corresponding anchors
- **Maintain code blocks** – don't modify code content (only fix obvious typos)
- **Preserve relative paths** – keep all file paths valid

### 3. Enhance Readability

Apply readability improvements:

**Sentence Structure:**
- Use short sentences (12–18 words on average)
- Prefer active voice over passive
- Break long sentences into shorter ones
- Use simple, clear language

**Paragraph Structure:**
- Keep paragraphs focused (3–5 sentences)
- One main idea per paragraph
- Add subheadings to break up long sections
- Use bullet points for lists of concepts

**Visual Organization:**
- Add subheadings where appropriate
- Use lists for multiple related points
- Add visual breaks between sections
- Use formatting (bold, italic) strategically

### 4. Expand Brief Descriptions

Transform concise statements into detailed explanations:

**Before (brief):**
```markdown
**Automated Deployments**: Using Deployment for gradual application rollout with rollback capability.
```

**After (expanded, English):**
```markdown
**Automated Deployments**: In production environments, applications must stay available continuously. When updating to a new version, you cannot simply stop the application, update components, and restart it — this would cause downtime (a period when the system is unavailable). Instead, automated approaches for gradual updates (rolling updates) are used, with the ability to quickly roll back to a previous version if issues appear. All of this is handled by the Deployment resource, which acts as the main deployment unit.
```

**Expansion Guidelines:**
- Explain **what** it is (definition/context)
- Explain **why** it's needed (real-world scenarios, problems it solves)
- Explain **how** it works in practice (practical application)
- Mention **risks/limitations** if relevant
- Include **best practices** where applicable
- Add **common mistakes** to avoid
- Provide **verification methods** (how to check if it works)
- Include **examples** when helpful

### 5. Add Context and Explanations

Enrich content with:

**Real-World Context:**
- Explain practical scenarios where concepts apply
- Describe common problems solved by the approach
- Provide industry context and best practices

**Terminology Definitions:**
- Define technical terms when first introduced
- Use domain-specific terminology correctly
- Add brief explanations in parentheses when helpful

**Practical Examples:**
- Add 1–3 line examples where appropriate
- Include practical tips and recommendations
- Add checklists for verification when useful

### 6. Enhance Document Structure

Add helpful elements:

**Introduction:**
- Add a 2–4 sentence overview/context at the start
- Optionally include a brief TL;DR section if the document is long

**Summary:**
- Add a "Quick Summary" section at the end
- Include a "Glossary" of key terms if the document has 5+ technical terms

**Sections:**
- Add subheadings to break up long paragraphs
- Use lists for multiple related concepts
- Add visual separators between major sections

### 7. Maintain Technical Accuracy

Ensure quality:
- **Don't invent facts** – only expand with general principles and common practices
- **Preserve technical terms** – use correct domain terminology
- **Keep code accurate** – don't modify code blocks unnecessarily
- **Maintain links** – ensure all links remain valid
- **Preserve formatting** – keep original indentation and style

### 8. Apply Transformation

Process the document:

1. **Read the source file** completely
2. **Identify expansion points** – brief descriptions, unclear explanations
3. **Expand each point** following expansion guidelines
4. **Enhance readability** – improve sentence and paragraph structure
5. **Add context** – real-world scenarios, examples, best practices
6. **Verify structure** – ensure all links, anchors, and code blocks are preserved
7. **Check accuracy** – verify no invented facts, correct terminology
8. **Output result** – return only the transformed Markdown file

## Best Practices

- ✅ Always preserve original structure and organization
- ✅ Expand brief descriptions with context and explanations
- ✅ Use short, clear sentences (12–18 words)
- ✅ Prefer active voice and simple language
- ✅ Add real-world context and practical scenarios
- ✅ Define technical terms when first introduced
- ✅ Include examples and practical tips where helpful
- ✅ Maintain all links, anchors, and code blocks
- ✅ Don't invent facts – only expand with known principles
- ✅ Keep technical accuracy and correct terminology

## Transformation Pattern (EN)

### Pattern: Brief Description → Expanded Explanation

**Input (brief):**
```markdown
**Feature Name**: Brief one-line description.
```

**Output (expanded, English):**
```markdown
**Feature Name**: In real-world scenarios, [context about why this matters]. When [common situation], you cannot simply [naive approach], because this leads to [problem]. Instead, [proper approach] is used, which relies on [key concepts]. It is also important to consider [related considerations]. All of this is implemented through [mechanism], where [component] serves as [role].
```

## Example Transformation (EN)

### Before (Brief):

```markdown
# Kubernetes Deployment

## Key Features

**Automated Deployments**: Using Deployment for gradual application rollout with rollback capability.

**Scaling**: Horizontal Pod Autoscaler adjusts replica count based on metrics.

**Health Checks**: Liveness and readiness probes monitor container health.
```

### After (Expanded, English):

```markdown
# Kubernetes Deployment

This document covers key features of Kubernetes deployment mechanisms that enable reliable, automated application management in production environments.

## Key Features

### Automated Deployments

In production environments, applications must stay available continuously. When you update to a new version, you cannot simply stop the application, update its components, and start it again — this would cause downtime (a period when the system is unavailable). Instead, Kubernetes uses automated mechanisms for gradual updates (rolling updates) with the ability to roll back quickly to a previous version if problems appear. All of this is handled through the Deployment resource, which serves as the deployment unit.

**Key benefits:**
- Zero downtime during updates
- Automatic rollback on failure
- Gradual traffic migration to the new version

### Scaling

Applications experience varying load throughout the day. A static number of replicas cannot efficiently handle traffic spikes or low-usage periods. Manual scaling is time-consuming and reacts slowly to changes. The Horizontal Pod Autoscaler (HPA) automatically adjusts the number of pod replicas based on observed metrics such as CPU usage, memory consumption, or custom metrics. This ensures efficient resource usage and stable performance under changing load.

### Health Checks

Containers can fail in many ways: application crashes, deadlocks, or becoming unresponsive. Without health monitoring, Kubernetes might continue sending traffic to unhealthy containers, causing service degradation. Health checks (probes) continuously monitor container status and allow Kubernetes to take corrective actions automatically.
```

## Validation Checklist

Before completing transformation:
- [ ] Original document structure preserved (headings, sections, order)
- [ ] All links and anchors remain valid
- [ ] Code blocks preserved unchanged
- [ ] Brief descriptions expanded with context
- [ ] Readability improved (short sentences, active voice)
- [ ] Technical terms defined when introduced
- [ ] Real-world context and examples added
- [ ] No invented facts – only expanded with known principles
- [ ] Technical accuracy maintained
- [ ] Document is more readable and comprehensive for English readers

## Prompt Template for LLM (EN)

When transforming documents using an LLM, use this template:

```
You are a technical editor and architect improving technical documentation for engineers and SRE teams.

**Task:** Transform the provided Markdown file into a more detailed, understandable, and practical English version with improved readability, while maintaining technical accuracy and original meaning.

**Requirements:**
- Preserve the original Markdown structure: section order, headings, lists, tables, links, and anchors
- Do not change the contents of code blocks (except to fix obvious typos)
- Do not invent facts: if exact data is not available, expand using general principles, typical practices, and realistic scenarios without speculation
- Improve readability: short sentences (12–18 words), active voice, simple vocabulary, subheadings, bullet lists, and visual “breaks” between blocks
- Expand brief statements: what it is, why it matters, how it is used in practice, risks/limitations, best practices, common mistakes, how to verify results, examples
- Preserve domain terminology; provide brief definitions when introducing terms
- Keep links, anchors, and relative paths valid; if you change a heading, update the corresponding anchor
- Preserve original indentation and formatting; do not change tab/space style
- Do not remove original points – expand and enrich them
- Language: English, clear professional tone without slang or emojis

**What to add:**
- At the beginning – 2–4 sentence context/overview and, if appropriate, a short TL;DR
- Where useful – short examples (1–3 lines), practical tips, verification checklists
- At the end – “Quick Summary” and a small glossary of key terms (if there are 5+ terms)

**How to rewrite individual points:**
- Before (brief): "Automated Deployments: Using Deployment for gradual application rollout with rollback capability."
- After (expanded): "Automated Deployments: In production environments, applications must stay available continuously. When updating to a new version, you cannot simply stop the application — this would cause downtime (a period when the system is unavailable). Instead, automated mechanisms for gradual updates (rolling updates) with rollback support are used. This is implemented via the Deployment resource, which acts as the main deployment unit."

**Quality checks before output:**
- Accuracy: no false facts; definitions are correct
- Readability: text is easy to scan; paragraphs are short; there are subheadings and lists
- Usefulness: examples, risks, best practices, and verification methods are added
- Format: valid Markdown; code blocks and tables are not damaged

**Input:** Below is the source Markdown document.
**Output:** Return only the final, transformed version of Markdown without additional comments or preambles. Do not add anything except the updated file content.
```

## References

- Agent Skills Standard: https://agentskills.io
- Cursor Skills Documentation: https://cursor.com/docs/context/skills
- Technical Writing Best Practices: Clear, concise technical communication

