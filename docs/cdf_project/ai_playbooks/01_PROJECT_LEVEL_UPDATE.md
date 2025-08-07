# AI Playbook: 01 - Project Level Update

This playbook governs the initial scaffolding and subsequent updates of a
Cognite Data Fusion (CDF) project's foundational configuration. It uses the
filled-out `00_Solution_Design_Principles.md` as its primary input.

**Source of Truth:** `docs/cdf_project/solution_design/design_principles.md`\
**AI-Generated Output 1:**
`docs/cdf_project/solution_design/design_principles.json`\
**AI-Generated Output 2:** `cognite_toolkit_configs/` (project-level YAML)

______________________________________________________________________

## 1. Playbook Trigger

This playbook is triggered automatically when a pull request containing changes
to `design_principles.md` is merged into the main branch. It can also be
triggered manually for initial project generation.

______________________________________________________________________

## 2. Workflow Steps

### Step 2.1: Parse Design Principles

- **Action:** An AI agent reads and parses the contents of
  `design_principles.md`.
- **Details:** The agent extracts all key-value pairs, including project name,
  environments, data sets, security roles, and architectural standards.
- **Validation:**
  - The agent verifies that no `<REPLACE_ME>` placeholders are left in the
    source document.
  - It confirms that all security roles reference valid environment variables
    (e.g., `{{ admin_group_source_id }}`).
  - If validation fails, the playbook run stops and reports an error.

### Step 2.2: Generate Structured JSON

- **Action:** The AI agent converts the parsed data into a structured JSON file:
  `design_principles.json`.

- **Details:** This file serves as an intermediate, machine-readable
  representation of the project's configuration. It is used by downstream
  processes and can be easily consumed by helper scripts.

- **Example Snippet (`design_principles.json`):**

  ```json
  {
    "projectName": "Well Performance Monitoring",
    "moduleName": "well_performance_module",
    "environments": {
      "dev": {
        "admin_group_source_id": "abc-123-def-456",
        "user_group_source_id": "ghi-789-jkl-012"
      }
    },
    "dataSets": [
      {
        "externalId": "ds_source_system_raw_data",
        "name": "Source System - RAW Data"
      }
    ]
  }
  ```

### Step 2.3: Generate Toolkit YAML Files

- **Action:** A second AI agent uses the `design_principles.json` to generate
  the necessary Cognite Toolkit YAML files.
- **Details:** The agent creates or patches the following files under a
  designated toolkit configuration directory (e.g., `cognite_toolkit_configs/`):
  - `config.dev.yaml` / `config.prod.yaml`: For environment-specific variables.
  - `project.yaml`: For project-level settings.
  - `datasets.yaml`: To define all specified data sets.
  - `groups.yaml`: To configure security groups based on defined roles.
- **Idempotency:** The generation process is idempotent. Re-running the playbook
  with the same input will produce the exact same YAML output, preventing
  unintended changes.

______________________________________________________________________

## 3. Human-in-the-Loop: Approval Gate

- **Action:** The playbook generates a pull request containing the newly created
  or updated `design_principles.json` and Toolkit YAML files.
- **Details:** A project administrator or solution architect must review and
  approve this pull request. This serves as the critical "human-in-the-loop"
  step, ensuring that the AI's interpretation and generated configuration align
  with the user's intent.
- **Next Step:** Once the pull request is merged, the changes can be applied to
  a CDF environment using the standard `cognite-toolkit` CLI.

______________________________________________________________________

> **Note:** The underlying scripts that perform the AI agent actions are
> currently under development and are tracked as separate tasks in the project
> backlog. This document describes the target state and workflow.
