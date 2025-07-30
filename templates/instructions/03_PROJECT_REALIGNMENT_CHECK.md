# AI Instructions: Project Re-alignment & Validation Check

This document provides instructions for an AI Assistant to perform a **full validation audit** of an existing project's specification layer. This is a read-only process designed to identify gaps and inconsistencies.

---

## **Step 1: Validate Foundation and Conceptual Model**

- **AI Action:**
    1. Read `docs/00_Solution_Design_Principles.md`.
    2. Read `docs/01_Conceptual_Data_Model_Overview.md`.
    3. Cross-reference the two files. For example, ensure that any `externalId`s referenced in the conceptual model are defined in the principles document.
    4. Create a new `docs/PROJECT_VALIDATION_REPORT.md` file.
    5. Log any unfilled `<REPLACE_ME: ...>` placeholders from both files into the report.
    6. Log any inconsistencies found between the two files into the report.

---

## **Step 2: Validate All Object Specifications**

- **AI Action:**
    1. Read the `docs/specifications/conceptual_model.json` to get a list of all business objects.
    2. For each object in the list, read its corresponding `docs/[ConceptName]_Specification.md` file.
    3. **Validate Completeness:** Check for any unfilled `<REPLACE_ME: ...>` placeholders within each specification file and log them to the report.
    4. **Validate Consistency:** Cross-reference each specification file against the `00_Solution_Design_Principles.md`. For example:
        - Does the specified `CDF Data Set` exist in the principles document?
        - Does the specified `Primary RAW Table` exist in the principles document?
        - Are all relationships pointing to `Target Type`s that exist as other business objects in the conceptual model?
    5. Log all findings (missing information, inconsistencies) to the `docs/PROJECT_VALIDATION_REPORT.md`.

---

## **Step 3: Final Report**

- **AI Action:**
    1. Add a summary to the top of the `docs/PROJECT_VALIDATION_REPORT.md`.
    2. If no issues were found, the summary should state that the project specification is complete and consistent.
    3. If issues were found, the summary should state that gaps and inconsistencies need to be resolved.
- **AI Output:** A detailed `docs/PROJECT_VALIDATION_REPORT.md` that serves as an actionable quality review for the Solution Architect.
