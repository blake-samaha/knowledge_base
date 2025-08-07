# Cursor Rules Overview

Cursor rules are custom guidelines, prompts, and best practices stored in the
`.cursor/rules.md` file (or folder) within your project. They provide persistent
context to AI coding assistants like Cursor, helping generate more accurate,
project-specific code and documentation.

## What Are Cursor Rules?

- **Purpose**: Rules act as a "memory" for the AI, ensuring generated code
  follows your project's standards, patterns, and constraints.
- **Format**: Written in Markdown, rules can include code snippets, prompts,
  checklists, or guidelines.
- **Location**: Typically in `.cursor/rules.md`, but can be a folder with
  multiple .md files for organization (e.g., `rules/data_modeling.md`).
- **How AI Uses Them**: When you interact with Cursor, it automatically includes
  relevant rules in the context, influencing responses without you needing to
  repeat instructions.

## How to Use Cursor Rules Effectively

1. **Create Rules**:

   - Start with a single `rules.md` file.
   - For larger projects, organize into a `rules/` folder with themed files
     (e.g., `data_modeling.md`, `sdk_best_practices.md`).
   - Use clear sections with headings, examples, and rationale.

1. **Best Practices**:

   - **Be Specific**: Include code patterns, naming conventions, and error
     handling strategies.
   - **Keep Updated**: Review and refine rules after each major project
     milestone.
   - **Integrate with Workflows**: Reference rules in prompts, e.g., "Follow our
     SDK best practices rule."
   - **Test**: Generate code using rules and validate adherence.
   - **Share**: Version control the rules folder for team collaboration.

1. **Integration with AI Workflows**:

   - In prompts, explicitly reference rules: "Apply the data modeling
     hierarchies rule to this asset structure."
   - Use for consistency in CDF projects: Rules ensure all generated code
     follows Cognite standards.
   - Combine with advanced prompting: Use rules as "generated knowledge" in
     Chain of Thought prompts.

1. **Benefits**:

   - Reduces errors by enforcing standards.
   - Speeds up development with reusable patterns.
   - Improves AI accuracy by providing project-specific context.

## Example Rule Structure

````markdown
# Rule: Data Modeling Hierarchies

## Guidelines
- Use flat hierarchies for <1000 assets.
- Implement tree structures for larger sets.

## Example Code
```python
# Asset creation with parent
asset = Asset(parent_external_id="parent_id")
````

For more rules, see the [Best Practices](../cdf_project/advanced/ci_cd.md)
section.
