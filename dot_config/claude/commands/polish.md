# Polish Writing

Transform draft text into polished writing. Detects academic vs technical context automatically.

## Command Usage and Arguments

```
/polish <filepath> [section]
```

- `filepath`: Path to the file containing draft content to polish
- `section` (optional): Exact section to polish (only that section, not child sections)

Below are the arguments provided by the user:

<arguments usage="<filepath> [section]">
$ARGUMENTS
</arguments>

## Building the Context

### Project Context Detection

Determines writing style by analyzing project:

#### Academic Context Indicators

- Presence of `.tex`, `.bib`, `.cls` files
- Academic terminology and references
- Research paper structure (abstract, methodology, results, conclusion)
- Citation patterns and bibliography
- Mathematical notation and formulas
- Journal or conference paper formatting

#### Technical Documentation Context Indicators

- Presence of `README.md`, API documentation, technical specs
- Code examples and snippets
- Software terminology and jargon
- Installation/usage instructions
- Version information and changelogs
- Issue tracking and contribution guidelines

### Section Targeting

**When section is specified in the arguments, polish only the direct content:**

- Include: Text immediately under the specified heading
- Include: Lists, paragraphs, and content at that heading level
- **Exclude: Any deeper heading levels (child sections)**
- **Exclude: Content under subsections**

Stop polishing when encountering:

- Same or higher heading level (end of section)
- Deeper heading level (child section - skip entirely)

To ensure the correct section is targeted, find the section boundaries by creating and remembering the line-numbers of
the sections start and end.

## Instructions

1. **Analyze Project Context**: Examine project structure using the arguments
2. **Style Detection**: Read existing documents for tone, terminology, formatting
3. **Content Analysis**: Read target file/section for structure and key points
   - **Section Targeting**: If section specified, identify exact boundaries and polish ONLY that section's direct
     content
   - **Exclude Child Sections**: Do not polish any subsections (deeper heading levels)
4. **Transform Content**: Work through the content systematically
5. **Post-Processing**: Perform post processing steps

### Workflow

1. **Project Analysis**: Determine context
2. **Style Sampling**: Analyze existing documents
3. **Content Review**: Read current draft
4. **Transform**: Polish content systematically
5. **Review**: Check consistency and clarity

## Post-Processing Steps

1. Run the updated content through the `languagetool` library for grammar and style checks

   - Analyze its output for any remaining issues
   - Make final adjustments based on suggestions

   <languagetool-example>
   Bash(languagetool --language de-DE --encoding utf-8 <<<"$new_content")
   </languagetool-example>

## Style Guidelines

Avoid fluff and filler words from output. Remove unnecessary qualifiers, redundant phrases, and wordy constructions.
Prioritize conciseness over elaboration.

- **Clarity**: Ideas expressed directly
- **Consistency**: Uniform style and terminology
- **Completeness**: Key points developed
- **Conciseness**: No unnecessary words
- **Precision**: Accurate terminology

Create content that maintains author intent while maximizing information density.

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
