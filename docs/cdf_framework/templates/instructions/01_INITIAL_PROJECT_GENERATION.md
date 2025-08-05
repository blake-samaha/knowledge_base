# AI Instructions: Initial Project Generation Checklist

This document is a stateful checklist for an AI Assistant to perform the
**initial generation** of a complete CDF project.

## Instructions for the AI

- When the user gives you approval to start a step, you will edit this file to
  mark the previous step's checkbox as complete (`[x]`)
- Do not proceed to a step until the user explicitly approves it.

______________________________________________________________________

## ☐ **Step 1: Process the Foundation Specification**

- **User Action:** Populate `docs/00_Solution_Design_Principles.md`.
- **AI Action:**
  1. Read the input Markdown file.
  1. Validate the content. If any `<REPLACE_ME: ...>` placeholders are found,
     list them as gaps.
  1. **Create JSON:** Based on the populated template, generate a
     `docs/specifications/design_principles.json` file.
  1. **Summarize Gaps:** Create or update `docs/ASSUMPTIONS_AND_GAPS.md`. List
     any missing information (unfilled placeholders) or inconsistencies found.

**Example CLI Commands:**

```bash
# Validate the foundation specification
python tools/spec_validator.py docs/00_Solution_Design_Principles.md

# Generate JSON from populated template
python tools/spec_from_markdown.py docs/00_Solution_Design_Principles.md --output docs/specifications/design_principles.json

# Check for gaps and inconsistencies
python tools/gap_analyzer.py docs/00_Solution_Design_Principles.md --output docs/ASSUMPTIONS_AND_GAPS.md
```

**Sample JSON Output (`design_principles.json`):**

```json
{
  "project": {
    "name": "Well Performance Monitoring",
    "module_name": "well_performance_module",
    "business_goal": "Monitor and optimize well performance through real-time data analysis",
    "primary_use_cases": [
      "Real-time well performance monitoring",
      "Predictive maintenance scheduling",
      "Production optimization"
    ],
    "key_stakeholders": [
      "Reliability Engineer",
      "Operations Manager"
    ]
  },
  "environments": {
    "dev": {
      "admin_group_source_id": "12345678-1234-1234-1234-123456789012",
      "user_group_source_id": "87654321-4321-4321-4321-210987654321"
    },
    "prod": {
      "admin_group_source_id": "11111111-1111-1111-1111-111111111111",
      "user_group_source_id": "22222222-2222-2222-2222-222222222222"
    }
  },
  "data_space": {
    "external_id": "sp_well_performance",
    "description": "Data space for well performance monitoring and optimization"
  },
  "datasets": [
    {
      "external_id": "ds_scada_raw_data",
      "name": "SCADA - RAW Data",
      "description": "Raw data from SCADA systems"
    },
    {
      "external_id": "ds_well_performance_processed",
      "name": "Well Performance - Processed Data",
      "description": "Processed well performance metrics"
    }
  ],
  "raw_databases": [
    {
      "source_system": "SCADA System",
      "database_name": "raw_scada",
      "tables": ["well_pressure", "well_temperature", "flow_rates"],
      "description": "Real-time sensor data from well monitoring systems"
    }
  ],
  "security_roles": [
    {
      "name": "Data Administrator",
      "source_id_variable": "{{ admin_group_source_id }}",
      "permissions_summary": "Full control over all resources in this solution",
      "capabilities": ["datamodels:read,write", "datasets:read,write"]
    },
    {
      "name": "Application User",
      "source_id_variable": "{{ user_group_source_id }}",
      "permissions_summary": "Read-only access to the final processed data",
      "capabilities": ["datamodels:read"]
    }
  ],
  "architectural_standards": {
    "global_naming_convention": "prefix:scope:name",
    "timestamp_standard": "ISO 8601 with UTC timezone",
    "required_property": "source_last_updated_time"
  }
}
```

- **AI Output:** `docs/specifications/design_principles.json` and
  `docs/ASSUMPTIONS_AND_GAPS.md`.

______________________________________________________________________

## ☐ **Step 2: Generate Conceptual Data Model**

- **User Action:** Populate `docs/01_Conceptual_Data_Model_Overview.md`.
- **AI Action:**
  1. Read the input Markdown file.
  1. **Create JSON:** Generate a `docs/specifications/conceptual_model.json`
     file.
  1. **Summarize Gaps:** Append any new assumptions or gaps to
     `docs/ASSUMPTIONS_AND_GAPS.md`.

**Example CLI Commands:**

```bash
# Generate conceptual model JSON
python tools/spec_from_markdown.py docs/01_Conceptual_Data_Model_Overview.md --output docs/specifications/conceptual_model.json

# Validate relationships between objects
python tools/relationship_validator.py docs/specifications/conceptual_model.json --principles docs/specifications/design_principles.json
```

**Sample JSON Output (`conceptual_model.json`):**

```json
{
  "core_business_objects": [
    {
      "name": "Well",
      "type": "Physical Asset",
      "external_id": "well_master_data",
      "description": "Physical well assets with location and configuration data"
    },
    {
      "name": "Work Order",
      "type": "Event",
      "external_id": "work_order_events",
      "description": "Maintenance and operational work orders"
    },
    {
      "name": "Maintenance Report",
      "type": "Document",
      "external_id": "maintenance_reports",
      "description": "Documentation of maintenance activities and findings"
    },
    {
      "name": "ProductionData",
      "type": "Process",
      "external_id": "production_metrics",
      "description": "Time-series production measurements and metrics"
    }
  ],
  "relationships": [
    {
      "source": "Work Order",
      "target": "Well",
      "description": "A Work Order is performed on a Well",
      "relationship_type": "direct"
    },
    {
      "source": "Maintenance Report",
      "target": "Work Order",
      "description": "A Maintenance Report documents the results of a Work Order",
      "relationship_type": "direct"
    },
    {
      "source": "ProductionData",
      "target": "Well",
      "description": "Production Data is measured from a Well",
      "relationship_type": "direct"
    }
  ]
}
```

- **AI Output:** `docs/specifications/conceptual_model.json`.

______________________________________________________________________

## ☐ **Step 3: Generate Object Specifications**

- **User Action:** Populate all `docs/[ConceptName]_Specification.md` files.
- **AI Action:**
  1. For each concept in `conceptual_model.json`, read the corresponding
     `docs/[ConceptName]_Specification.md` file.
  1. Validate the content. If any `<REPLACE_ME: ...>` placeholders are found,
     list them as gaps.
  1. Generate a `docs/specifications/[ConceptName]_spec.json` file.
  1. Append any new assumptions or gaps for the object to
     `docs/ASSUMPTIONS_AND_GAPS.md`.

**Example CLI Commands:**

```bash
# Generate specs for all objects
python tools/spec_from_markdown.py docs/Well_Specification.md --output docs/specifications/well_spec.json
python tools/spec_from_markdown.py docs/WorkOrder_Specification.md --output docs/specifications/work_order_spec.json
python tools/spec_from_markdown.py docs/MaintenanceReport_Specification.md --output docs/specifications/maintenance_report_spec.json
python tools/spec_from_markdown.py docs/ProductionData_Specification.md --output docs/specifications/production_data_spec.json

# Validate all object specs against conceptual model
python tools/object_validator.py docs/specifications/ --conceptual-model docs/specifications/conceptual_model.json
```

**Sample JSON Output (`well_spec.json`):**

```json
{
  "object": {
    "name": "Well",
    "external_id": "well_master_data",
    "summary": "Physical well assets with location, configuration, and operational data",
    "source_system": "SCADA System",
    "dataset": "ds_scada_raw_data",
    "primary_raw_table": "well_master_data"
  },
  "properties": [
    {
      "name": "wellId",
      "data_type": "text",
      "nullable": false,
      "source_field": "WELL_ID",
      "description": "Unique identifier for the well",
      "transformation_rule": null
    },
    {
      "name": "wellName",
      "data_type": "text",
      "nullable": false,
      "source_field": "WELL_NAME",
      "description": "Human-readable name of the well",
      "transformation_rule": null
    },
    {
      "name": "latitude",
      "data_type": "float64",
      "nullable": true,
      "source_field": "LATITUDE",
      "description": "Geographic latitude of the well",
      "transformation_rule": null
    },
    {
      "name": "longitude",
      "data_type": "float64",
      "nullable": true,
      "source_field": "LONGITUDE",
      "description": "Geographic longitude of the well",
      "transformation_rule": null
    },
    {
      "name": "wellType",
      "data_type": "text",
      "nullable": true,
      "source_field": "WELL_TYPE",
      "description": "Type of well (production, injection, etc.)",
      "transformation_rule": "COALESCE(WELL_TYPE, 'Unknown')"
    },
    {
      "name": "sourceLastUpdatedTime",
      "data_type": "timestamp",
      "nullable": false,
      "source_field": "LAST_UPDATED",
      "description": "Timestamp when the record was last updated in the source system",
      "transformation_rule": null
    }
  ],
  "relationships": [],
  "time_series": [
    {
      "name": "Well Pressure",
      "source_external_id_pattern": "scada:well:{{wellId}}:pressure",
      "description": "Real-time pressure measurements from the well"
    },
    {
      "name": "Well Temperature",
      "source_external_id_pattern": "scada:well:{{wellId}}:temperature",
      "description": "Real-time temperature measurements from the well"
    }
  ]
}
```

- **AI Output:** A set of `*_spec.json` files in `docs/specifications/`.

______________________________________________________________________

## ☐ **Step 4: Consolidate into Master Specification**

- **AI Action:**
  1. Combine all `*_spec.json`, `design_principles.json`, and
     `conceptual_model.json` files from `docs/specifications/` into a
     `docs/specifications/project_specification.json` file.
  1. Append a final review summary to `docs/ASSUMPTIONS_AND_GAPS.md`.

**Example CLI Commands:**

```bash
# Consolidate all specifications into master spec
python tools/spec_consolidate.py docs/specifications/ --output docs/specifications/project_specification.json

# Generate final validation report
python tools/final_validator.py docs/specifications/project_specification.json --output docs/ASSUMPTIONS_AND_GAPS.md
```

**Sample JSON Output (`project_specification.json`):**

```json
{
  "metadata": {
    "version": "1.0.0",
    "generated_at": "2024-01-15T10:30:00Z",
    "project_name": "Well Performance Monitoring"
  },
  "design_principles": {
    // ... content from design_principles.json
  },
  "conceptual_model": {
    // ... content from conceptual_model.json
  },
  "business_objects": {
    "well": {
      // ... content from well_spec.json
    },
    "work_order": {
      // ... content from work_order_spec.json
    },
    "maintenance_report": {
      // ... content from maintenance_report_spec.json
    },
    "production_data": {
      // ... content from production_data_spec.json
    }
  },
  "validation_summary": {
    "total_objects": 4,
    "total_properties": 24,
    "total_relationships": 3,
    "total_time_series": 6,
    "validation_status": "complete",
    "gaps_identified": 0
  }
}
```

- **AI Output:** The final `docs/specifications/project_specification.json`
  file.

______________________________________________________________________

## ☐ **Step 5: Generate the Complete CDF Toolkit Configuration**

- **AI Action:**
  1. Parse the final `docs/specifications/project_specification.json` file.
  1. Generate the complete directory structure (`config` files, `modules`
     directory, etc.).
  1. Generate all resource YAML files (`*.dataset.yaml`, `*.group.yaml`,
     `*.container.yaml`, etc.) in their correct locations.

**Example CLI Commands:**

```bash
# Generate complete CDF Toolkit configuration
python tools/yaml_from_spec.py docs/specifications/project_specification.json --output config/

# Validate generated YAML files
python tools/yaml_validator.py config/ --schema schemas/toolkit_schema.json

# Generate deployment script
python tools/generate_deploy_script.py config/ --output deploy.sh
```

**Sample Directory Structure:**

```
config/
├── config.dev.yaml
├── config.prod.yaml
└── modules/
    └── well_performance_module/
        ├── well_performance_module.datamodel.yaml
        ├── data_models/
        │   ├── containers/
        │   │   ├── well_master_data.container.yaml
        │   │   ├── work_order_events.container.yaml
        │   │   ├── maintenance_reports.container.yaml
        │   │   └── production_metrics.container.yaml
        │   └── views/
        │       ├── well_master_data.view.yaml
        │       ├── work_order_events.view.yaml
        │       ├── maintenance_reports.view.yaml
        │       └── production_metrics.view.yaml
        ├── transformations/
        │   ├── well_master_data_transformation.transformation.yaml
        │   ├── work_order_events_transformation.transformation.yaml
        │   ├── maintenance_reports_transformation.transformation.yaml
        │   └── production_metrics_transformation.transformation.yaml
        └── data_sets/
            ├── ds_scada_raw_data.dataset.yaml
            └── ds_well_performance_processed.dataset.yaml
```

**Sample YAML Output (`well_master_data.container.yaml`):**

```yaml
apiVersion: v1
kind: Container
metadata:
  name: well_master_data
  externalId: well_master_data
  description: Container for well master data including location and configuration
spec:
  properties:
    wellId:
      type: text
      nullable: false
      description: Unique identifier for the well
    wellName:
      type: text
      nullable: false
      description: Human-readable name of the well
    latitude:
      type: float64
      nullable: true
      description: Geographic latitude of the well
    longitude:
      type: float64
      nullable: true
      description: Geographic longitude of the well
    wellType:
      type: text
      nullable: true
      description: Type of well (production, injection, etc.)
    sourceLastUpdatedTime:
      type: timestamp
      nullable: false
      description: Timestamp when the record was last updated in the source system
```

- **AI Output:** The complete, deployable set of YAML configuration files for
  the Cognite Toolkit.

______________________________________________________________________

## ⚠️ Common Errors & Troubleshooting

| Step | Possible Error | Diagnostic Command | Resolution |
|------|----------------|--------------------|------------| | 1 |
`MissingPlaceholderError` when converting Markdown |
`spec_validator.py --verbose` | Fill `<REPLACE_ME>` tags or update glossary. | |
2 | `RelationshipMismatchError` in `relationship_validator.py` | `--strict` flag
prints offending objects | Ensure source & target names match **exactly**
between overview & specs. | | 3 | `TypeValidationError` while generating object
JSON | Check `data_type` field: only allowed types | Correct data type or add
mapping rule. | | 5 | `SchemaViolation` during `yaml_validator.py` | `--debug`
outputs file & line | Regenerate YAML with updated spec or patch manually. |

> **Tip**: Most CLI tools accept `--fix` to auto-correct minor issues (e.g.,
> adding missing `description` fields).

## 🔧 Customization Options

1. **Minimal vs. Full Output**
   - Pass `--mode minimal` to `yaml_from_spec.py` to generate only datasets,
     groups, and config files for a PoC.
   - Use `--mode full` *(default)* for complete containers, views,
     transformations.
1. **Environment Filtering**\
   Generate YAML for a single environment:\
   `python yaml_from_spec.py --env dev ...`
1. **Module Prefix Override**\
   Add `--module-prefix my_prefix_` to prepend strings to all resource external
   IDs—useful for multi-module deployments.
1. **ID Mapping File**\
   Provide `--id-map id_map.csv` so the generator re-uses existing
   asset/time-series IDs from legacy systems.

## ✅ Validation Outputs Interpretation

After running `final_validator.py`, you will get a summary in
`ASSUMPTIONS_AND_GAPS.md` similar to:

```md
### Validation Results (2024-05-15)
- ✅ 42 YAML files validated against schema
- ⚠️ 3 Warnings (missing optional `description`)
- ❌ 0 Critical errors
```

*Proceed to deployment only when critical errors = 0.*

______________________________________________________________________

> **Next Step**: Commit generated YAML, push to your repo, and run
> **`cognite toolkit apply --dry-run`** to preview changes in CDF before the
> first live deployment.
