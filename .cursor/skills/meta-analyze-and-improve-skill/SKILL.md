name: meta-analyze-and-improve-skill
description: Perform deep analysis of a specific Agent Skill and propose concrete improvements. Use when improving existing skill, checking quality, optimizing skill, or ensuring standards compliance.
---

# Analyze and Improve Skill

Perform comprehensive analysis of a specific Agent Skill, identify issues, and propose concrete improvements with priorities.

## Primary intent

Improve one selected existing skill through deep quality analysis and concrete edits/recommendations.

## Use when

- User wants to improve existing skill
- Need to check skill quality
- Optimizing skill for better performance
- Ensuring standards compliance
- User mentions "improve skill", "check skill quality", "optimize skill", or "review skill"
- After skill creation to validate quality
- After creating a skill from a dialog (`meta-create-skills-from-dialogs`) to validate quality
- When skill seems too verbose or unclear

## Do NOT use when

- The goal is reviewing the entire skill library for duplicates
- The goal is creating a new skill from dialog transcripts
- The request is not skill-quality analysis (e.g., domain task implementation)
- You only need light typo edits without quality review

## Use other skills instead when

- Use `meta-review-skills-for-duplicates` for collection-wide dedup/consolidation
- Use `meta-create-skills-from-dialogs` to author new skills from conversations

## Instructions

### 1. Read and Understand Skill

Read the skill file completely:
- Read `.cursor/skills/skill-name/SKILL.md`
- Understand structure and content
- Identify purpose and scope
- Note all sections present
- Understand target use cases

### 2. Analyze Metadata

Check YAML frontmatter:

**Name:**
- [ ] Format: kebab-case (lowercase, hyphens)
- [ ] Descriptive and clear
- [ ] No conflicts with existing skills
- [ ] Matches skill functionality

**Description:**
- [ ] One line, max 200 characters
- [ ] Contains keywords for automatic detection
- [ ] Clearly indicates when to use skill
- [ ] Matches actual skill functionality
- [ ] No vague or generic phrases

**Issues to flag:**
- Name doesn't match functionality
- Description too vague or too specific
- Missing keywords for detection
- Description doesn't answer "when to use?"

### 3. Analyze Structure

Check skill structure:

**Required Sections:**
- [ ] "When to Use" - clear triggers
- [ ] "Instructions" - step-by-step process
- [ ] At least one of: "Best Practices", "Common Patterns", "What NOT to Do"
- [ ] "Validation Checklist" or similar validation

**Organization:**
- [ ] Clear headers (## and ###)
- [ ] Logical flow of information
- [ ] Numbering for critical sequences
- [ ] Consistent formatting

**Issues to flag:**
- Missing critical sections
- Poor organization
- Inconsistent formatting
- Unclear structure

### 4. Analyze Content Quality

Assess content:

**Conciseness:**
- [ ] Volume: 200-500 tokens (max 800)
- [ ] No obvious explanations of basic concepts
- [ ] Each paragraph has clear purpose
- [ ] No redundant information

**Practicality:**
- [ ] Instructions are executable
- [ ] Concrete commands/examples provided
- [ ] Examples are minimal but complete
- [ ] Focus on actions, not theory

**Specificity:**
- [ ] Skill solves specific task (not too broad/narrow)
- [ ] Context is sufficient but not overloaded
- [ ] Boundaries of applicability clear
- [ ] Not trying to be universal

**Issues to flag:**
- Too verbose (explaining obvious)
- Too vague (lacks concrete steps)
- Too broad (trying to do everything)
- Too narrow (only one specific case)

### 5. Check Examples

Review examples:

**Quality:**
- [ ] Examples are concrete and complete
- [ ] Examples are minimal (show pattern, not full solution)
- [ ] Examples are correct and tested
- [ ] Examples cover different scenarios if needed

**Relevance:**
- [ ] Examples match skill purpose
- [ ] Examples are up-to-date
- [ ] Examples are practical

**Issues to flag:**
- Missing examples where needed
- Examples too complex or too simple
- Outdated examples
- Examples don't match skill purpose

### 6. Check Reusability

Assess if skill works in different contexts:

- [ ] Not tied to one specific project
- [ ] Parameters/variables clearly marked
- [ ] Dependencies and requirements explicit
- [ ] Can be adapted to different contexts
- [ ] Boundaries of applicability documented

**Issues to flag:**
- Too project-specific
- Hidden dependencies
- Unclear what to adjust
- Can't be reused

### 7. Compare with Best Practices

Check against standards:

**Agent Skills Standard (https://agentskills.io):**
- [ ] Follows standard structure
- [ ] YAML frontmatter correct
- [ ] Markdown content follows guidelines

**Cursor Standards (https://cursor.com/docs/context/skills):**
- [ ] Appropriate level of detail
- [ ] Assumes Claude is smart (no obvious explanations)
- [ ] Only context model doesn't have

**Project Patterns:**
- [ ] Consistent with other skills in project
- [ ] Follows established patterns
- [ ] Uses similar structure

**Issues to flag:**
- Doesn't follow standards
- Inconsistent with project patterns
- Too much obvious explanation

### 8. Identify Problems

Categorize found issues:

**Critical:**
- Metadata incorrect or misleading
- Missing critical sections
- Instructions are incorrect or incomplete
- Examples are wrong

**Important:**
- Structure issues affecting usability
- Content quality problems
- Missing examples where needed
- Reusability issues

**Improvements:**
- Minor formatting issues
- Could be more concise
- Could have better examples
- Could be better organized

### 9. Propose Improvements

For each issue, provide:

**Problem:**
- What's wrong
- Why it's a problem
- Impact on usage

**Solution:**
- Concrete fix proposal
- Specific changes needed
- Example of improved version

**Priority:**
- Critical (fix immediately)
- Important (fix soon)
- Nice to have (improvement)

**Example improvement proposal:**
```markdown
## Issue: Description too vague

**Problem:** Description "Helps with tasks" doesn't indicate when to use skill
**Impact:** Agent won't know when to activate skill
**Solution:** Change to "Generate validation scripts for system configurations. Use when user needs automated validation, health checks, or diagnostic tools."
**Priority:** Critical
```

### 10. Apply Improvements (if user agrees)

If user approves improvements:

1. **Apply Critical fixes** - mandatory
2. **Apply Important fixes** - recommended
3. **Apply Improvements** - optional

After applying:
- Verify fixes are correct
- Check skill still follows standards
- Confirm no new issues introduced
- Update skill file

## Best Practices

- ✅ Preserve specificity (don't make too universal)
- ✅ Focus on practicality (actions over theory)
- ✅ Maintain context (don't remove important context)
- ✅ Follow standards (Agent Skills, Cursor)
- ✅ Be concrete (specific fixes, not general advice)
- ✅ Prioritize (critical > important > improvements)

## Common Patterns

### Quality Issues Pattern

**Too Verbose:**
- Explaining basic concepts
- Repeating obvious information
- Over-explaining simple steps

**Solution:** Remove obvious explanations, assume Claude is smart

**Too Vague:**
- Lacks concrete steps
- Generic instructions
- Missing examples

**Solution:** Add concrete steps, specific examples, clear procedures

**Too Broad:**
- Trying to solve everything
- Multiple unrelated purposes
- Unclear boundaries

**Solution:** Split into focused skills or clarify scope

**Too Narrow:**
- Only one specific case
- Can't be reused
- Too project-specific

**Solution:** Generalize patterns, extract reusable parts

### Improvement Pattern

```
1. Identify specific problem
2. Understand why it's a problem
3. Propose concrete fix
4. Show example of improvement
5. Prioritize fix
6. Apply if approved
```

## What NOT to Do

- ❌ Don't remove important context
- ❌ Don't make skill too universal
- ❌ Don't break existing functionality
- ❌ Don't suggest changes without understanding skill purpose
- ❌ Don't ignore user preferences
- ❌ Don't create new problems while fixing old ones

## Examples

### Example: Metadata Improvement

**Before:**
```yaml
---
name: doc-skill
description: Helps with documentation
---
```

**Issues:**
- Name too generic
- Description too vague, no keywords

**After:**
```yaml
---
name: technical-documentation-structure
description: Create modular structure for technical documentation by splitting large documents into logical modules. Use when documentation files are too large or need better organization.
---
```

### Example: Content Improvement

**Before:**
```markdown
## Instructions

Be careful when doing this. Make sure you understand what you're doing. Check everything twice.
```

**Issues:**
- Too vague, no concrete steps
- Generic advice

**After:**
```markdown
## Instructions

### 1. Analyze Document Structure
- Read document to identify main topics
- List all sections and subsections
- Map relationships between sections

### 2. Create Module Structure
- Group related sections
- Create separate files for each module
- Maintain logical hierarchy
```

### Example: Structure Improvement

**Before:**
```markdown
# Skill Name

Some instructions here. More instructions. Even more.
```

**Issues:**
- No clear structure
- No sections
- Hard to navigate

**After:**
```markdown
# Skill Name

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
```

## Validation Checklist

Before completing analysis:
- [ ] Skill fully read and understood
- [ ] Metadata analyzed (name, description)
- [ ] Structure analyzed (sections, organization)
- [ ] Content quality assessed (conciseness, practicality, specificity)
- [ ] Examples checked (quality, relevance)
- [ ] Reusability verified
- [ ] Standards compliance checked
- [ ] Problems identified and categorized
- [ ] Improvements proposed with priorities
- [ ] Improvements applied (if approved)
- [ ] Final skill validated

## References

- Agent Skills Standard: https://agentskills.io
- Cursor Skills Documentation: https://cursor.com/docs/context/skills

