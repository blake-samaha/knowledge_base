# AI Playbook: 11 - Deprecation and Cleanup

This playbook provides a safe and structured process for deprecating and
removing resources (such as data models, views, datasets, or transformations)
from the CDF project. A disciplined cleanup strategy is essential for managing
costs, reducing complexity, and avoiding the accumulation of technical debt.

**Goal:** To ensure that the removal of resources is a deliberate, communicated,
and non-disruptive process.

______________________________________________________________________

## 1. The Four-Step Deprecation Process

Simply deleting a resource is dangerous. A proper deprecation process should be
followed to prevent breaking downstream dependencies.

### Step 1: Mark for Deprecation (in Docs)

- **Action:** The first step happens in the knowledge base. The resource to be
  removed (e.g., a specific view in an object specification) is marked with a
  `deprecation_date`.

- **Example in `..._specification.md`:**

  ```markdown
  - **Property:**
    - **Name:** oldLegacyMetric
    - **Data Type:** float64
    - **Status:** DEPRECATED
    - **Deprecation Date:** 2024-12-31
    - **Deprecation Note:** "This metric is being replaced by `newAdvancedMetric`. Please update all downstream dependencies before the deprecation date."
  ```

- **Communication:** This change, once merged, serves as the official public
  notice to all users of the data model that the resource is scheduled for
  removal.

### Step 2: Analyze Impact

- **Action:** Before removing the resource, run an impact analysis to find all
  downstream dependencies.
- **Details:**
  - Use CDF's lineage capabilities to identify which assets, dashboards, or
    applications are querying the deprecated resource.
  - Search application code repositories for any references to the resource's
    external ID.
- **Tooling:** This can be a combination of using the CDF UI, the SDK, and code
  search tools. The goal is to produce a "dependency report."

### Step 3: Remove the Resource (in Docs)

- **Action:** After the `deprecation_date` has passed and all downstream
  dependencies have been migrated, the resource is removed from the Markdown
  specification file.
- **Process:**
  1. Delete the corresponding property, relationship, or entire object file from
     the knowledge base.
  1. Create a pull request with this change.

### Step 4: Automated Cleanup via YAML Sync

- **Action:** The `05_TOOLKIT_YAML_SYNC.md` playbook handles the final cleanup
  automatically.
- **Process:**
  1. When the pull request from Step 3 is merged, it triggers the YAML Sync
     playbook.
  1. The sync agent will compare the new state of the knowledge base (where the
     resource is missing) with the current state of the Toolkit YAML.
  1. It will detect that the resource has been removed and will automatically
     **delete** the corresponding YAML file or block.
  1. This change is then promoted through the environments just like any other
     change, ensuring the resource is cleanly removed from CDF.

______________________________________________________________________

## 2. Deleting a Full Module or Project

The same principles apply when retiring an entire module or project, but with
additional safety checks.

- **Action:** Before deleting the entire module folder from
  `docs/cdf_project/modules/`, a final, comprehensive impact analysis must be
  performed.
- **Checklist:**
  - [ ] Have all downstream consumers been notified and migrated?
  - [ ] Have the associated data ingestion pipelines been turned off?
  - [ ] Has the data been archived if required for compliance?
  - [ ] Has a final cost savings report been generated?
- **Execution:** Once the checklist is complete and approved, deleting the
  module's folder from the knowledge base and running the YAML sync will trigger
  a cascading delete of all its associated resources in CDF.

______________________________________________________________________

> **Note:** This playbook emphasizes that deletion is not a single action but a
> communicated, multi-step process. The "docs-as-code" framework is what makes
> this process safe and auditable, as the removal of any resource leaves a clear
> trail in the Git history.
