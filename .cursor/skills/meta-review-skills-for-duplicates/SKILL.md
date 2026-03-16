name: meta-review-skills-for-duplicates
description: Review all existing Agent Skills to identify duplicates, overlaps, and consolidation opportunities. Use when checking skill collection, finding duplicates, or after creating new skills.
---

# Review Skills for Duplicates

Review all existing Agent Skills in `.cursor/skills/` to identify duplicates, functional overlaps, and opportunities for consolidation.

## When to Use

- User requests review of skill collection
- Need to find duplicate or overlapping skills
- After creating new skills (check for conflicts)
- User mentions "duplicates", "overlaps", "review skills", or "consolidate skills"
- Before major skill collection reorganization
- When skill collection grows large

## Instructions

### 1. Inventory All Skills

Scan `.cursor/skills/` directory:
- List all skill directories
- Read `SKILL.md` from each skill
- Extract metadata: `name` and `description` from frontmatter
- Create inventory table: name, description, main purpose

### 2. Analyze Functionality

For each skill, identify:
- **Primary function**: What does this skill do?
- **Activation triggers**: When is it used? (from "When to Use" section)
- **Key procedures**: Main steps in "Instructions"
- **Domain/context**: What problem domain does it address?

Create functionality map for comparison.

### 3. Find Duplicates

Look for **complete functional duplication**:
- Two skills doing exactly the same thing
- Same procedures, same triggers, same purpose
- Only difference is name or minor wording

Compare:
- Descriptions (semantic similarity)
- "When to Use" sections (trigger overlap)
- "Instructions" sections (procedure similarity)
- Examples and patterns

**Flag as duplicate if:**
- Functionality is 90%+ identical
- Same use cases and triggers
- Same step-by-step process

### 4. Find Overlaps

Look for **partial functional overlap**:
- Skills with overlapping but not identical functionality
- Shared procedures or patterns
- Complementary skills that could be combined
- Skills addressing same domain from different angles

Compare:
- Shared steps in instructions
- Overlapping "When to Use" triggers
- Similar patterns in "Common Patterns"
- Related examples

**Flag as overlap if:**
- 30-90% functional similarity
- Some shared procedures
- Related but not identical purposes

### 5. Analyze Metadata Conflicts

Check for metadata issues:
- **Name conflicts**: Similar names that could confuse
- **Description conflicts**: Descriptions that don't match functionality
- **Naming inconsistencies**: Different naming patterns (e.g., `skill-name` vs `skill_name`)

### 6. Analyze Structure Similarity

Compare skill structures:
- Similar instruction patterns
- Similar section organization
- Shared "Best Practices" or "Common Patterns"
- Similar validation checklists

This helps identify skills that could share templates or be consolidated.

### 7. Provide Consolidation Recommendations

For each duplicate/overlap found:

**For Duplicates:**
- Identify which skill to keep (more complete, better location, user preference)
- Recommend removing duplicate
- Suggest updating references if needed

**For Overlaps:**
- Analyze if skills should be:
  - **Merged**: Combine into one comprehensive skill
  - **Split**: One skill is too broad, split into focused skills
  - **Refined**: Clarify boundaries, remove overlap
  - **Linked**: Keep separate but document relationship

**Recommendation format:**
```markdown
## Duplicate Found

**Skills:** `skill-a` and `skill-b`
**Issue:** Complete functional duplication
**Recommendation:** Keep `skill-a`, remove `skill-b`
**Reason:** `skill-a` has more examples and better structure

## Overlap Found

**Skills:** `skill-x` and `skill-y`
**Issue:** 60% functional overlap in validation procedures
**Recommendation:** Merge validation parts into `skill-x`, remove from `skill-y`
**Reason:** `skill-x` is more comprehensive for validation
```

### 8. Generate Report

Create structured report:
- **Summary**: Total skills reviewed, duplicates found, overlaps found
- **Duplicates**: List with recommendations
- **Overlaps**: List with recommendations
- **Metadata Issues**: Naming conflicts, description mismatches
- **Consolidation Plan**: Prioritized list of actions

## Best Practices

- ✅ Focus on functionality, not names
- ✅ Consider context of use (different contexts may justify similar skills)
- ✅ Prioritize user experience (don't break existing workflows)
- ✅ Preserve unique value of each skill
- ✅ Document relationships between related skills
- ✅ Consider skill collection evolution (some overlaps may be intentional)

## Common Patterns

### Duplication Patterns

**Validation Duplication:**
- Multiple skills with similar validation procedures
- Solution: Create shared validation skill or consolidate

**Documentation Duplication:**
- Skills with overlapping documentation patterns
- Solution: Extract common patterns to shared reference

**Workflow Duplication:**
- Skills with similar step-by-step workflows
- Solution: Identify if one can be generalized

### Overlap Patterns

**Complementary Skills:**
- Skills that work together (e.g., create + validate)
- Solution: Document relationship, keep separate

**Domain Overlap:**
- Skills addressing same domain from different angles
- Solution: Clarify boundaries, refine "When to Use"

**Pattern Overlap:**
- Skills sharing common patterns but different purposes
- Solution: Extract patterns to shared reference

## What NOT to Do

- ❌ Don't suggest merging skills with different contexts of use
- ❌ Don't remove skills without understanding their unique value
- ❌ Don't ignore user preferences if mentioned
- ❌ Don't break existing workflows without careful consideration
- ❌ Don't create overly generic skills to avoid duplication
- ❌ Don't merge skills just because they share some procedures

## Examples

### Example: Duplicate Detection

**Skills:**
- `validate-links` - validates and fixes broken links
- `check-broken-links` - checks for broken links and fixes them

**Analysis:** Complete duplication (same functionality, same procedures)

**Recommendation:** Keep `validate-links` (better name), remove `check-broken-links`

### Example: Overlap Detection

**Skills:**
- `doc-reorganize-project-structure` - reorganizes files, preserves info, fixes links
- `doc-eliminate-duplication` - finds and removes duplicate content

**Analysis:** Overlap in link fixing and content preservation procedures

**Recommendation:** Keep separate (different primary purposes), document that `reorganize-project-structure` can use `eliminate-duplication` after reorganization

### Example: Consolidation Recommendation

**Skills:**
- `create-documentation` - creates technical documentation
- `structure-documentation` - structures existing documentation
- `format-documentation` - formats documentation

**Analysis:** All three address documentation but from different angles

**Recommendation:** Consider merging into `documentation-workflow` with clear sections for create/structure/format, OR keep separate but document workflow relationship

## Validation Checklist

Before completing review:
- [ ] All skills in `.cursor/skills/` inventoried
- [ ] Functionality analyzed for each skill
- [ ] Duplicates identified and documented
- [ ] Overlaps identified and documented
- [ ] Metadata conflicts checked
- [ ] Structure similarities analyzed
- [ ] Consolidation recommendations provided
- [ ] Report generated with clear action items
- [ ] Recommendations prioritize user experience

## References

- Agent Skills Standard: https://agentskills.io
- Cursor Skills Documentation: https://cursor.com/docs/context/skills

