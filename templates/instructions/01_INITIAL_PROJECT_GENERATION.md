# AI Instructions: Initial Project Generation Checklist

This document is a stateful checklist for an AI Assistant to perform the **initial generation** of a complete CDF project.

## Instructions for the AI

- When the user gives you approval to start a step, you will edit this file to mark the previous step's checkbox as complete (`[x]`)
- Do not proceed to a step until the user explicitly approves it.

---

## ☐ **Step 1: Process the Foundation Specification**

- **User Action:** Populate `docs/00_Solution_Design_Principles.md`.
- **AI Action:**
    1. Read the input Markdown file.
    2. Validate the content. If any `<REPLACE_ME: ...>` placeholders are found, list them as gaps.
    3. **Create JSON:** Based on the populated template, generate a `docs/specifications/design_principles.json` file.
    4. **Summarize Gaps:** Create or update `docs/ASSUMPTIONS_AND_GAPS.md`. List any missing information (unfilled placeholders) or inconsistencies found.
- **AI Output:** `docs/specifications/design_principles.json` and `docs/ASSUMPTIONS_AND_GAPS.md`.

---

## ☐ **Step 2: Generate Conceptual Data Model**

- **User Action:** Populate `docs/01_Conceptual_Data_Model_Overview.md`.
- **AI Action:**
    1. Read the input Markdown file.
    2. **Create JSON:** Generate a `docs/specifications/conceptual_model.json` file.
    3. **Summarize Gaps:** Append any new assumptions or gaps to `docs/ASSUMPTIONS_AND_GAPS.md`.
- **AI Output:** `docs/specifications/conceptual_model.json`.

---

## ☐ **Step 3: Generate Object Specifications**

- **User Action:** Populate all `docs/[ConceptName]_Specification.md` files.
- **AI Action:**
    1. For each concept in `conceptual_model.json`, read the corresponding `docs/[ConceptName]_Specification.md` file.
    2. Validate the content. If any `<REPLACE_ME: ...>` placeholders are found, list them as gaps.
    3. Generate a `docs/specifications/[ConceptName]_spec.json` file.
    4. Append any new assumptions or gaps for the object to `docs/ASSUMPTIONS_AND_GAPS.md`.
- **AI Output:** A set of `*_spec.json` files in `docs/specifications/`.

---

## ☐ **Step 4: Consolidate into Master Specification**

- **AI Action:**
    1. Combine all `*_spec.json`, `design_principles.json`, and `conceptual_model.json` files from `docs/specifications/` into a single, master `docs/specifications/project_specification.json` file.
    2. Append a final review summary to `docs/ASSUMPTIONS_AND_GAPS.md`.
- **AI Output:** The final `docs/specifications/project_specification.json` file.

---

## ☐ **Step 5: Generate the Complete CDF Toolkit Configuration**

- **AI Action:**
    1. Parse the final `docs/specifications/project_specification.json` file.
    2. Generate the complete directory structure (`config` files, `modules` directory, etc.).
    3. Generate all resource YAML files (`*.dataset.yaml`, `*.group.yaml`, `*.container.yaml`, etc.) in their correct locations.
- **AI Output:** The complete, deployable set of YAML configuration files for the Cognite Toolkit.
