# Polish Writing

Transform draft text, bulletpoints, and rough content into polished, well-structured writing that matches the appropriate style for the project context. Automatically detects whether to use academic or technical documentation style.

## Command Usage

```
/polish <filepath> [section]
```

- `filepath`: Path to the file containing draft content to polish
- `section` (optional): Specific section within the file to focus on

## Project Context Detection

The command intelligently determines the appropriate writing style by analyzing the project:

### Academic Context Indicators

- Presence of `.tex`, `.bib`, `.cls` files
- Academic terminology and references
- Research paper structure (abstract, methodology, results, conclusion)
- Citation patterns and bibliography
- Mathematical notation and formulas
- Journal or conference paper formatting

### Technical Documentation Context Indicators

- Presence of `README.md`, API documentation, technical specs
- Code examples and snippets
- Software terminology and jargon
- Installation/usage instructions
- Version information and changelogs
- Issue tracking and contribution guidelines

## Instructions

1. **Analyze Project Context**: Examine the codebase/project structure to determine writing context using $ARGUMENTS
2. **Style Detection**: Read existing similar documents to understand:
   - Tone and voice (formal academic vs. practical technical)
   - Terminology patterns and vocabulary
   - Sentence structure preferences
   - Formatting conventions
   - Citation style (if academic)
3. **Content Analysis**: Read the target file/section to understand:
   - Current draft state and structure
   - Key points and information to preserve
   - Areas needing expansion or clarification
4. **Create Enhancement Plan**: Use TodoWrite to create actionable items for polishing
5. **Transform Content**: Work systematically through todos to enhance the writing

## Style Guidelines

### Academic Writing Style

- Formal, objective tone
- Complex sentence structures with clear logical flow
- Precise technical terminology
- Proper citation integration
- Abstract concepts clearly explained
- Methodical argumentation and evidence presentation
- Avoiding contractions and colloquialisms

### Technical Documentation Style

- Clear, concise, and practical tone
- Direct instructions and explanations
- User-focused language
- Code examples and practical applications
- Step-by-step procedures
- Troubleshooting and FAQ sections
- Accessible to target technical audience

## Workflow Process

1. **Project Analysis**: Determine academic vs. technical context
2. **Style Sampling**: Analyze existing documents for style patterns
3. **Content Review**: Understand current draft state and requirements
4. **Enhancement Planning**: Create comprehensive todo list for improvements
5. **Systematic Polishing**: Transform content section by section
6. **Consistency Check**: Ensure style consistency throughout
7. **Quality Review**: Final review for clarity and completeness

## Todo Item Categories

Each enhancement todo should specify:

- **Enhancement Type**: [Expansion/Restructure/Clarification/Style/Terminology]
- **Location**: Specific section, paragraph, or line reference
- **Current State**: What exists now (draft bullets, rough text, etc.)
- **Target State**: What the polished version should achieve
- **Style Context**: Academic or technical approach to apply
- **Priority**: [High/Medium/Low] based on impact on clarity and completeness

## Quality Standards

The polished output should demonstrate:

- **Clarity**: Complex ideas expressed clearly and logically
- **Consistency**: Uniform style, terminology, and formatting throughout
- **Completeness**: All key points fully developed and explained
- **Appropriateness**: Style matches project context and audience needs
- **Flow**: Smooth transitions and logical progression of ideas
- **Precision**: Accurate use of terminology and concepts

Focus on creating publication-ready or documentation-ready content that maintains the author's intent while significantly improving clarity, style, and professional presentation.
