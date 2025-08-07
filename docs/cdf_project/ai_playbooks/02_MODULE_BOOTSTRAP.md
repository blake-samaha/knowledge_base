# AI Playbook: 02 - Module Bootstrap

This playbook automates the creation of a new, self-contained module within the
project. A module represents a logical grouping of related data objects, such as
"well performance" or "manufacturing operations."

**Trigger:** Manual execution by a Solution Architect or Data Engineer.\
**Input:** A new module name (e.g., `well_performance`).\
**Output:** A new module folder under `docs/cdf_project/modules/<module_name>/`
containing a `conceptual_model.md` and initial object specifications.

______________________________________________________________________

## 1. Playbook Prequisites

- The project-level configuration (`design_principles.json`) must exist.
- The conceptual model template (`01_CONCEPTUAL_MODEL_TEMPLATE.md`) must be
  available in the `templates` directory.

______________________________________________________________________

## 2. User-Provided Inputs

The user executing the playbook must provide the following information when
prompted:

- **New Module Name:** A unique, `snake_case` name for the new module (e.g.,
  `pump_analytics`).
- **Core Business Objects:** A list of the primary business objects to be
  included in this module (e.g., `Pump`, `Motor`, `SensorReadings`).
- **Initial Relationships:** A list of the initial relationships between these
  objects (e.g., `Motor` is part of `Pump`).

______________________________________________________________________

## 3. Workflow Steps

### Step 3.1: Create Module Directory Structure

- **Action:** An AI agent creates a new directory structure for the module.
- **Details:**
  - Creates `docs/cdf_project/modules/<new_module_name>/`.
  - Creates an `objects` subdirectory:
    `docs/cdf_project/modules/<new_module_name>/objects/`.

### Step 3.2: Create Module-Specific Conceptual Model

- **Action:** The agent clones the master template to create a local conceptual
  model for the new module.
- **Details:**
  - Copies `docs/cdf_framework/templates/01_CONCEPTUAL_MODEL_TEMPLATE.md` to
    `docs/cdf_project/modules/<new_module_name>/conceptual_model.md`.
  - The agent then pre-fills this new `conceptual_model.md` using the business
    objects and relationships provided by the user in Section 2. This gives the
    user a ready-made starting point for refinement.

### Step 3.3: Generate Initial Object Specifications

- **Action:** The AI agent generates a placeholder specification file for each
  business object identified by the user.
- **Details:**
  - For each object (e.g., `Pump`), the agent creates a new Markdown file:
    `docs/cdf_project/modules/<new_module_name>/objects/pump_specification.md`.
  - This file is generated from the `XX_Object_Specification_Template.md` and is
    pre-filled with the object's name. The user is then expected to complete the
    detailed specification (properties, metadata, etc.) in this file.

______________________________________________________________________

## 4. Next Steps & Human-in-the-Loop

- **User Action 1: Refine Conceptual Model:** The user opens the newly created
  `conceptual_model.md` and refines the relationships and object types as
  needed.
- **User Action 2: Detail Object Specifications:** The user opens each
  `_specification.md` file and fills in the specific details for every object,
  such as properties, data types, and descriptions.
- **Trigger Next Playbook:** Once the specifications are complete, the user can
  trigger the `03_OBJECT_LEVEL_UPDATE.md` playbook to generate the corresponding
  Toolkit YAML for the objects in this new module.

______________________________________________________________________

> **Note:** The underlying scripts that perform these AI agent actions are
> tracked as separate tasks in the project backlog. This document describes the
> target state and workflow.
