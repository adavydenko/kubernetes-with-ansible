name: edu-educational-question-validator
description: Systematically validate educational questions for quality, fairness, and pedagogical effectiveness using multi-dimensional validation framework. Use when reviewing auto-generated questions, before deploying assessments, or ensuring question reliability.
---

# Educational Question Validator

Systematically validate educational questions using comprehensive validation frameworks, similar to unit testing in software development, to ensure quality, fairness, and effectiveness.

## Primary intent

Assess and improve quality of an existing question set before release.

## Use when

- User requests validation of question sets
- Before deploying questions to students
- Reviewing auto-generated question banks
- Ensuring assessment reliability and quality
- Quality assurance of test materials
- User mentions "validate questions", "test questions", "quality check", or "review questions"
- After generating questions to ensure they meet standards

## Do NOT use when

- Questions do not exist yet and must be created first
- The request is building a full learning roadmap
- The request is writing practical labs instead of validating assessment items
- The request is code/command syntax validation in docs

## Use other skills instead when

- Use `edu-educational-question-generator` to create new question banks
- Use `edu-structure-learning-materials` for curriculum sequencing
- Use `edu-validate-code-examples` for executable code validation in learning content

## Instructions

### 1. Content Validation

Validate that questions align with content and learning objectives:

#### Learning Objective Alignment
- [ ] Question directly tests stated learning objective
- [ ] Learning objective is measurable and specific
- [ ] Question complexity matches objective level
- [ ] No extraneous knowledge required beyond objective

**Validation Questions:**
- Does this question test what it claims to test?
- Is the learning objective clearly defined and measurable?
- Are there any knowledge gaps between prerequisite and question content?

#### Curriculum Coverage
- [ ] All major topics from curriculum are represented
- [ ] Question distribution matches topic importance
- [ ] No over-emphasis on minor topics
- [ ] Prerequisite knowledge is appropriately assumed

**Validation Questions:**
- Does the question set provide comprehensive coverage of the curriculum?
- Is the distribution of questions proportional to topic importance?

#### Accuracy and Currency
- [ ] All factual information is correct and current
- [ ] Technical details are accurate
- [ ] Examples and scenarios are realistic
- [ ] No outdated information or deprecated practices

**Validation Questions:**
- Are all facts, figures, and technical details accurate?
- Is the content current and relevant to industry standards?

### 2. Construct Validation

Validate the cognitive and pedagogical aspects:

#### Cognitive Load Analysis
- [ ] Appropriate cognitive complexity for target audience
- [ ] Clear, unambiguous language
- [ ] Logical question structure
- [ ] Appropriate use of technical terminology

**Validation Questions:**
- Is the cognitive load appropriate for the target audience?
- Are there any confusing or ambiguous elements?

#### Difficulty Calibration
- [ ] Easy questions test basic recall/understanding
- [ ] Medium questions require application/analysis
- [ ] Hard questions require synthesis/evaluation
- [ ] Difficulty progression is logical

**Validation Questions:**
- Does the difficulty level match the intended complexity?
- Is there a logical progression from easy to hard questions?

#### Bias and Fairness
- [ ] No cultural, gender, or socioeconomic bias
- [ ] Accessible to students with different backgrounds
- [ ] No assumptions about specific experiences
- [ ] Inclusive language and examples

**Validation Questions:**
- Are there any elements that might disadvantage certain groups?
- Is the language inclusive and accessible?

### 3. Technical Validation

Validate technical quality and structure:

#### Question Structure
- [ ] Clear, grammatically correct question stem
- [ ] Appropriate question type for content
- [ ] Proper formatting and presentation
- [ ] Consistent style across question set

**Validation Questions:**
- Is the question structure clear and professional?
- Are formatting and style consistent throughout?

#### Answer Quality
- [ ] Correct answer is clearly correct
- [ ] Distractors are plausible but incorrect (for MCQ)
- [ ] Answer explanations are comprehensive
- [ ] No multiple correct answers without specification

**Validation Questions:**
- Is the correct answer definitively correct?
- Are incorrect options plausible but clearly wrong?

#### Time Estimation
- [ ] Time estimates are realistic
- [ ] Time allocation matches question complexity
- [ ] Total time fits assessment constraints
- [ ] Consideration for different student speeds

**Validation Questions:**
- Are time estimates realistic for the target audience?
- Does the total time fit within assessment constraints?

### 4. Psychometric Validation

Validate statistical and measurement properties:

#### Discrimination Analysis
- [ ] Questions differentiate between high and low performers
- [ ] No questions that everyone gets right or wrong
- [ ] Appropriate difficulty distribution
- [ ] Good statistical properties

**Validation Questions:**
- Do questions effectively distinguish between different performance levels?
- Are there any questions that are too easy or too hard?

#### Reliability Assessment
- [ ] Consistent measurement across similar questions
- [ ] Internal consistency within question set
- [ ] Stable results across different administrations
- [ ] Appropriate test-retest reliability

**Validation Questions:**
- Would students get similar scores if tested again?
- Are similar questions measuring the same construct consistently?

### 5. Practical Validation

Validate implementation feasibility:

#### Administration Feasibility
- [ ] Questions can be administered within time constraints
- [ ] Technology requirements are met
- [ ] Grading is feasible and consistent
- [ ] Resources are available for implementation

**Validation Questions:**
- Can this assessment be practically administered?
- Are all necessary resources available?

#### Student Experience
- [ ] Questions are engaging and motivating
- [ ] Instructions are clear and complete
- [ ] Format is user-friendly
- [ ] Appropriate level of challenge

**Validation Questions:**
- Will students find this assessment fair and engaging?
- Are instructions clear and complete?

## Validation Framework

### Quick Validation (7-Point Checklist)

For rapid validation, check:
1. **Clarity**: Is each question clear and unambiguous?
2. **Accuracy**: Are all facts and answers correct?
3. **Appropriateness**: Is difficulty level suitable for target audience?
4. **Bias**: Are there any potentially biased elements?
5. **Coverage**: Do questions cover the intended learning objectives?
6. **Time**: Are time estimates realistic?
7. **Format**: Is formatting consistent and professional?

### Comprehensive Validation

For thorough validation, use all five categories above with detailed scoring.

## Best Practices

- ✅ Validate questions immediately after generation
- ✅ Use both automated checks and manual review
- ✅ Check for bias and accessibility issues
- ✅ Verify all factual information
- ✅ Test questions with sample students if possible
- ✅ Document validation results
- ✅ Iterate based on validation findings
- ✅ Maintain validation checklist for consistency

## Validation Report Format

```markdown
## Validation Report: [Question Set Name]

### Overall Status: [Pass | Fail | Needs Revision]
### Overall Quality Score: [X]/10

### Question-by-Question Analysis

#### Question [ID]: [Title]
- **Status**: [Pass | Fail | Needs Revision]
- **Scores**:
  - Clarity: [X]/10
  - Accuracy: [X]/10
  - Difficulty Appropriateness: [X]/10
  - Bias Detection: [X]/10
  - Learning Objective Alignment: [X]/10
- **Issues Found**: 
  - [Issue 1]
  - [Issue 2]
- **Recommendations**:
  - [Recommendation 1]
  - [Recommendation 2]
- **Priority**: [High | Medium | Low]

### Summary
- Total Questions Validated: [X]
- Passed: [X]
- Needs Revision: [X]
- Failed: [X]

### Critical Issues to Address
1. [Critical issue 1]
2. [Critical issue 2]

### Recommendations
1. [Top recommendation 1]
2. [Top recommendation 2]
```

## Prompt Template for LLM Validation

When validating questions using LLM, use this template:

```
You are an expert educational assessment specialist and psychometrician.

Validate the following questions using comprehensive criteria:

**QUESTIONS TO VALIDATE:**
[PASTE QUESTIONS HERE]

**SOURCE MATERIAL:**
[ORIGINAL LECTURE CONTENT]

**VALIDATION CRITERIA:**
1. **Clarity**: Is the question unambiguous and well-written?
2. **Accuracy**: Are all facts and the correct answer accurate?
3. **Difficulty**: Is difficulty level appropriate for stated student level?
4. **Bias**: Are there cultural, gender, or socioeconomic biases?
5. **Answer Clarity**: Is the correct answer unambiguous?
6. **Distractors Quality**: Are wrong answers plausible but clearly incorrect? (for MCQ)
7. **Objective Alignment**: Does it test stated learning objectives?
8. **Time Estimation**: Is the time estimate realistic?

**OUTPUT FORMAT:**
For each question, provide:
- Status: Pass/Fail/Needs_Revision
- Quality scores (0-1) for each criterion
- Issues found (list)
- Recommendations (list)
- Overall quality score (1-10)

Provide summary with:
- Total questions validated
- Pass/Fail/Needs_Revision counts
- Top 3 critical issues
- Improvement suggestions
```

## Validation Checklist

Before completing validation:
- [ ] Content accuracy verified
- [ ] Learning objectives aligned
- [ ] Difficulty level appropriate
- [ ] Bias-free language confirmed
- [ ] Technical quality assured
- [ ] Time estimates realistic
- [ ] Answer key verified
- [ ] Formatting consistent
- [ ] Instructions complete
- [ ] Accessibility confirmed

## Common Validation Issues

### Issue: Ambiguous Questions
**Problem**: Question can be interpreted multiple ways
**Solution**: Rewrite for clarity, remove ambiguous terms
**Example**: "What is the best approach?" → "Which approach minimizes latency?"

### Issue: Incorrect Difficulty Level
**Problem**: Question difficulty doesn't match stated level
**Solution**: Adjust complexity or reclassify difficulty
**Example**: Easy question requiring synthesis → Move to Hard or simplify

### Issue: Cultural Bias
**Problem**: Assumes specific cultural knowledge
**Solution**: Use universal examples or provide context
**Example**: References to specific holidays → Use neutral examples

### Issue: Poor Distractors
**Problem**: Wrong answers are obviously wrong or too similar
**Solution**: Create plausible but clearly incorrect options
**Example**: "A) Correct answer, B) Obviously wrong" → Make B plausible

## What NOT to Do

- ❌ Don't skip validation steps
- ❌ Don't validate only easy questions
- ❌ Don't ignore bias concerns
- ❌ Don't accept questions with factual errors
- ❌ Don't forget to check time estimates
- ❌ Don't validate without source material context
- ❌ Don't skip manual review for subjective aspects

## Integration with Question Generation

Recommended workflow:
1. Generate questions using `edu-educational-question-generator`
2. Validate questions using this skill
3. Revise questions based on validation results
4. Re-validate revised questions
5. Finalize question set

## References

- Educational Assessment Standards: Psychometric validation principles
- Question Quality Guidelines: Assessment design best practices
- Bias Detection in Assessments: Fairness and accessibility standards

