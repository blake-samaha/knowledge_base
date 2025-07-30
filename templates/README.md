# Data Modeling & CDF Project Generation Framework

This directory contains a set of templates that form a comprehensive, modular framework for designing, documenting, and generating complete Cognite Data Fusion (CDF) projects.

The primary principle is that **these Markdown documents are a human-friendly interface used to generate a single, machine-readable `project_specification.json` file.** This final JSON file is the definitive source of truth from which all CDF Toolkit artifacts are generated and maintained.

This framework is designed to be used by an AI assistant to automate the entire workflow. The specific, step-by-step instructions for the AI are located in the `docs/instructions/` directory.

---

## The Core Concept: Human-Led, AI-Accelerated

The central principle of this framework is that **the version-controlled Markdown (`.md`) files in the `docs/` directory are the single source of truth.**

- **You, the Solution Architect, lead the design process** by creating and editing these human-readable documents based on your expertise.
- **The AI's role is to act as your accelerator.** It validates your specifications, generates the corresponding machine-readable JSON files, creates the final deployable toolkit configuration, and highlights any information that is missing or inconsistent.

---

## The Developer Workflow: From Zero to Deployed Project

### Step 1: Project Initialization

1. **Create and Clone a New Git Repo:**

```bash
# Go to your Git provider (GitHub, Azure DevOps, etc.) and create a new, empty repository.
# Clone it to your local machine.
git clone <your-new-repository-url>
cd <your-new-repository-name>
```

2. **Create the Documentation Structure:**

Create a `docs` directory in the root of your project. This will be the home for all source-of-truth documentation.

```bash
mkdir docs
cd docs
```

Copy the contents of the `templates` directory (this repository) into your new `docs` directory.

3. **Initialize for the Cognite Toolkit:**

Go back to the root of your project and initialize it for the toolkit.

```bash
cd ..
# It's recommended to use a virtual environment
python3 -m venv .venv

# Install the toolkit
pip install cognite-toolkit

# Initialize the repo for use with the toolkit. This creates a .gitignore.
cdf repo init
```

> **IMPORTANT:** Do NOT run `cdf modules init`. This command creates default modules that will conflict with the AI generation process.

### Step 2: The AI-Driven Design Loop

Your role is to create and populate the Markdown specification files in the `docs/` directory. The AI will then read these files to generate the necessary artifacts.

> **Tip: Use the AI as a "Smart Scribe"**
> If you prefer to outline your project's concepts in your own format (like a separate document or a simple text file), you don't have to manually transcribe everything into the official templates. Instead, create your own conceptual document and then instruct the AI to read it and populate the `00_...`, `01_...`, and `XX_...` templates for you. This lets you focus on the high-level design while the AI handles the detailed formatting.

1. **Create the Foundation Specification:**
    - **Your Action:** Open `docs/00_Solution_Design_Principles.md` and fill it out to the best of your ability. This is the foundational document for your entire project.
    - **AI Action:** Instruct the AI to perform **Step 1** from `docs/instructions/01_INITIAL_PROJECT_GENERATION.md`. The AI will read your Markdown file, generate the corresponding `design_principles.json`, and create an `ASSUMPTIONS_AND_GAPS.md` file listing any information it found to be missing or inconsistent.
    - **Iterate:** Review the gaps file, update the Markdown, and have the AI run the step again until the foundation is complete and validated.

2. **Define the Conceptual Model and Object Specifications:**
    - **Your Action:** Following the same pattern, populate the `docs/01_Conceptual_Data_Model_Overview.md` and the individual `docs/[ObjectName]_Specification.md` files.
    - **AI Action:** Instruct the AI to perform the subsequent steps from the initial generation instructions. It will process your Markdown files to create the conceptual and object-level JSON files, continuously updating the `ASSUMPTIONS_AND_GAPS.md` file.
    - **Iterate:** Continue this process until you have a complete and reviewed `project_specification.json` in the `docs/specifications/` directory.

3. **Generate the Toolkit Configuration:**
    - **Your Action:** Once the master `project_specification.json` is complete and approved, instruct the AI to perform the final generation step from the instructions.
    - **Goal:** To generate the complete, deployable directory structure for the Cognite Toolkit based on your specifications.

#### A Note on Collaboration and `project_specification.json`

The master `project_specification.json` file **should be committed to version control.** It serves as the final, unambiguous blueprint for the generation of all YAML artifacts.

When working in a team, you may encounter merge conflicts in this file. Do not resolve them manually. The correct, safe way to resolve them is to:

1. Merge the latest changes from your main branch into your feature branch.
2. Re-run the consolidation step (the final step in `instructions/01_INITIAL_PROJECT_GENERATION.md` or step 2 in `instructions/02_TARGETED_COMPONENT_UPDATE.md`). This will programmatically regenerate the `project_specification.json` from the now-merged source Markdown files, safely resolving the conflict.

### Step 3: Deployment

With the configuration generated, you can now validate and deploy your project to CDF. This is a three-step process to ensure safety and quality.

1. **Build & Validate:** This command compiles the local configuration, validates the syntax of all YAML files, and resolves all Jinja-style variables. This is your first line of defense against errors.

```bash
# For pip/venv users
cdf build

# For poetry users
poetry run cdf build
```

2. **Review the Dry-Run:** This command simulates the deployment against the target CDF project without making any actual changes. Its output shows exactly which resources will be created, updated, or deleted. This is your final, critical sanity check.

```bash
# For pip/venv users
cdf deploy --dry-run -e dev

# For poetry users
poetry run cdf deploy --dry-run -e dev
```

3. **Deploy for Real:** Only after the build and dry-run have been reviewed and approved should you execute the final deployment.

```bash
# For pip/venv users
cdf deploy -e dev

# For poetry users
poetry run cdf deploy -e dev
```

### Step 4: Iteration and Maintenance (The Golden Rule)

To make changes or add new features, always follow this rule:

> **The Golden Rule: NEVER manually edit the generated YAML files.**

This is the core principle of Infrastructure as Code. The Markdown templates are your single source of truth. By only editing the source, you ensure that your documentation and your deployed configuration can never drift apart. This guarantees a repeatable, auditable, and maintainable process. Manual changes to the YAML files will be overwritten and lost the next time the generation task is run, leading to confusion and errors.

#### Making Targeted Changes on Large Projects

For large projects, making a small change does not require re-running the entire initial generation. Instead, use the targeted update workflow.

- **Your Action:** Instruct the AI to follow the workflow in `docs/instructions/02_TARGETED_COMPONENT_UPDATE.md`. This will guide you through an efficient process:
    1. Update the relevant Markdown file in the `docs/` directory.
    2. Instruct the AI to regenerate the corresponding JSON and the final toolkit artifacts.
- **Commit and Deploy:** Commit all changed files to Git, then deploy.

#### Auditing the Entire Project Specification

Before starting a major new development, or when onboarding a new team member, it is useful to perform a full validation audit of your project's specification layer.

- **Your Action:** Instruct the AI to follow the workflow in `docs/instructions/03_PROJECT_REALIGNMENT_CHECK.md`.
- **AI Output:** The AI will perform a read-only analysis of all your Markdown specification files and generate a `docs/PROJECT_VALIDATION_REPORT.md` that lists any gaps, inconsistencies, or missing information it finds. This report serves as an actionable quality review.

This process ensures your documentation and your deployed CDF project never drift apart.

---

## Expected Output Structure

The final output of this framework is a complete Cognite Toolkit project structure, generated from the `project_specification.json`.

```txt
{project_name}/
├── docs/
│   ├── instructions/
│   │   ├── 01_INITIAL_PROJECT_GENERATION.md
│   │   └── 02_TARGETED_COMPONENT_UPDATE.md
│   ├── specifications/
│   │   ├── design_principles.json
│   │   ├── conceptual_model.json
│   │   ├── *.spec.json
│   │   └── project_specification.json
│   ├── 00_Solution_Design_Principles.md
│   ├── 01_Conceptual_Data_Model_Overview.md
│   ├── *.Specification.md
│   └── ASSUMPTIONS_AND_GAPS.md
├── modules/
│   └── {module_name}/
│       ├── ... (generated YAML files)
├── config.dev.yaml
└── config.prod.yaml
```
