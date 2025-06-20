# Polish Writing

Transform draft text into polished writing. Detects academic vs technical context automatically.

## Command Usage

```
/polish <filepath> [section]
```

- `filepath`: Path to the file containing draft content to polish
- `section` (optional): Specific section within the file to focus on

## Project Context Detection

Determines writing style by analyzing project:

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

1. **Analyze Project Context**: Examine project structure using $ARGUMENTS
2. **Style Detection**: Read existing documents for tone, terminology, formatting
3. **Content Analysis**: Read target file/section for structure and key points
4. **Create Enhancement Plan**: Use TodoWrite for actionable polishing items
5. **Transform Content**: Work through todos systematically

**CRITICAL: Eliminate fluff and filler words from output. Remove unnecessary qualifiers, redundant phrases, and wordy constructions. Prioritize conciseness over elaboration.**

## Style Guidelines

### Academic Writing Style

- Formal, objective tone
- Precise terminology
- Proper citations
- Clear argumentation
- No contractions
- **Concise sentences - eliminate unnecessary words**

### Technical Documentation Style

- Clear, practical tone
- Direct instructions
- User-focused language
- Code examples
- Step-by-step procedures
- **Minimal fluff - every word serves a purpose**

## Workflow Process

1. **Project Analysis**: Determine context
2. **Style Sampling**: Analyze existing documents
3. **Content Review**: Read current draft
4. **Enhancement Planning**: Create todo list
5. **Transform**: Polish content systematically
6. **Review**: Check consistency and clarity

## Todo Item Categories

Each todo should specify:

- **Type**: [Expansion/Restructure/Clarification/Style/Terminology]
- **Location**: Section/paragraph/line reference
- **Current**: What exists now
- **Target**: What to achieve
- **Context**: Academic or technical
- **Priority**: [High/Medium/Low]

## Quality Standards

## Conciseness Priority

**Eliminate these filler words/phrases:**

- "very", "quite", "rather", "somewhat"
- "it is important to note that", "it should be mentioned"
- "in order to" (use "to")
- "due to the fact that" (use "because")
- "at this point in time" (use "now")
- "for the purpose of" (use "for" or "to")

## Output Requirements

- **Clarity**: Ideas expressed directly
- **Consistency**: Uniform style and terminology
- **Completeness**: Key points developed
- **Conciseness**: No unnecessary words
- **Precision**: Accurate terminology

Create content that maintains author intent while maximizing information density.
