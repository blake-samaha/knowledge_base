# AI Playbook: 04 - Project Sanity Check & Validation

This playbook outlines a comprehensive, read-only audit of the entire project
knowledge base. Its purpose is to detect inconsistencies, gaps, and violations
of best practices across all layers of the design, from the project-level
principles down to the individual object specifications.

**Trigger:** Automatic, upon any pull request that modifies files under
`docs/cdf_project/`, or can be run manually.\
**Input:** The entire `docs/cdf_project/` directory.\
**Output:** A detailed `PROJECT_VALIDATION_REPORT.md` file summarizing all
findings.

______________________________________________________________________

## 1. Playbook Goal

To ensure the integrity of the project's "docs-as-code" repository by validating
three key aspects:

1. **Completeness:** Are all required design elements filled out? (No pending
   `<REPLACE_ME>` placeholders).
1. **Consistency:** Do references between documents align? (e.g., Does an
   object's specified data set exist in the design principles?).
1. **Correctness:** Does the design adhere to defined project standards and
   naming conventions?

______________________________________________________________________

## 2. Workflow Steps

### Step 2.1: Foundation & Conceptual Model Validation

- **Action:** An AI agent cross-references the project-level design against the
  module-level conceptual models.
- **Details:**
  - It reads `design_principles.md`.
  - For each module, it reads `conceptual_model.md`.
  - **Checks Performed:**
    - Verifies that no `<REPLACE_ME>` placeholders exist in these core
      documents.
    - Ensures that data sets or other resources referenced in a conceptual model
      are formally defined in the main design principles.
- **Output:** Findings are logged to the `PROJECT_VALIDATION_REPORT.md`.

### Step 2.2: Object Specification Validation

- **Action:** The agent performs a deep validation of every object specification
  file.
- **Details:** For each `.../*_specification.md` file, the agent performs the
  following checks:
  - **Completeness:** Ensures all mandatory sections (summary, source system,
    etc.) are filled out.
  - **Cross-Reference a:** Validates that the specified `CDF Data Set` and
    `Primary RAW Table` exist in the `design_principles.md`.
  - **Cross-Reference b:** Confirms that all `Target Type`s in relationships
    point to other existing business objects within the project.
- **Output:** All gaps and inconsistencies for every object are logged to the
  validation report.

### Step 2.3: Final Report Generation

- **Action:** The agent compiles all findings into a final, consolidated report.
- **Details:** The `PROJECT_VALIDATION_REPORT.md` is structured with a clear
  executive summary at the top, indicating the overall validation status (e.g.,
  "✅ Passed" or "❌ Issues Found"). It then provides a detailed, actionable list
  of every issue found, grouped by document and severity.
- **CI Integration:** If run within a CI/CD pipeline, the playbook will fail the
  build (`exit 1`) if any critical errors are detected, preventing the merge of
  a pull request that would introduce inconsistencies into the knowledge base.

______________________________________________________________________

## 3. Example CI Workflow (GitHub Actions)

This playbook is designed to be a core part of the development lifecycle. Below
is an example of how to integrate it into a GitHub Actions workflow to validate
every pull request.

```yaml
name: Project Knowledge Base Validation

on:
  pull_request:
    paths:
      - 'docs/cdf_project/**.md'

jobs:
  validate-knowledge-base:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Install dependencies
        run: pip install -r requirements-docs.txt # Assuming reqs file exists

      - name: Run Sanity Check Playbook
        id: sanity_check
        run: |
          # This command would execute the AI agent script for this playbook
          python tools/run_sanity_check.py --output PROJECT_VALIDATION_REPORT.md

      - name: Upload Validation Report
        uses: actions/upload-artifact@v3
        if: always() # Upload report even if the check fails
        with:
          name: validation-report
          path: PROJECT_VALIDATION_REPORT.md

      - name: Fail job if critical errors found
        if: steps.sanity_check.outcome == 'failure'
        run: |
          echo "Sanity check failed. See the 'validation-report' artifact for details."
          exit 1
```

______________________________________________________________________

> **Note:** The underlying script (`tools/run_sanity_check.py`) that performs
> these AI agent actions is tracked as a separate task. This document describes
> the target workflow and its integration into the CI/CD process.
