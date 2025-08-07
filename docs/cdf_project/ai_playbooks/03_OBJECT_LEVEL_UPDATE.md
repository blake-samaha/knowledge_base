# AI Playbook: 03 - Object Level Update

This playbook governs the regeneration of configuration artifacts for a single
business object when its specification changes. It ensures that any modification
to an object's design is accurately and automatically reflected in the
deployable Toolkit YAML.

**Trigger:** Automatic, upon a pull request merging changes to a specific
`_specification.md` file.\
**Source of Truth:**
`docs/cdf_project/modules/<module_name>/objects/<object_name>_specification.md`\
**AI-Generated Output:** Patches to the relevant module-level Toolkit YAML files
(e.g., `datamodels.yaml`, `views.yaml`, `containers.yaml`).

______________________________________________________________________

## 1. Playbook Trigger and Scope

- **Trigger:** This playbook is automatically initiated when a change is merged
  into a file matching the pattern `.../objects/*_specification.md`.
- **Scope:** The playbook's execution is tightly scoped to the single object
  whose specification was modified. It does not affect other objects.

______________________________________________________________________

## 2. Workflow Steps

### Step 2.1: Identify Changed Object

- **Action:** An AI agent identifies the specific object specification file that
  was changed.
- **Details:** The agent extracts the module name and object name from the file
  path (e.g., from `.../well_performance/objects/pump_specification.md`, it
  identifies module `well_performance` and object `pump`).

### Step 2.2: Parse Object Specification

- **Action:** The agent reads and parses the updated `_specification.md` file.
- **Details:** It extracts all defined properties, data types, relationships,
  indexes, and metadata for the object.
- **Validation:** The agent performs checks to ensure the specification is valid
  before proceeding. For example, it might check for valid data types or ensure
  that relationship definitions point to existing objects. If validation fails,
  the run is halted with an error.

### Step 2.3: Generate or Patch Toolkit YAML

- **Action:** The AI agent translates the parsed specification into the
  corresponding Cognite Toolkit YAML.
- **Details:** This is the core of the playbook. The agent determines which
  Toolkit YAML files need to be created or updated and generates the precise
  syntax. This may involve:
  - **Adding a new view** to a data model for a new object.
  - **Patching an existing container** to add a new property.
  - **Updating a view** to include a new property from its container.
  - **Modifying transformation SQL** if the object's logic requires it.
- **Idempotency & Precision:** The process is designed to be highly precise. It
  targets only the specific YAML blocks related to the changed object, leaving
  the rest of the file untouched. This idempotent approach prevents accidental
  changes to other resources.

______________________________________________________________________

## 3. Human-in-the-Loop: Approval Gate

- **Action:** As with other playbooks, a pull request is automatically created
  containing the proposed YAML changes.
- **Details:** The module owner or a lead engineer reviews the pull request to
  confirm that the generated YAML accurately reflects the intent of the
- specification change.
- **Next Step:** Merging this pull request makes the configuration change
  official. The updated YAML can then be deployed to CDF using the
  `06_ENVIRONMENT_PROMOTION.md` playbook.

______________________________________________________________________

> **Note:** The underlying scripts that perform these AI agent actions are
> tracked as separate tasks in the project backlog. This document describes the
> target state and workflow.
