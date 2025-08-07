# AI Playbook: 05 - Toolkit YAML Sync

This playbook is the core translation engine of the "docs-as-code" framework. It
is responsible for reading the entire validated knowledge base (all Markdown
specifications) and generating the complete, deployable Cognite Toolkit YAML
configuration.

**Trigger:** Manual execution, or automatically from a CI/CD pipeline after a
successful `04_SANITY_CHECK`.\
**Input:** The entire validated `docs/cdf_project/` directory.\
**Output 1:** A full set of Toolkit YAML files under
`cognite_toolkit_configs/`.\
**Output 2:** A `SYNC_REPORT.md` detailing all files created, patched, or
deleted.

______________________________________________________________________

## 1. Playbook Goal

To create a complete, accurate, and idempotent representation of the project's
design in the form of Cognite Toolkit YAML files. This process ensures that the
YAML configuration is always in sync with the approved knowledge base.

______________________________________________________________________

## 2. Workflow Steps

### Step 2.1: Load the Entire Knowledge Base

- **Action:** An AI agent reads and parses all specification documents from the
  `docs/cdf_project/` directory.
- **Details:** This includes:
  - `design_principles.md` (for project-level settings, datasets, etc.)
  - All module-level `conceptual_model.md` files.
  - All object-level `.../*_specification.md` files.
- **Prerequisite:** This playbook should only run *after* a successful
  `04_SANITY_CHECK` to ensure the source documents are consistent and complete.

### Step 2.2: Full YAML Generation

- **Action:** The AI agent performs a full generation of the Toolkit YAML
  configuration based on the loaded knowledge base.
- **Details:** The agent systematically translates the design into the correct
  YAML structure and files. This includes, but is not limited to:
  - `project.yaml` and `config.[env].yaml` from the design principles.
  - `datasets.yaml` and `groups.yaml` for security.
  - For each module, it creates a corresponding toolkit module folder.
  - For each object, it generates:
    - `datamodels.yaml`
    - `containers.yaml`
    - `views.yaml`
    - `transformations.yaml` (if applicable)
- **Idempotency:** The generation process is fully idempotent. Given the same
  input knowledge base, the agent will always produce the exact same set of YAML
  files.

### Step 2.3: Compare and Patch (Sync)

- **Action:** The agent compares the newly generated ("desired state") YAML with
  the existing YAML configuration in the `cognite_toolkit_configs/` directory
  ("current state").
- **Details:** Instead of overwriting everything, the agent performs a smart
  sync:
  - **Create:** New YAML files are created for new objects or resources.
  - **Patch:** Existing files are patched with any changes (e.g., a new property
    in a container). Only the relevant block is changed.
  - **Delete:** YAML files for objects that have been removed from the knowledge
    base are deleted.
- **Safety:** This prevents accidental data loss and makes the changes clear and
  auditable.

### Step 2.4: Generate Sync Report

- **Action:** The agent generates a detailed `SYNC_REPORT.md`.
- **Details:** The report provides a human-readable summary of the sync
  operation, listing:
  - All files that were created.
  - All files that were patched, with a diff of the changes.
  - All files that were deleted.
- **Audit Trail:** This report serves as a critical audit trail for all changes
  made to the deployable configuration.

______________________________________________________________________

## 3. Human-in-the-Loop: Pull Request for Review

- **Action:** The playbook concludes by creating a pull request containing all
  the YAML changes and the `SYNC_REPORT.md`.
- **Details:** This allows the project team to review the exact changes that
  will be deployed to CDF before they are merged. The sync report makes this
  review process efficient and transparent.
- **Next Step:** Once this pull request is approved and merged, the
  `06_ENVIRONMENT_PROMOTION.md` playbook can be used to apply these changes to a
  live CDF environment.

______________________________________________________________________

> **Note:** The underlying AI agent scripts that perform this complex
> translation and synchronization are the most sophisticated part of this
> framework. They are tracked as separate, significant development tasks in the
> project backlog.
