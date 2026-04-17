name: edu-educational-question-generator
description: Generate comprehensive educational questions from lecture materials (PPTX/PDF) with appropriate difficulty distribution. Use when creating quiz/test materials, generating practice questions, or building assessment banks from course content.
---

# Educational Question Generator

Generate high-quality educational questions from lecture materials at varying difficulty levels (easy, medium, hard) with proper alignment to learning objectives and Bloom's taxonomy.

## Primary intent

Create new assessment questions from source learning materials.

## Use when

- User requests question generation from lecture materials
- Creating quiz/test materials from PPTX/PDF content
- Generating practice questions for students
- Building assessment banks from course content
- User mentions "generate questions", "create quiz", "test questions", or "assessment"
- Need to create questions at different difficulty levels

## Do NOT use when

- The question set already exists and needs quality audit
- The request is course structure/roadmap creation
- The request is practical lab assignment design (not question bank generation)
- The request is rubric/progress tracking only

## Use other skills instead when

- Use `edu-educational-question-validator` to review and score existing questions
- Use `edu-structure-learning-materials` for learning path architecture
- Use `edu-create-practical-exercises` for hands-on exercise design

## Instructions

### 1. Analyze Source Material

Before generating questions:
- Extract or read text content from lecture materials (PPTX/PDF)
- Identify key topics and concepts covered
- Determine learning objectives from the material
- Note the subject area and student level
- Understand the depth and complexity of the content

### 2. Determine Question Requirements

For each generation request:
- **Subject Area**: Identify the domain (e.g., "Kubernetes", "Computer Science", "Business Management")
- **Student Level**: Determine target audience (e.g., "undergraduate", "graduate", "professional")
- **Course Level**: Assess difficulty (e.g., "beginner", "intermediate", "advanced")
- **Question Count**: Total number of questions needed
- **Difficulty Distribution**: Default 30% easy, 40% medium, 30% hard (customizable)
- **Question Types**: Multiple choice, short answer, essay, true/false, matching, practical

### 3. Generate Questions with Proper Structure

For each question, ensure:

#### Question Components
- **Clear Question Stem**: Unambiguous, grammatically correct
- **Question Type**: Appropriate for the content and learning objective
- **Difficulty Level**: Matches stated difficulty (easy/medium/hard)
- **Learning Objective**: Directly tests stated objective
- **Bloom's Taxonomy Level**: Remember, Understand, Apply, Analyze, Evaluate, or Create

#### For Multiple Choice Questions
- **Correct Answer**: Clearly correct and verifiable
- **Distractors**: Plausible but definitively incorrect
- **Options**: Typically 4 options (A, B, C, D)
- **No Trick Questions**: Fair and straightforward

#### For All Question Types
- **Answer Key**: Correct answer provided
- **Explanation**: Detailed explanation of why the answer is correct
- **Estimated Time**: Realistic time to answer (in minutes)
- **Related Topics**: List of related concepts

### 4. Apply Difficulty Distribution

Ensure proper distribution:
- **Easy (30%)**: Test basic recall, definitions, identification
  - Bloom's levels: Remember, Understand
  - Simple application of fundamental principles
  - Format: Multiple choice, true/false, fill-in-the-blank

- **Medium (40%)**: Test application and analysis
  - Bloom's levels: Apply, Analyze
  - Problem-solving with given scenarios
  - Format: Short answer, scenario-based multiple choice, practical problems

- **Hard (30%)**: Test synthesis and evaluation
  - Bloom's levels: Evaluate, Create
  - Integration of multiple concepts
  - Format: Essay questions, complex scenarios, design problems

### 5. Align with Learning Objectives

For each question:
- Map to specific learning objectives from the material
- Ensure questions test what they claim to test
- Verify no extraneous knowledge required beyond objectives
- Check that difficulty matches objective complexity

### 6. Customize for Subject Area

Apply subject-specific considerations:

#### For Technical/STEM Subjects
- Include mathematical problems where applicable
- Test both theoretical understanding and practical implementation
- Include debugging/troubleshooting scenarios
- Test knowledge of best practices and industry standards
- Include questions about trade-offs and design decisions

#### For Business/Management Courses
- Include case study analysis questions
- Test decision-making under uncertainty
- Include questions about ethical considerations
- Test understanding of stakeholder perspectives
- Include questions about implementation challenges

#### For Humanities/Social Sciences
- Include critical analysis of arguments
- Test understanding of different perspectives
- Include questions about historical context
- Test ability to synthesize multiple sources
- Include questions about implications and consequences

## Best Practices

- ✅ Always specify subject area, student level, and course context
- ✅ Use clear, unambiguous language in questions
- ✅ Ensure all factual information is accurate and current
- ✅ Create questions that are culturally inclusive and accessible
- ✅ Provide comprehensive explanations for answers
- ✅ Include realistic time estimates
- ✅ Test questions for clarity before finalizing
- ✅ Ensure proper difficulty distribution
- ✅ Align questions with stated learning objectives
- ✅ Use appropriate question types for content

## Question Format Template

```markdown
### Question [ID]: [Title/Short Description]

**Type:** [Multiple Choice | Short Answer | Essay | True/False | Practical]
**Difficulty:** [Easy | Medium | Hard]
**Learning Objective:** [Specific objective being tested]
**Bloom's Level:** [Remember | Understand | Apply | Analyze | Evaluate | Create]
**Estimated Time:** [X] minutes

**Question:**
[Question text here]

**Options:** (if multiple choice)
- A) [Option A]
- B) [Option B]
- C) [Option C]
- D) [Option D]

**Correct Answer:** [Answer]

**Explanation:**
[Detailed explanation of why the answer is correct, including:
- Why the correct answer is right
- Why other options are wrong (if applicable)
- Key concepts involved
- Related topics]

**Related Topics:** [List of related concepts]
```

## Prompt Template for LLM Generation

When generating questions using LLM, use this template:

```
You are an expert educational content creator specializing in [SUBJECT_AREA].

Generate [NUMBER] educational questions from the following lecture material:

**LECTURE MATERIAL:**
[PASTE LECTURE CONTENT HERE]

**REQUIREMENTS:**
- Subject Area: [SUBJECT]
- Target Audience: [STUDENT_LEVEL]
- Course Level: [COURSE_LEVEL]
- Difficulty Distribution: 30% easy, 40% medium, 30% hard
- Question Types: [SPECIFY TYPES]
- Learning Objectives: [LIST OBJECTIVES]

**OUTPUT FORMAT:**
For each question, provide:
- Question ID and type
- Difficulty level (Easy/Medium/Hard)
- Learning objective
- The question text
- Answer options (if applicable)
- Correct answer
- Detailed explanation
- Estimated time to answer
- Related concepts/topics
- Bloom's taxonomy level

Generate questions that:
- Test different levels of understanding
- Are clear and unambiguous
- Are culturally inclusive
- Have accurate factual information
- Include comprehensive explanations
```

## Common Patterns

### Pattern 1: Concept Definition Questions (Easy)
```
Question: "What is [concept]?"
- Tests: Basic recall and understanding
- Format: Multiple choice or short answer
- Bloom's: Remember/Understand
```

### Pattern 2: Application Questions (Medium)
```
Question: "Given [scenario], how would you [action]?"
- Tests: Application of concepts to new situations
- Format: Scenario-based multiple choice or short answer
- Bloom's: Apply/Analyze
```

### Pattern 3: Synthesis Questions (Hard)
```
Question: "Compare and contrast [concept A] and [concept B], and explain when to use each."
- Tests: Integration of multiple concepts and evaluation
- Format: Essay or complex scenario
- Bloom's: Evaluate/Create
```

## What NOT to Do

- ❌ Don't create questions without clear learning objectives
- ❌ Don't use ambiguous or confusing language
- ❌ Don't include trick questions or gotcha elements
- ❌ Don't create questions that require knowledge beyond the material
- ❌ Don't forget to provide explanations for answers
- ❌ Don't ignore cultural bias or accessibility concerns
- ❌ Don't create questions that are too easy or too hard for the stated level
- ❌ Don't skip difficulty distribution requirements

## Validation Checklist

Before finalizing generated questions:
- [ ] All questions have clear learning objectives
- [ ] Difficulty distribution matches requirements (30/40/30)
- [ ] Questions are clear and unambiguous
- [ ] All factual information is accurate
- [ ] Questions are culturally inclusive
- [ ] Time estimates are realistic
- [ ] Answer keys are provided
- [ ] Explanations are comprehensive
- [ ] Question types are appropriate for content
- [ ] Bloom's taxonomy levels are correctly assigned

## Example Output

```markdown
## Question Set: Kubernetes Basics

### Question 1: Pod Definition

**Type:** Multiple Choice
**Difficulty:** Easy
**Learning Objective:** Understand what a Pod is in Kubernetes
**Bloom's Level:** Remember
**Estimated Time:** 2 minutes

**Question:**
What is a Pod in Kubernetes?

**Options:**
- A) A virtual machine
- B) The smallest deployable unit that can contain one or more containers
- C) A network interface
- D) A file system

**Correct Answer:** B

**Explanation:**
A Pod is the smallest deployable unit in Kubernetes that can contain one or more containers. Pods share network and storage resources and are scheduled together on the same node. This is a fundamental concept in Kubernetes architecture.

**Related Topics:** Containers, Kubernetes Architecture, Deployment
```

## References

- Bloom's Taxonomy: https://cft.vanderbilt.edu/guides-sub-pages/blooms-taxonomy/
- Question Generation Best Practices: Educational assessment standards
- Multiple Choice Question Guidelines: Assessment design principles

