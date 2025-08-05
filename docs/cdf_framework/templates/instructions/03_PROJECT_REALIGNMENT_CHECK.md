# AI Instructions: Project Re-alignment & Validation Check

This document provides instructions for an AI Assistant to perform a **full
validation audit** of an existing project's specification layer. This is a
read-only process designed to identify gaps and inconsistencies.

______________________________________________________________________

## **Step 1: Validate Foundation and Conceptual Model**

- **AI Action:**
  1. Read `docs/00_Solution_Design_Principles.md`.
  1. Read `docs/01_Conceptual_Data_Model_Overview.md`.
  1. Cross-reference the two files. For example, ensure that any `externalId`s
     referenced in the conceptual model are defined in the principles document.
  1. Create a new `docs/PROJECT_VALIDATION_REPORT.md` file.
  1. Log any unfilled `<REPLACE_ME: ...>` placeholders from both files into the
     report.
  1. Log any inconsistencies found between the two files into the report.

**Example CLI Commands:**

```bash
# Validate foundation specification
python tools/spec_validator.py docs/00_Solution_Design_Principles.md --output docs/PROJECT_VALIDATION_REPORT.md

# Validate conceptual model
python tools/spec_validator.py docs/01_Conceptual_Data_Model_Overview.md --append-to docs/PROJECT_VALIDATION_REPORT.md

# Cross-reference foundation and conceptual model
python tools/cross_reference_validator.py docs/00_Solution_Design_Principles.md docs/01_Conceptual_Data_Model_Overview.md --append-to docs/PROJECT_VALIDATION_REPORT.md

# Check for placeholder gaps
python tools/placeholder_checker.py docs/00_Solution_Design_Principles.md docs/01_Conceptual_Data_Model_Overview.md --append-to docs/PROJECT_VALIDATION_REPORT.md
```

**Sample Validation Report Output (`PROJECT_VALIDATION_REPORT.md`):**

```markdown
# Project Validation Report

**Generated:** 2024-01-15T10:30:00Z
**Project:** Well Performance Monitoring
**Validation Status:** ❌ Issues Found

## Foundation Specification Validation

### ✅ Valid Elements
- Project name and module name are defined
- Environment configurations are complete
- Data space external ID is specified
- Security roles are properly defined

### ❌ Issues Found
- **Missing Business Goal:** `<REPLACE_ME: A one-sentence summary of the primary business objective.>`
- **Missing Primary Use Cases:** All use cases are placeholders
- **Missing Key Stakeholders:** All stakeholders are placeholders

## Conceptual Model Validation

### ✅ Valid Elements
- Core business objects are defined
- Object types are specified
- Relationships are documented

### ❌ Issues Found
- **Missing Object Descriptions:** All object descriptions are placeholders
- **Inconsistent External IDs:** Some objects reference external IDs not defined in foundation

## Cross-Reference Validation

### ❌ Inconsistencies Found
- **Dataset Reference:** Object "Well" references dataset "ds_scada_raw_data" which is not defined in foundation
- **Source System Reference:** Object "Work Order" references source system "SAP S/4HANA" which is not defined in foundation

## Summary
- **Total Issues:** 7
- **Critical Issues:** 3
- **Warnings:** 4
- **Recommendation:** Resolve all placeholder content and cross-reference inconsistencies before proceeding
```

______________________________________________________________________

## **Step 2: Validate All Object Specifications**

- **AI Action:**
  1. Read the `docs/specifications/conceptual_model.json` to get a list of all
     business objects.
  1. For each object in the list, read its corresponding
     `docs/[ConceptName]_Specification.md` file.
  1. **Validate Completeness:** Check for any unfilled `<REPLACE_ME: ...>`
     placeholders within each specification file and log them to the report.
  1. **Validate Consistency:** Cross-reference each specification file against
     the `00_Solution_Design_Principles.md`. For example:
     - Does the specified `CDF Data Set` exist in the principles document?
     - Does the specified `Primary RAW Table` exist in the principles document?
     - Are all relationships pointing to `Target Type`s that exist as other
       business objects in the conceptual model?
  1. Log all findings (missing information, inconsistencies) to the
     `docs/PROJECT_VALIDATION_REPORT.md`.

**Example CLI Commands:**

```bash
# Get list of all business objects from conceptual model
python tools/extract_objects.py docs/specifications/conceptual_model.json --output object_list.json

# Validate each object specification
python tools/object_validator.py docs/Well_Specification.md --conceptual-model docs/specifications/conceptual_model.json --principles docs/00_Solution_Design_Principles.md --append-to docs/PROJECT_VALIDATION_REPORT.md

python tools/object_validator.py docs/WorkOrder_Specification.md --conceptual-model docs/specifications/conceptual_model.json --principles docs/00_Solution_Design_Principles.md --append-to docs/PROJECT_VALIDATION_REPORT.md

python tools/object_validator.py docs/MaintenanceReport_Specification.md --conceptual-model docs/specifications/conceptual_model.json --principles docs/00_Solution_Design_Principles.md --append-to docs/PROJECT_VALIDATION_REPORT.md

python tools/object_validator.py docs/ProductionData_Specification.md --conceptual-model docs/specifications/conceptual_model.json --principles docs/00_Solution_Design_Principles.md --append-to docs/PROJECT_VALIDATION_REPORT.md

# Validate relationships across all objects
python tools/relationship_validator.py docs/specifications/ --conceptual-model docs/specifications/conceptual_model.json --append-to docs/PROJECT_VALIDATION_REPORT.md

# Check for data source consistency
python tools/datasource_validator.py docs/specifications/ --principles docs/00_Solution_Design_Principles.md --append-to docs/PROJECT_VALIDATION_REPORT.md
```

**Sample Extended Validation Report:**

```markdown
# Project Validation Report (Extended)

**Generated:** 2024-01-15T10:30:00Z
**Project:** Well Performance Monitoring
**Validation Status:** ❌ Issues Found

## Foundation Specification Validation
... (previous content) ...

## Object Specification Validation

### Well Object
#### ✅ Valid Elements
- Object name and external ID are defined
- Properties are well-structured
- Data types are appropriate

#### ❌ Issues Found
- **Missing Summary:** `<REPLACE_ME: A one-paragraph summary of what this business object represents.>`
- **Missing Source System:** `<REPLACE_ME: The name of the system providing the data, e.g., "SAP S/4HANA">`
- **Missing Dataset:** `<REPLACE_ME: The externalId of the dataSet this object belongs to>`
- **Missing RAW Table:** `<REPLACE_ME: The specific RAW table where the source data resides>`

### Work Order Object
#### ✅ Valid Elements
- Object name and external ID are defined
- Properties include required fields

#### ❌ Issues Found
- **Missing Summary:** Placeholder not filled
- **Invalid Dataset Reference:** References "ds_work_orders" which is not defined in foundation
- **Invalid Source System:** References "SAP S/4HANA" which is not defined in foundation

### Maintenance Report Object
#### ✅ Valid Elements
- Object name and external ID are defined

#### ❌ Issues Found
- **Missing Summary:** Placeholder not filled
- **Missing Properties:** No properties defined
- **Missing Relationships:** No relationships defined

### Production Data Object
#### ✅ Valid Elements
- Object name and external ID are defined

#### ❌ Issues Found
- **Missing Summary:** Placeholder not filled
- **Missing Properties:** No properties defined
- **Missing Time Series:** No time series defined

## Relationship Validation

### ❌ Issues Found
- **Circular Reference:** Work Order → Well → Work Order creates potential circular reference
- **Missing Target:** Maintenance Report references "work_order_events" but relationship is not defined in Work Order object
- **Invalid Relationship Type:** Production Data → Well relationship type is not specified

## Data Source Validation

### ❌ Issues Found
- **Undefined Dataset:** "ds_work_orders" referenced but not defined in foundation
- **Undefined RAW Table:** "sap_zpm_workorders" referenced but not defined in foundation
- **Undefined Source System:** "SAP S/4HANA" referenced but not defined in foundation

## Summary
- **Total Issues:** 15
- **Critical Issues:** 8
- **Warnings:** 7
- **Objects Validated:** 4
- **Objects with Issues:** 4
- **Recommendation:** Complete all placeholder content and resolve all cross-reference issues before proceeding with implementation
```

______________________________________________________________________

## **Step 3: Final Report**

- **AI Action:**
  1. Add a summary to the top of the `docs/PROJECT_VALIDATION_REPORT.md`.
  1. If no issues were found, the summary should state that the project
     specification is complete and consistent.
  1. If issues were found, the summary should state that gaps and
     inconsistencies need to be resolved.

**Example CLI Commands:**

```bash
# Generate final summary and recommendations
python tools/final_report_generator.py docs/PROJECT_VALIDATION_REPORT.md --output docs/PROJECT_VALIDATION_REPORT.md

# Create action items from validation findings
python tools/action_item_generator.py docs/PROJECT_VALIDATION_REPORT.md --output docs/ACTION_ITEMS.md

# Generate a quick-fix script for common issues
python tools/quick_fix_generator.py docs/PROJECT_VALIDATION_REPORT.md --output fix_validation_issues.sh
```

**Sample Final Report Summary:**

```markdown
# Project Validation Report (Final)

**Generated:** 2024-01-15T10:30:00Z
**Project:** Well Performance Monitoring
**Validation Status:** ❌ **CRITICAL ISSUES FOUND**

## Executive Summary

The project specification has **15 total issues** that must be resolved before proceeding with implementation:

- **7 Critical Issues:** Missing business goal, undefined datasets, invalid cross-references
- **8 Warnings:** Placeholder content, missing properties, incomplete relationships

## Priority Action Items

### 🔴 Critical (Must Fix)
1. **Complete Foundation Specification**
   - Fill in business goal and primary use cases
   - Define all referenced datasets and source systems
   - Complete stakeholder definitions

2. **Fix Cross-Reference Issues**
   - Ensure all object references match foundation definitions
   - Validate all relationship targets exist
   - Confirm all external IDs are unique

3. **Complete Object Specifications**
   - Fill in all placeholder summaries
   - Define all required properties
   - Specify all relationships and time series

### 🟡 High Priority
1. **Validate Data Types**
   - Ensure all property data types are valid
   - Check transformation rules for syntax
   - Verify timestamp formats

2. **Review Naming Conventions**
   - Ensure all external IDs follow naming standards
   - Validate property names use camelCase
   - Check for naming conflicts

## Next Steps

1. **Immediate:** Address all critical issues in foundation and conceptual model
2. **Short-term:** Complete all object specifications with real data
3. **Medium-term:** Run validation again to confirm all issues resolved
4. **Long-term:** Implement automated validation in CI/CD pipeline

## Validation Tools Used

- `spec_validator.py` - Foundation and conceptual model validation
- `object_validator.py` - Individual object specification validation
- `relationship_validator.py` - Cross-object relationship validation
- `datasource_validator.py` - Data source consistency validation
- `placeholder_checker.py` - Placeholder content detection

**Recommendation:** **DO NOT PROCEED** with implementation until all critical issues are resolved.
```

- **AI Output:** A detailed `docs/PROJECT_VALIDATION_REPORT.md` that serves as
  an actionable quality review for the Solution Architect.

______________________________________________________________________

## **Step 4: Continuous Integration Hook**

Embed the validation steps in CI so every PR triggers a realignment check.

```yaml
name: Project Realignment Validation

on:
  pull_request:
    paths:
      - "docs/**.md"
      - "docs/specifications/**.json"

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: 3.10
      - name: Install validation tools
        run: pip install -r requirements-docs.txt
      - name: Run realignment check
        run: |
          python tools/ci_realignment.py \
            --principles docs/00_Solution_Design_Principles.md \
            --conceptual docs/01_Conceptual_Data_Model_Overview.md \
            --spec-dir docs/specifications/ \
            --report docs/PROJECT_VALIDATION_REPORT.md
      - name: Upload report artifact
        uses: actions/upload-artifact@v3
        with:
          name: realignment_report
          path: docs/PROJECT_VALIDATION_REPORT.md
      - name: Annotate PR if issues
        if: failure()
        run: echo "Realignment check failed – see report for details." >> $GITHUB_STEP_SUMMARY
```

## 📊 Quality Metrics & Thresholds

| Metric | Threshold | CI Fail Condition |
|--------|-----------|-------------------| | Critical Issues | 0 |
`critical > 0` | | Total Placeholders | 0 | `placeholders > 0` | | Invalid
Relationships | 0 | any | | Undefined Datasets | 0 | any | | Naming Convention
Violations | \<5 | `violations >= 5` |

> The `ci_realignment.py` script exits with non-zero code if any threshold is
> exceeded.

## 🚀 Automated Remediation Script

The quick-fix generator can propose SQL, YAML, or Markdown patches.

```bash
bash fix_validation_issues.sh --apply-patches --commit-msg "Auto-fix placeholders & naming"
```

The script:

1. Fills obvious placeholders using heuristics (e.g., copy name into summary).
1. Renames external IDs to snake_case.
1. Inserts missing dataset stubs in design principles.

Manual review still required before merging.

______________________________________________________________________

> **Next Step**: Integrate the CI workflow into your repository and resolve any
> failing checks before deployment.
