name: meta-create-skills-from-dialogs
description: Create Agent Skills from AI agent dialogs by extracting lessons learned and generating reusable skills without intermediate documents. Use when user wants to convert dialog experience into reusable skills or preserve valuable knowledge from conversations.
---

# Create Skills from Dialogs

Create Agent Skills from AI agent dialogs by extracting valuable lessons, patterns, and procedural knowledge, then generating ready-to-use Skills following Agent Skills and Cursor standards.

## Primary intent

Produce new skill definitions from prior agent dialog history.

## Use when

- User wants to create Skills from dialogs with AI agents
- Need to preserve valuable experience from conversations
- Converting dialog knowledge into reusable skills
- User mentions "create skill from dialog", "save this conversation as skill", or "extract knowledge from chat"
- After productive dialogs that contain reusable patterns

## Do NOT use when

- You need to audit the whole existing skill library for duplicates
- You need to improve one already-existing skill in place
- You need routing conflict analysis without creating new skills
- The source is not dialog-derived and is already a written skill spec

## Use other skills instead when

- Use `meta-review-skills-for-duplicates` for collection-wide overlap/consolidation review
- Use `meta-analyze-and-improve-skill` for focused improvement of a single existing skill

## Instructions

Follow this complete process to create Skills from dialogs:

### 1. Analyze Dialogs and Extract Knowledge

Analyze provided dialog(s) and extract:

**Context and Task:**
- What was the main task/problem?
- What technologies/tools were used?
- Project type and scale

**Proven Patterns and Procedures:**
- Step-by-step algorithms that work
- Typical order of actions
- Checklists for task completion
- What to do first, what second

**Key Decisions and Rationale:**
- Which approaches were effective and why
- Why this method is better than alternatives
- When to apply, when not to

**Common Errors and Pitfalls:**
- Errors encountered
- How to recognize them early
- How to fix quickly if occurred
- What NOT to do (anti-patterns)

**Examples and Templates:**
- Concrete code/config examples that work
- Templates for quick start
- Parameters to adjust per context

**Dependencies and Requirements:**
- Prerequisites needed for application
- Factors affecting success
- Limitations and boundaries of applicability

### 2. Design Skills (Internal Plan)

Based on extracted knowledge, design potential Skills:

For each potential Skill:
- **Name and Purpose**: kebab-case name, one-line description, when to use
- **Structure**: Required sections (When to Use, Instructions, Best Practices, etc.)
- **Key Content**: Specific instructions, code/config examples, checklists, patterns
- **Priority**: Critical/Important/Nice to have
- **Complexity**: Low/Medium/High

**Keep plan internal** - don't create intermediate documents.

### 3. Generate Skills

For each designed Skill, create complete SKILL.md:

**Format (Agent Skills Standard):**
```yaml
---
name: skill-name              # kebab-case
description: Brief description in one line. Claude uses this for automatic detection.
---
```

**Structure:**
- **# Skill Name** - brief purpose description
- **## When to Use** - triggers, activation scenarios
- **## Instructions** - step-by-step process
- **## Best Practices** - recommendations
- **## Common Patterns** - typical usage patterns
- **## What NOT to Do** - common errors and anti-patterns
- **## Examples** - concrete examples (code, configs, commands)
- **## Validation Checklist** - checklist for result verification

**Principles:**
- Conciseness: 200-500 tokens (max 800)
- Specificity: for concrete context, not universal
- Practicality: focus on actions, concrete commands/examples
- Structure: clear headers, numbering for critical sequences
- Examples: 1-2 concrete examples better than general explanations

### 4. Validate Through Critic Role

**Switch to Critic role** - you're now an independent Agent Skills expert reviewing created Skills.

For each created Skill:

**Metadata Check:**
- [ ] `name` in kebab-case, no errors
- [ ] `description` - one line, max 200 characters
- [ ] Description contains keywords for automatic recognition
- [ ] Description clearly answers: "when should Claude use this skill?"

**Structure Check:**
- [ ] Has "When to Use" section with clear triggers
- [ ] Has "Instructions" section with step-by-step process
- [ ] Uses headers for navigation (## and ###)
- [ ] Numbering used for critical sequences
- [ ] Has checklist or result validation

**Content Quality:**
- [ ] Volume: 200-500 tokens (max 800)
- [ ] No obvious explanations of basic concepts
- [ ] Each paragraph has clear purpose and value
- [ ] Code/config examples concrete, minimal, but complete
- [ ] Instructions are logical and executable

**Practicality:**
- [ ] Skill solves specific task (not too broad, not too narrow)
- [ ] Errors and pitfalls documented
- [ ] Checklist helps avoid errors

**Reusability:**
- [ ] Skill works in different contexts (not tied to one project)
- [ ] Parameters/variables clearly marked (what to adjust)
- [ ] Dependencies and requirements explicitly stated

**Uniqueness:**
- [ ] Skill doesn't duplicate existing skills
- [ ] If extends existing - explicitly stated
- [ ] Has unique value distinguishing from other skills

**Quality Assessment (1-10):**
- **Specificity**: how concrete
- **Practicality**: how useful in practice
- **Conciseness**: how compact without losing meaning
- **Reusability**: how applicable in different contexts

**Improvement Recommendations:**
If found issues:
- List all found problems
- Propose concrete fixes
- Indicate fix priority (Critical/Important/Nice to have)

For a deeper review and prioritized improvement list, apply `meta-analyze-and-improve-skill` to the created SKILL.md.

### 5. Fix Issues

If validation found problems:

1. **Critical issues** - fix mandatory
2. **Important issues** - fix if possible
3. **Improvements** - fix if doesn't complicate skill

After fixes - briefly confirm problems are resolved.

### 6. Finalize

Create final Skill files:

1. **For each Skill:**
   - Create directory `.cursor/skills/skill-name/`
   - Create file `SKILL.md` with full content (after fixes)
   - If additional files needed (templates, examples, scripts) - create them

2. **Output Structure:**
   - Show path to each created Skill
   - Indicate usage: `/skill-name` or automatic
   - If connections between skills - indicate them

3. **Brief Report:**
   - How many Skills created
   - Their priorities
   - Validation results (how many problems found and fixed)
   - Usage recommendations

## Best Practices

- ✅ **Specificity over universality** - better concrete skill for specific task than universal that doesn't work anywhere
- ✅ **Practicality above all** - focus on what really saves time and prevents errors
- ✅ **Avoid duplication** - if similar skill exists, propose extending existing, not creating new
- ✅ **Document context** - preserve enough context for future understanding, but don't overload with obvious
- ✅ **Examples over explanations** - one concrete code example better than abstract description
- ✅ **No intermediate files** - work directly to final result
- ✅ **Follow standards** - Agent Skills Standard (https://agentskills.io) and Cursor (https://cursor.com/docs/context/skills)

## Common Patterns

### Knowledge Extraction Pattern

```
1. Identify main task/domain
2. Extract step-by-step procedures
3. Document decisions and rationale
4. List common errors and fixes
5. Collect working examples
6. Note dependencies and constraints
```

### Skill Design Pattern

```
1. One skill per specific task (not per domain)
2. Clear triggers in "When to Use"
3. Step-by-step instructions
4. Concrete examples
5. Validation checklist
```

### Validation Pattern

```
1. Check metadata (name, description)
2. Verify structure (sections, headers)
3. Assess content quality (conciseness, practicality)
4. Test reusability (different contexts)
5. Ensure uniqueness (no duplicates)
```

## What NOT to Do

- ❌ Don't create intermediate documents (Lessons Learned, Skills Design)
- ❌ Don't copy existing skills
- ❌ Don't explain obvious (assume Claude is smart)
- ❌ Don't make skills too universal or too narrow
- ❌ Don't skip validation step
- ❌ Don't ignore found problems

## Examples

### Example: Extracting Skill from Dialog

**Dialog context:** User and agent discussed reorganizing project structure, preserving important info, fixing links.

**Extracted knowledge:**
- Always create backup before reorganization
- Move files gradually, not all at once
- Update links immediately after moving
- Check for duplicates after reorganization

**Created Skill:** `doc-reorganize-project-structure` with step-by-step instructions, backup procedures, link update patterns.

### Example: Skill Structure

```markdown
---
name: example-skill
description: Brief description for automatic detection
---

# Example Skill

## When to Use
- Trigger 1
- Trigger 2

## Instructions
### 1. Step One
- Action 1
- Action 2

## Best Practices
- Practice 1
- Practice 2

## Validation Checklist
- [ ] Check 1
- [ ] Check 2
```

## Validation Checklist

Before completing:
- [ ] All dialogs analyzed
- [ ] Knowledge extracted (patterns, decisions, errors, examples)
- [ ] Skills designed (internal plan)
- [ ] Skills generated (SKILL.md files)
- [ ] Validation through Critic role completed
- [ ] All problems fixed
- [ ] Final files created
- [ ] Skills follow Agent Skills Standard
- [ ] Skills follow Cursor standards
- [ ] No intermediate documents created
- [ ] Skills are unique (no duplicates)

## References

- Agent Skills Standard: https://agentskills.io
- Cursor Skills Documentation: https://cursor.com/docs/context/skills

