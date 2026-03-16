# Agent Skills for Project Management and Documentation

This directory contains Agent Skills based on lessons learned from project reorganization and technical documentation creation. These skills help AI agents safely reorganize projects, create comprehensive documentation, validate configurations, and handle errors gracefully.

## Project Management Skills

### 1. `doc-reorganize-project-structure`
Safely reorganize project structure while preserving all important information, dependencies, and links.

**Use when:**
- User wants to restructure files
- Organizing documentation
- Separating automation code from documentation
- Moving files to new directory structure

**Invoke:** `/doc-reorganize-project-structure` or let agent decide automatically

### 2. `qa-validate-and-fix-links`
Validate all file links in a project and automatically fix broken links.

**Use when:**
- After reorganizing project structure
- Files have been moved
- User reports broken links
- Before finalizing documentation changes

**Invoke:** `/qa-validate-and-fix-links` or let agent decide automatically

**Includes:**
- Script: `scripts/check-links.sh` - Automated link validation script

### 3. `doc-preserve-important-info`
Preserve all important information when refactoring files, especially README.md.

**Use when:**
- Refactoring README.md or other important documentation
- Updating file structure
- Reorganizing content
- Before making major changes to documentation

**Invoke:** `/doc-preserve-important-info` or let agent decide automatically

### 4. `doc-eliminate-duplication`
Identify and eliminate duplicate information in project documentation.

**Use when:**
- User mentions duplicate information
- Creating new documentation files
- After reorganizing project structure
- Consolidating documentation

**Invoke:** `/doc-eliminate-duplication` or let agent decide automatically

### 5. `ansible-role-cleanup`
Analyze and clean up Ansible roles by removing redundant files, empty directories, and unused components.

**Use when:**
- User requests role cleanup or optimization
- Analyzing role structure for improvements
- Before refactoring or reorganizing roles
- Role has accumulated unused files over time
- User wants to simplify role structure

**Invoke:** `/ansible-role-cleanup` or let agent decide automatically

## Technical Documentation Skills

### 6. `doc-technical-documentation-structure`
Create modular structure for technical documentation by splitting large documents into logical modules.

**Use when:**
- Documentation files are too large
- Need to organize by topic or audience
- Creating new technical documentation
- User requests better documentation organization

**Invoke:** `/doc-technical-documentation-structure` or let agent decide automatically

### 7. `doc-documentation-versioning`
Add version tracking, compatibility matrices, and changelog to technical documentation.

**Use when:**
- Documentation needs version tracking
- Creating compatibility information
- Need changelog or release notes
- Tracking changes across versions

**Invoke:** `/doc-documentation-versioning` or let agent decide automatically

### 8. `qa-validation-script-generator`
Generate bash scripts for validating system configurations and checking component health.

**Use when:**
- User needs automated validation
- Creating health check scripts
- Setting up diagnostic tools
- Need configuration verification

**Invoke:** `/qa-validation-script-generator` or let agent decide automatically

### 9. `doc-plantuml-diagram-generator`
Generate PlantUML diagrams for visualizing architecture, processes, and system interactions.

**Use when:**
- User requests diagrams or visualizations
- Need to explain architecture
- Creating process flows
- Documentation needs visual aids

**Invoke:** `/doc-plantuml-diagram-generator` or let agent decide automatically

### 10. `doc-i18n-glossary-generator`
Generate comprehensive glossaries from technical documentation with organized term definitions.

**Use when:**
- Documentation has many technical terms
- User requests glossary
- Need centralized term reference
- Improving documentation accessibility

**Invoke:** `/doc-i18n-glossary-generator` or let agent decide automatically

### 11. `qa-file-size-management`
Manage file sizes during documentation generation to avoid token limits and ensure efficient processing.

**Use when:**
- Files exceed token limits
- Need to split large files
- Documentation files too large to process
- Optimizing file organization

**Invoke:** `/qa-file-size-management` or let agent decide automatically

### 12. `qa-error-handling-generation`
Handle errors gracefully during documentation generation, including token limits and generation failures.

**Use when:**
- Documentation generation fails
- Token limit errors occur
- Generation process errors
- Need robust error recovery

**Invoke:** `/qa-error-handling-generation` or let agent decide automatically

### 13. `enhance-technical-markdown`
Transform technical Markdown files into expanded, more readable versions with higher readability index while preserving technical accuracy.

**Use when:**
- User wants to improve readability of technical documentation
- Need to expand brief technical descriptions into detailed explanations
- User requests to enrich technical content with context
- Documentation is too concise and needs more detail
- User mentions "improve readability", "expand description", or "enrich content"
- Technical documentation needs better explanations for non-experts

**Invoke:** `/enhance-technical-markdown` or let agent decide automatically

## Localization Skills

### 14. `doc-i18n-translate-technical-documentation`
Translate technical documentation (Markdown, README, guides) while preserving code integrity, commands, and configuration syntax.

**Use when:**
- User requests translation of technical documentation
- Translating README files, deployment guides, or API documentation
- Localizing project documentation (e.g., English to Russian)
- User mentions "translate", "localize", or "convert to [language]"

**Invoke:** `/doc-i18n-translate-technical-documentation` or let agent decide automatically

**Includes:**
- Glossary: `resources/glossary.yml` - Standard terminology translations
- Rules: `resources/translation-rules.md` - Translation guidelines

### 15. `doc-i18n-create-terminology-glossary`
Create and maintain a terminology glossary for consistent translations across project documentation.

**Use when:**
- Starting translation work on a project
- Finding terminology inconsistencies in translations
- User requests a glossary or term reference
- Need to standardize technical term translations
- Working with multiple documents that need consistent terminology

**Invoke:** `/doc-i18n-create-terminology-glossary` or let agent decide automatically

### 16. `doc-i18n-validate-translated-documentation`
Validate translated technical documentation to ensure code integrity, correct terminology, and proper Markdown syntax.

**Use when:**
- After completing translation work
- When user reports issues with translated documentation
- Before finalizing or committing translated files
- When checking documentation quality
- User mentions "validate", "check translation", or "verify documentation"

**Invoke:** `/doc-i18n-validate-translated-documentation` or let agent decide automatically

## Educational Content Skills

### 17. `edu-educational-question-generator`
Generate comprehensive educational questions from lecture materials (PPTX/PDF) with appropriate difficulty distribution and learning objective alignment.

**Use when:**
- Creating quiz/test materials from lecture content
- Generating practice questions for students
- Building assessment banks from course content
- User mentions "generate questions", "create quiz", "test questions", or "assessment"
- Need to create questions at different difficulty levels

**Invoke:** `/edu-educational-question-generator` or let agent decide automatically

**Features:**
- Difficulty distribution: 30% easy, 40% medium, 30% hard (customizable)
- Multiple question types: Multiple choice, short answer, essay, true/false, practical
- Bloom's taxonomy alignment
- Subject-specific customization (STEM, Business, Humanities)
- Learning objective mapping

### 18. `edu-educational-question-validator`
Systematically validate educational questions for quality, fairness, and pedagogical effectiveness using multi-dimensional validation framework.

**Use when:**
- Before deploying questions to students
- Reviewing auto-generated question banks
- Ensuring assessment reliability and quality
- Quality assurance of test materials
- User mentions "validate questions", "test questions", "quality check", or "review questions"

**Invoke:** `/edu-educational-question-validator` or let agent decide automatically

**Validation Dimensions:**
- Content validation (accuracy, curriculum coverage, learning objective alignment)
- Construct validation (cognitive load, difficulty calibration, bias detection)
- Technical validation (structure, answer quality, time estimation)
- Psychometric validation (discrimination, reliability)
- Practical validation (administration feasibility, student experience)

### 19. `doc-adapt-technical-notes-to-textbook-en` / `doc-adapt-technical-notes-to-textbook-ru`
Transform technical notes and brief documentation into comprehensive educational textbooks for students with expanded explanations, practical examples, learning objectives, and assessment materials.

**Use when:**
- User wants to convert technical notes into educational materials
- Need to adapt technical documentation for students
- User requests to create textbook or learning guide from notes
- Technical material is too brief and needs educational expansion
- User mentions "textbook", "learning materials", "for students", "educational guide", or "teaching materials"
- Converting expert-level notes into beginner-friendly content
- Creating course materials from technical documentation

**Invoke:** `/doc-adapt-technical-notes-to-textbook-en` or `/doc-adapt-technical-notes-to-textbook-ru`, or let agent decide automatically

**Features:**
- Transforms brief technical notes into comprehensive educational content
- Adds learning objectives, explanations, and context
- Includes practical examples and step-by-step tutorials
- Creates knowledge checks and exercises
- Adds glossary, FAQ, and troubleshooting sections
- Preserves technical accuracy while improving accessibility
- Structures content for progressive learning

## Skills Management Skills

### 20. `meta-create-skills-from-dialogs`
Create Agent Skills from AI agent dialogs by extracting lessons learned and generating reusable skills without intermediate documents.

**Use when:**
- User wants to create Skills from dialogs with AI agents
- Need to preserve valuable experience from conversations
- Converting dialog knowledge into reusable skills
- User mentions "create skill from dialog", "save this conversation as skill", or "extract knowledge from chat"
- After productive dialogs that contain reusable patterns

**Invoke:** `/meta-create-skills-from-dialogs` or let agent decide automatically

**Features:**
- Extracts knowledge from dialogs (patterns, decisions, errors, examples)
- Designs Skills internally (no intermediate documents)
- Generates Skills following Agent Skills and Cursor standards
- Validates through Critic role with quality assessments
- Creates ready-to-use Skills without intermediate files

### 21. `meta-review-skills-for-duplicates`
Review all existing Agent Skills to identify duplicates, overlaps, and consolidation opportunities.

**Use when:**
- User requests review of skill collection
- Need to find duplicate or overlapping skills
- After creating new skills (check for conflicts)
- User mentions "duplicates", "overlaps", "review skills", or "consolidate skills"
- Before major skill collection reorganization
- When skill collection grows large

**Invoke:** `/meta-review-skills-for-duplicates` or let agent decide automatically

**Features:**
- Scans all skills in `.cursor/skills/` directory
- Analyzes functionality and metadata
- Identifies complete duplicates and partial overlaps
- Provides consolidation recommendations
- Generates structured review report

### 22. `meta-analyze-and-improve-skill`
Perform deep analysis of a specific Agent Skill and propose concrete improvements.

**Use when:**
- User wants to improve existing skill
- Need to check skill quality
- Optimizing skill for better performance
- Ensuring standards compliance
- User mentions "improve skill", "check skill quality", "optimize skill", or "review skill"
- After skill creation to validate quality
- When skill seems too verbose or unclear

**Invoke:** `/meta-analyze-and-improve-skill` or let agent decide automatically

**Features:**
- Comprehensive analysis (metadata, structure, content quality)
- Quality assessment with metrics (specificity, practicality, conciseness, reusability)
- Identifies issues (critical, important, improvements)
- Proposes concrete improvements with priorities
- Applies improvements if user approves

## Usage

### Automatic Invocation
Skills are automatically available to the agent. The agent will decide when to use them based on context.

### Manual Invocation
Type `/` in Agent chat and search for the skill name:
- `/doc-reorganize-project-structure`
- `/qa-validate-and-fix-links`
- `/doc-preserve-important-info`
- `/doc-eliminate-duplication`
- `/ansible-role-cleanup`
- `/doc-technical-documentation-structure`
- `/doc-documentation-versioning`
- `/qa-validation-script-generator`
- `/doc-plantuml-diagram-generator`
- `/doc-i18n-glossary-generator`
- `/qa-file-size-management`
- `/qa-error-handling-generation`
- `/doc-enhance-technical-markdown-en`
- `/doc-enhance-technical-markdown-ru`
- `/doc-i18n-translate-technical-documentation`
- `/doc-i18n-create-terminology-glossary`
- `/doc-i18n-validate-translated-documentation`
- `/edu-educational-question-generator`
- `/edu-educational-question-validator`
- `/doc-adapt-technical-notes-to-textbook-en`
- `/doc-adapt-technical-notes-to-textbook-ru`
- `/meta-create-skills-from-dialogs`
- `/meta-review-skills-for-duplicates`
- `/meta-analyze-and-improve-skill`

## Skill Workflows

### Project Reorganization Workflow

For comprehensive project reorganization:

1. **First**: Use `doc-preserve-important-info` to save important information
2. **Then**: Use `doc-reorganize-project-structure` to reorganize files
3. **After**: Use `qa-validate-and-fix-links` to fix all links
4. **Finally**: Use `doc-eliminate-duplication` to remove duplicates

### Ansible Role Cleanup Workflow

For cleaning up Ansible roles:

1. **Analyze**: Use `ansible-role-cleanup` to identify redundant files
2. **Verify**: Check file usage before removal
3. **Remove**: Delete empty files and unused components
4. **Fix**: Correct code issues (comments, documentation)
5. **Validate**: Ensure role still works correctly

### Documentation Creation Workflow

For creating comprehensive technical documentation:

1. **Structure**: Use `doc-technical-documentation-structure` to organize content
2. **Size Management**: Use `qa-file-size-management` to prevent token limit issues
3. **Error Handling**: Use `qa-error-handling-generation` for robust generation
4. **Glossary**: Use `doc-i18n-glossary-generator` for term definitions
5. **Diagrams**: Use `doc-plantuml-diagram-generator` for visualizations
6. **Versioning**: Use `doc-documentation-versioning` for version tracking
7. **Validation**: Use `qa-validation-script-generator` for check scripts

### Documentation Localization Workflow

For translating technical documentation:

1. **Glossary**: Use `doc-i18n-create-terminology-glossary` to establish terminology standards
2. **Translate**: Use `doc-i18n-translate-technical-documentation` to translate content
3. **Validate**: Use `doc-i18n-validate-translated-documentation` to verify quality
4. **Review**: Check code integrity, terminology consistency, and Markdown syntax

### Educational Content Creation Workflow

For creating and validating educational questions:

1. **Generate**: Use `edu-educational-question-generator` to create questions from lecture materials
2. **Validate**: Use `edu-educational-question-validator` to ensure quality and fairness
3. **Revise**: Update questions based on validation results
4. **Re-validate**: Verify revised questions meet standards
5. **Finalize**: Deploy validated question set

### Technical Notes to Textbook Workflow

For converting technical notes into educational textbooks:

1. **Analyze**: Use `doc-adapt-technical-notes-to-textbook-en` or `doc-adapt-technical-notes-to-textbook-ru` to analyze source material
2. **Transform**: Expand technical notes with explanations, examples, and context
3. **Enhance**: Add learning objectives, exercises, and assessment materials
4. **Validate**: Ensure technical accuracy and educational value
5. **Finalize**: Create comprehensive textbook with glossary and resources

### Skills Management Workflow

For managing and improving Agent Skills collection:

1. **Create**: Use `meta-create-skills-from-dialogs` to convert valuable dialog experience into reusable Skills
2. **Review**: Use `meta-review-skills-for-duplicates` to check for duplicates and overlaps in skill collection
3. **Improve**: Use `meta-analyze-and-improve-skill` to enhance existing Skills quality and standards compliance
4. **Consolidate**: Apply recommendations from review to optimize skill collection

## Based on Real Experience

### Project Management Skills
These skills were created based on actual lessons learned from reorganizing this Kubernetes with Ansible project:

- ✅ Preserved all important information from README.md
- ✅ Fixed 8 broken links after file reorganization
- ✅ Eliminated duplicate files (MIGRATION_GUIDE.md, PROJECT_STRUCTURE.md)
- ✅ Created clear separation between automation and documentation
- ✅ Cleaned up `kubernetes_worker` role: removed 6 redundant files, 4 empty directories (71% reduction)
- ✅ Applied YAGNI principle: removed empty defaults, vars, handlers files
- ✅ Fixed code inconsistencies (incorrect comments, template files)

### Documentation Skills
These skills were created based on lessons learned from creating comprehensive Kubernetes documentation:

- ✅ Successfully split large documentation into modular structure
- ✅ Created versioning system with compatibility matrices
- ✅ Generated validation scripts for cluster health checks
- ✅ Created PlantUML diagrams for architecture visualization
- ✅ Built comprehensive glossary with 100+ terms
- ✅ Handled token limit errors gracefully with file splitting
- ✅ Implemented error recovery strategies for generation failures
- ✅ Enhanced technical Markdown readability by expanding brief descriptions with context, real-world scenarios, and practical explanations

### Localization Skills
These skills were created based on lessons learned from translating technical documentation:

- ✅ Successfully translated DEPLOYMENT_GUIDE.md (395 lines) preserving all code
- ✅ Created terminology glossary for consistent translations
- ✅ Established translation rules preserving code integrity
- ✅ Validated translations ensuring commands remain executable
- ✅ Maintained Markdown structure and link functionality
- ✅ Preserved all technical identifiers and file paths

### Educational Content Skills
These skills were created based on lessons learned from developing educational question generation and validation systems:

- ✅ Created comprehensive question generation framework with difficulty distribution
- ✅ Developed multi-dimensional validation system (content, construct, technical, psychometric, practical)
- ✅ Established systematic validation process similar to unit testing in software development
- ✅ Integrated Bloom's taxonomy alignment for cognitive level assessment
- ✅ Implemented bias detection and fairness validation
- ✅ Created reusable prompt templates for LLM-based generation and validation
- ✅ Established quality assurance checklist for educational content
- ✅ Developed transformation framework for converting technical notes into educational textbooks
- ✅ Created pattern for expanding brief technical descriptions with educational context
- ✅ Integrated learning objectives, exercises, and assessment materials into technical content

### Skills Management Skills
These skills were created based on lessons learned from managing Agent Skills collection and converting dialog experience into reusable knowledge:

- ✅ Developed systematic process for extracting knowledge from AI agent dialogs
- ✅ Created validation framework through Critic role for quality assurance
- ✅ Established process for creating Skills without intermediate documents
- ✅ Built duplicate detection and overlap analysis system for skill collection
- ✅ Created comprehensive skill analysis and improvement framework
- ✅ Integrated Agent Skills Standard (https://agentskills.io) and Cursor standards compliance
- ✅ Established quality metrics: specificity, practicality, conciseness, reusability

## Domain Prefix Convention

Skills in this directory follow a domain-based prefix convention in their `name` and directory:

- `doc-*` – documentation authoring, structure, and content enhancement
- `doc-i18n-*` – documentation internationalization (translation, terminology, bilingual glossaries)
- `edu-*` – educational content, exercises, questions, and assessment workflows
- `qa-*` – validation, quality checks, link checking, size/error handling, and health scripts
- `k8s-*` – Kubernetes and infrastructure design, monitoring, and optional feature integration
- `meta-*` – skills that manage or analyze the skills collection itself
- `ansible-*` – Ansible automation skills (use the `ansible-` prefix directly, without extra domain slug)

When adding a new skill, choose the appropriate prefix so that related skills stay grouped and easy to discover.

## References

- [Agent Skills Documentation](https://cursor.com/docs/context/skills)
- [Agent Skills Standard](https://agentskills.io)
