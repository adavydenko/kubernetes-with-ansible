---
name: doc-adapt-technical-notes-to-textbook
description: Transform technical notes and brief documentation into comprehensive educational textbooks for students. Use when user wants to convert technical notes into learning materials, expand brief technical descriptions for educational purposes, or create student-friendly textbooks with explanations, examples, and exercises in a target language.
---

# Adapt Technical Notes to Textbook

Transform technical notes and brief documentation into comprehensive educational textbooks suitable for students, with expanded explanations, practical examples, learning objectives, and assessment materials. **Output language: requested target language (for example English or Russian).**

## Primary intent

Transform one technical source document into a student-ready textbook with pedagogy (objectives, checks, exercises, resources).

## Use when

- User wants to convert technical notes into educational materials in a specific language
- Need to adapt technical documentation for students in the target language
- User requests to create a textbook or learning guide from notes
- Technical material is too brief and needs educational expansion
- User mentions "textbook", "learning materials", "for students", "educational guide", or "teaching materials"
- Converting expert-level notes into beginner-friendly content
- Creating course materials from technical documentation
- When you only need to improve readability without educational structure — use `doc-enhance-technical-markdown`
- Use for a single document; for organizing multiple materials into a course use `edu-structure-learning-materials`

## Do NOT use when

- You only need readability improvements without educational scaffolding
- You need a cross-document course map or learning path architecture
- You are generating only quiz banks or validating questions
- You are translating documentation between languages

## Use other skills instead when

- Use `doc-enhance-technical-markdown` for non-pedagogical expansion
- Use `edu-structure-learning-materials` for multi-file learning roadmap design
- Use `edu-create-practical-exercises` when only exercise packs are requested
- Use `edu-educational-question-generator` when the request is only assessment question generation

## Instructions

### 1. Analyze Source Material

Before transformation:
- Read the entire source document completely
- Identify document structure (headings, sections, lists, tables, code blocks)
- Note all technical terms and concepts that need explanation
- Identify brief descriptions that need expansion
- Understand the technical domain and target audience level
- Note existing examples, links, and references
- Determine learning objectives for each section

### 2. Design Educational Structure

Create logical learning progression:

**Document Structure:**
- **Introduction** - overview, learning objectives, prerequisites
- **Theoretical Foundation** - core concepts with explanations
- **Practical Examples** - step-by-step tutorials with explanations
- **Knowledge Checks** - questions and exercises
- **Additional Resources** - links to documentation, videos, courses
- **Glossary** - key terms definitions
- **FAQ** - common questions and answers
- **Troubleshooting** - common problems and solutions

**Learning Progression:**
- Start with basics and build complexity gradually
- Each section should have clear learning objectives
- Connect concepts logically (prerequisites → concepts → application)
- Include practical exercises after each major concept

### 3. Expand Technical Content

Transform brief technical notes into educational explanations:

**Expansion Pattern:**
1. **What** - clear definition and context
2. **Why** - real-world problems it solves, use cases
3. **How** - step-by-step explanation with examples
4. **When** - appropriate scenarios for application
5. **Best Practices** - recommendations and tips
6. **Common Mistakes** - what to avoid

**Example Transformation:**

**Before (technical note):**
```markdown
MetalLB - load balancer for bare metal clusters
IP pool: 10.0.2.240-10.0.2.250
Install: ansible-playbook --tags metallb
```

**After (educational textbook):**
```markdown
## What is MetalLB?

MetalLB is a specialized component that solves the problem of load balancing in Kubernetes clusters that run on bare metal servers instead of in a cloud provider.

### Why do we need it?

In cloud environments (AWS, GCP, Azure), Kubernetes can automatically provision external IP addresses for `LoadBalancer` services. On bare metal clusters there is no cloud load balancer, so Kubernetes cannot do this out of the box. MetalLB fills this gap.

### How does it work?

1. **IP Address Pool** – reserves a range of IP addresses (in our example `10.0.2.240-10.0.2.250`)
2. **Layer 2 Mode** – uses standard network protocols to advertise IPs on the local network
3. **Automatic Assignment** – when you create a `LoadBalancer` service, MetalLB automatically assigns it a free IP from the pool

### Practical use case

Imagine you have a web application that must be reachable from the internet. On a bare metal cluster this is not possible with a plain `ClusterIP` service. With MetalLB, you expose the service as `LoadBalancer` and MetalLB gives it an external IP with a single command.

## Installing MetalLB

### Step 1: Run the Ansible playbook
```bash
ansible-playbook -i inventory.yml site.yml --tags metallb
```

**What happens:** Ansible installs all MetalLB components into the Kubernetes cluster.

### Step 2: Verify installation
```bash
kubectl get pods -n metallb-system
```

**Expected result:** All MetalLB pods should be in `Running` state.

### Step 3: Create a test application
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

**What happens:** A test application and `LoadBalancer` service are created, and MetalLB automatically assigns an external IP.

## Check your understanding

1. What is a bare metal cluster?
2. Why is MetalLB needed only for bare metal clusters?
3. What IP range is used in our example?
4. What happens when you create a `LoadBalancer` service with MetalLB?

## Additional resources

- [MetalLB official documentation](https://metallb.universe.tf/)
- [Video: Understanding MetalLB](https://youtube.com/...)
- [Lab: Load Balancing in Kubernetes](https://katacoda.com/...)
```

### 4. Add Educational Elements

Enrich content with educational components:

**Learning Objectives:**
- Add clear learning objectives at the start of each major section
- Suggested format: "After completing this section, you will be able to:"
- List 3–5 specific skills or knowledge points

**Practical Examples:**
- Include 2–3 concrete examples per major concept
- Show real-world scenarios
- Provide step-by-step walkthroughs
- Include expected outputs and verification steps

**Knowledge Checks:**
- Add questions after each section (3–5 questions)
- Mix question types: multiple choice, short answer, practical tasks
- Include difficulty levels: basic, intermediate, advanced
- Provide answers or hints where appropriate

**Visual Aids:**
- Describe diagrams and visualizations (architecture, flowcharts)
- Use tables for comparisons
- Include code examples with comments
- Add screenshot descriptions where helpful

**Glossary:**
- Define all technical terms when first introduced
- Create a comprehensive glossary at the end
- Cross-reference terms throughout the document

### 5. Enhance Readability

Apply educational writing principles:

**Language:**
- Use accessible language (avoid unnecessary jargon, explain when needed)
- Prefer active voice
- Keep sentences short (12–18 words on average)
- Use simple, clear vocabulary
- Explain complex concepts in simple terms first

**Structure:**
- Break long paragraphs into shorter ones (3–5 sentences)
- Use subheadings to organize content
- Use bullet points for lists of concepts
- Add visual breaks between sections
- Use formatting (bold, italic) strategically

**Progression:**
- Start with basics, then move to advanced topics
- Connect new concepts to previously learned ones
- Use analogies for complex technical concepts
- Provide context before diving into details

### 6. Add Practical Exercises

Create hands-on learning opportunities:

**Exercise Types:**
- **Guided Practice** – step-by-step tutorials with explanations
- **Independent Practice** – tasks to complete without full instructions
- **Problem Solving** – real-world scenarios to solve
- **Experimentation** – tasks encouraging exploration
- **Review Questions** – knowledge checks

**Exercise Structure:**
- Clear objective
- Prerequisites
- Step-by-step instructions (for guided practice)
- Expected results
- Verification steps
- Troubleshooting tips

### 7. Include Additional Resources

Add learning support materials:

**Resource Types:**
- Official documentation links
- Video tutorials
- Interactive labs (Katacoda, Play with Kubernetes)
- Community forums
- Related courses
- Books and articles

**Resource Organization:**
- Group by topic
- Indicate difficulty level
- Note prerequisites
- Include brief descriptions

### 8. Create Assessment Materials

Add knowledge validation:

**Question Types:**
- Multiple choice (with explanations)
- Short answer
- Practical tasks
- Essay questions (for advanced topics)
- True/False with explanations

**Assessment Structure:**
- Questions aligned with learning objectives
- Mix of difficulty levels
- Answers or answer keys
- Explanations for correct answers

### 9. Apply Transformation

Process the document:

1. **Read the source file** completely
2. **Identify learning objectives** for each section
3. **Expand technical notes** following the expansion pattern
4. **Add educational elements** (objectives, examples, exercises)
5. **Enhance readability** (language, structure, progression)
6. **Create practical exercises** for key concepts
7. **Add resources and glossary**
8. **Include assessment materials**
9. **Verify structure** – ensure all links and code blocks are preserved
10. **Check educational value** – ensure material is suitable for students

## Best Practices

- ✅ Start with learning objectives for each section
- ✅ Explain concepts before diving into technical details
- ✅ Use real-world analogies for complex technical concepts
- ✅ Provide step-by-step examples with explanations
- ✅ Include knowledge checks after each major concept
- ✅ Create practical exercises aligned with learning objectives
- ✅ Define technical terms when first introduced
- ✅ Maintain technical accuracy while improving accessibility
- ✅ Preserve all code blocks, links, and technical details
- ✅ Structure content for progressive learning (basics → advanced)
- ✅ Include troubleshooting and common mistakes sections
- ✅ Add visual aids descriptions and diagrams

## Transformation Pattern

### Pattern: Technical Note → Educational Section

**Input (technical note):**
```markdown
## Feature Name
Brief technical description.
Command: `example-command`
```

**Output (educational textbook):**
```markdown
## Feature Name

### Learning objectives
After completing this section, you will be able to:
- Explain the purpose and use cases of Feature Name
- Configure Feature Name in practical scenarios
- Troubleshoot common issues related to Feature Name

### What is it?

[Clear definition with context]

### Why is it important?

[Real-world problems it solves, use cases, scenarios]

### How does it work?

[Step-by-step explanation with examples]

### Practical example

```bash
example-command
```

**What happens:** [Explanation of what the command does]

**Expected result:** [What to expect]

### Check your understanding

1. [Question 1]
2. [Question 2]
3. [Question 3]

### Practical assignment

**Objective:** [Objective]

**Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Verification:** [How to verify success]

### Additional resources

- [Resource 1]
- [Resource 2]
```

## Prompt Template for LLM

When transforming technical notes using an LLM, use this template:

```
You are an experienced technical writer and instructor specializing in DevOps and Kubernetes. Your task is to transform technical notes into a well-structured learning textbook for students in the requested target language.

## Context
You have technical notes about [technology/domain]. The material is written as bullet points for technical specialists, but it must be made accessible for students who are learning these technologies.

## Goals
1. **Structure the material** – create a logical learning sequence
2. **Explain concepts** – add foundational explanations for beginners
3. **Enrich with examples** – include practical examples and scenarios
4. **Add references** – include official documentation and learning resources
5. **Create exercises** – add practical assignments to reinforce learning

## Output structure requirements

### Document structure
- **Introduction and learning objectives** – what the student will learn and be able to do
- **Theoretical foundation** – main concepts and terminology
- **Practical examples** – step-by-step instructions with explanations
- **Knowledge checks** – questions and exercises
- **Additional resources** – links to documentation, videos, courses

### Writing style
- **Accessible language** – avoid unnecessary jargon; explain complex terms
- **Step-by-step** – break complex processes into simple steps
- **Descriptive visualization** – describe diagrams, architectures, and tables in text
- **Practical focus** – emphasize real-world usage scenarios

### Mandatory elements
- **Glossary of terms** – explanations of key concepts
- **Frequently asked questions** – answers to typical beginner questions
- **Troubleshooting** – solutions to common problems
- **Best practices** – recommendations for safe and effective work

## Processing instructions

For each major section:
1. **Analyze** the existing material
2. **Identify** target knowledge and skills
3. **Structure** the information logically
4. **Add** explanations and practical examples
5. **Create** practical exercises
6. **Include** references to external resources

## Priorities
1. **Clarity** – the material must be understandable for beginners
2. **Practicality** – focus on real tasks and workflows
3. **Structure** – logical learning progression
4. **Interactivity** – exercises and knowledge checks

## Constraints
- Maintain technical accuracy
- Do not oversimplify to the point of losing important details
- Focus on practical application
- Use up-to-date best practices

Start by analyzing the provided material and designing the textbook structure. Each section should include theory, practice, and a way to check understanding.

**Language:** Use only the target language requested by the user.
```

## Validation Checklist

Before completing transformation:
- [ ] Learning objectives defined for each major section
- [ ] Technical terms explained when first introduced
- [ ] Concepts expanded with context and real-world scenarios
- [ ] Practical examples included for key concepts
- [ ] Knowledge checks added after major sections
- [ ] Practical exercises created with clear objectives
- [ ] Glossary of key terms included
- [ ] Additional resources and links added
- [ ] Troubleshooting section included
- [ ] Code blocks and commands preserved unchanged
- [ ] All links and references remain valid
- [ ] Document structure supports progressive learning
- [ ] Language is accessible for students
- [ ] Technical accuracy maintained
- [ ] Material is suitable for educational use

