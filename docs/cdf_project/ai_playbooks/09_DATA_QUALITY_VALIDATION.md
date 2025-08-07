# AI Playbook: 09 - Data Quality Validation

This playbook describes the process of transforming the data quality rules,
defined in the object specification documents, into a suite of automated tests.
It ensures that the data populating the CDF data model is continuously monitored
for accuracy, completeness, and integrity.

**Goal:** To establish an automated data quality framework where business rules,
defined in Markdown, are systematically converted into executable tests.

______________________________________________________________________

## 1. The Data Quality Lifecycle

The data quality lifecycle follows our core "docs-as-code" philosophy:

1. **Define in Markdown:** Business-level data quality rules are defined in a
   table within each object's `_specification.md` file.
1. **Translate to Tests:** An AI agent or helper script reads these rules and
   translates them into executable tests using a testing framework like dbt,
   pytest, or Great Expectations.
1. **Execute via CI/CD:** These tests are executed automatically as part of the
   CI/CD pipeline, typically after data has been transformed.
1. **Alert on Failures:** Any test failures trigger alerts, notifying the data
   stewards or operations team to investigate the issue.

______________________________________________________________________

## 2. Defining Rules in the Specification

Data quality rules are defined directly in the `.../*_specification.md` files.
This keeps the rules close to the data they are validating.

### Example Rule Definition Table (from `well_specification.md`)

| Rule ID | Description | Severity | Implementation Example | |---|---|---|---|
| **DQ-001** | `externalId` must be unique. | Critical | `dbt test unique` | |
**DQ-002** | `spudDate` cannot be in the future. | High |
`dbt test "where spudDate <= current_date"` | | **DQ-003** | `status` must be
one of `[OPEN, SHUT_IN]`. | Medium | `dbt test accepted_values` | | **DQ-004**|
`wellheadElevation` must be > -500. | Medium |
`dbt test "where wellheadElevation > -500"`|

______________________________________________________________________

## 3. Translating Rules to Tests

This is the core technical step of the playbook.

- **Action:** A dedicated script (`tools/generate_dq_tests.py`) is executed as
  part of the CI/CD pipeline.
- **Process:**
  1. The script recursively finds all `_specification.md` files in the project.
  1. For each file, it parses the "Data Quality & Validation Rules" table.
  1. It then maps each rule to a test template for the chosen testing framework
     (e.g., dbt).
  1. It generates the final test files (e.g., `schema.yml` for dbt) and places
     them in the appropriate directory for the testing tool.

### Example: dbt Test Generation

Given the rule table above, the `generate_dq_tests.py` script would produce a
`schema.yml` file like this:

```yaml
version: 2

models:
  - name: well_view # This would be the name of the view for the Well object
    columns:
      - name: externalId
        tests:
          - unique
          - not_null
      - name: spudDate
        tests:
          - dbt_utils.expression_is_true:
              expression: "spudDate <= current_date"
      - name: status
        tests:
          - accepted_values:
              values: ['OPEN', 'SHUT_IN']
      - name: wellheadElevation
        tests:
          - dbt_utils.expression_is_true:
              expression: "wellheadElevation > -500"
```

______________________________________________________________________

## 4. Execution and Alerting

- **Execution:** The data quality tests are run as a dedicated step in the main
  CI/CD pipeline, immediately after the `cognite-toolkit apply` step for
  transformations has completed.

- **Command Example (dbt):**

  ```bash
  dbt deps
  dbt build
  ```

- **Alerting:** If the `dbt build` command fails, it will exit with a non-zero
  code, failing the pipeline step. This failure should be configured to send an
  alert to the appropriate team, including a link to the pipeline logs which
  will contain the detailed test results.

______________________________________________________________________

> **Note:** This playbook promotes a powerful synergy between documentation and
> testing. By defining the rules in the same place as the object's design, it
> ensures that the data quality requirements are never out of sync with the
> implementation.
