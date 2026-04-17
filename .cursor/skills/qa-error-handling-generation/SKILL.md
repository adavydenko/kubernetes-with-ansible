name: qa-error-handling-generation
description: Handle errors gracefully during documentation generation when generation fails or hits limits. Use when generation has already failed or reported a limit error, for fallback strategies and partial result recovery.
---

# Error Handling for Documentation Generation

Handle errors gracefully during documentation generation, including token limits, file size issues, and generation failures.

## Primary intent

Recover from documentation-generation failures and preserve progress with explicit fallback strategies.

## Use when

- Generation has already failed or reported a token/size limit error
- Documentation generation fails
- Token limit errors occur
- File size exceeds limits
- Generation process errors
- User reports generation issues
- Need robust error recovery

## Do NOT use when

- You are still planning and can prevent limits proactively
- The task is only file/module architecture design
- The task is only link validation or markdown cleanup
- The task is translation QA

## Use other skills instead when

- Use `qa-file-size-management` before failures occur to prevent size-limit issues
- Use `doc-technical-documentation-structure` for deterministic module split design
- Use `qa-validate-and-fix-links` for broken link repair after file changes

## Instructions

### 1. Monitor Generation Process

During generation:
- Track output size in real-time
- Monitor token count
- Check for error messages
- Validate intermediate results

### 2. Detect Token Limit Issues

Identify when approaching limits:
- Estimate content size before generation
- Check token count during generation
- Detect "token limit exceeded" errors
- Monitor file sizes

### 3. Apply Fallback Strategies

When limits are hit:
- **Split Strategy**: Divide content into smaller files
- **Reduce Strategy**: Condense or summarize content
- **Chunk Strategy**: Generate in smaller chunks
- **Defer Strategy**: Generate reference materials separately

### 4. Preserve Partial Results

When errors occur:
- Save completed sections
- Document what was generated
- Note what failed
- Preserve intermediate files

### 5. Provide Clear Error Messages

When errors happen:
- Explain what went wrong
- Suggest solutions
- Provide recovery steps
- Show what was completed

### 6. Implement Retry Logic

For recoverable errors:
- Retry with smaller chunks
- Retry with different strategy
- Skip problematic sections
- Generate alternative content

### 7. Create Error Reports

Document issues:
- List all errors encountered
- Show partial results
- Provide recovery suggestions
- Include generation statistics

## Best Practices

- ✅ Check size before generation
- ✅ Monitor during generation
- ✅ Save partial results
- ✅ Provide actionable error messages
- ✅ Implement graceful degradation
- ✅ Log all errors for debugging
- ✅ Suggest recovery strategies

## Error Detection Patterns

### Token Limit Detection
```python
# Pseudo-code
max_tokens = 150000
current_tokens = estimate_content_size(content)

if current_tokens > max_tokens:
    error = "Content exceeds token limit"
    suggestion = "Split into multiple files"
    apply_strategy = "split_by_topic"
```

### File Size Detection
```bash
# Check file size
file_size=$(wc -l < file.md)
if [ $file_size -gt 2000 ]; then
    echo "Warning: File exceeds recommended size"
    echo "Consider splitting into smaller files"
fi
```

## Fallback Strategies

### Strategy 1: Split Content
```
Error: Token limit exceeded
Action: Split into multiple files
Result:
  - file-part1.md (within limits)
  - file-part2.md (within limits)
  - file-part3.md (within limits)
```

### Strategy 2: Reduce Content
```
Error: Content too large
Action: Summarize or condense
Result:
  - Shorter, more concise version
  - Detailed sections moved to separate files
```

### Strategy 3: Chunk Generation
```
Error: Single generation too large
Action: Generate in chunks
Result:
  - Generate section by section
  - Combine after completion
```

## Error Message Format

```markdown
## Generation Error

**Error Type**: Token Limit Exceeded
**File**: K8S.md
**Estimated Size**: 250K tokens
**Limit**: 150K tokens

**What Happened**:
Content generation exceeded token limits during creation.

**What Was Completed**:
- ✅ Sections 1-5 generated successfully
- ✅ Glossary created
- ❌ Advanced topics section failed

**Recovery Options**:
1. Split file into multiple parts
2. Reduce content in advanced sections
3. Generate advanced topics separately

**Suggested Action**:
Split K8S.md into:
- K8S_BASICS.md (sections 1-5)
- K8S_ADVANCED.md (advanced topics)
```

## What NOT to Do

- ❌ Don't fail silently
- ❌ Don't lose partial results
- ❌ Don't provide vague error messages
- ❌ Don't ignore size warnings
- ❌ Don't retry without strategy change
- ❌ Don't skip error logging

## Example Workflow

1. **Monitor**: Track generation progress and size
2. **Detect**: Identify when approaching limits
3. **Warn**: Alert before hitting limits if possible
4. **Handle**: Apply fallback strategy when error occurs
5. **Preserve**: Save all completed work
6. **Report**: Document error and recovery
7. **Recover**: Continue with adjusted strategy

## Related Skills

- `qa-file-size-management` - Prevent size issues
- `doc-technical-documentation-structure` - Organize after error recovery
- `doc-reorganize-project-structure` - Ensure critical content remains intact during recovery-driven splits

