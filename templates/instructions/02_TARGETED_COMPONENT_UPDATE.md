# AI Instructions: Targeted Component Update

This document provides a step-by-step guide for an AI Assistant to perform a **targeted update** to a single business object within an existing project.

---

## **Step 1: Update the Specification Files**

- **Input:** The user-modified `docs/[ObjectName]_Specification.md` file.
- **Instructions:**
    1. Read the updated Markdown specification file.
    2. **Regenerate JSON:** Based on the updated content, regenerate the corresponding `docs/specifications/[ObjectName]_spec.json` file.
    3. **Update Master Spec:** Load the master `docs/specifications/project_specification.json` file and replace the old object definition with the newly generated one.
    4. **Summarize Gaps:** Append any new assumptions or identified gaps for this change to `docs/ASSUMPTIONS_AND_GAPS.md`.
- **Output:** The updated `docs/specifications/[ObjectName]_spec.json` and `docs/specifications/project_specification.json` files.

---

## **Step 2: Regenerate Only Affected CDF Artifacts**

- **Input:** The updated `docs/specifications/project_specification.json` and the `externalId` of the business object that changed.
- **Process:**
    1. Parse the `project_specification.json` to find the changed business object.
    2. Regenerate only the specific YAML files related to that object. This includes:
        - `data_models/containers/{object_externalId}.container.yaml`
        - `data_models/views/{object_externalId}.view.yaml`
        - `transformations/{object_externalId}_transformation.transformation.yaml` (if applicable)
    3. Update the main `{datamodel_name}.datamodel.yaml` file to ensure its `views` list is still correct.
- **Output:** Overwrite only the specific YAML files that were affected by the change.
