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

**Example CLI Commands:**
```bash
# Regenerate JSON for the updated object
python tools/spec_from_markdown.py docs/Well_Specification.md --output docs/specifications/well_spec.json

# Update the master specification with the new object definition
python tools/spec_update.py docs/specifications/project_specification.json --object well --spec docs/specifications/well_spec.json

# Validate the updated specification
python tools/spec_validator.py docs/specifications/project_specification.json --object well

# Check for any new gaps introduced by the change
python tools/gap_analyzer.py docs/Well_Specification.md --existing-gaps docs/ASSUMPTIONS_AND_GAPS.md --output docs/ASSUMPTIONS_AND_GAPS.md
```

**Sample JSON Output (Updated `well_spec.json`):**
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
      "name": "wellDepth",
      "data_type": "float64",
      "nullable": true,
      "source_field": "WELL_DEPTH",
      "description": "Total depth of the well in meters",
      "transformation_rule": null
    },
    {
      "name": "productionCapacity",
      "data_type": "float64",
      "nullable": true,
      "source_field": "PROD_CAPACITY",
      "description": "Maximum production capacity in barrels per day",
      "transformation_rule": null
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
    },
    {
      "name": "Flow Rate",
      "source_external_id_pattern": "scada:well:{{wellId}}:flow_rate",
      "description": "Real-time flow rate measurements from the well"
    }
  ]
}
```

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

**Example CLI Commands:**
```bash
# Regenerate only the affected YAML files for the well object
python tools/yaml_from_spec.py docs/specifications/project_specification.json --object well_master_data --output config/modules/well_performance_module/

# Update the datamodel YAML to reflect the changes
python tools/update_datamodel.py config/modules/well_performance_module/well_performance_module.datamodel.yaml --object well_master_data

# Validate the regenerated YAML files
python tools/yaml_validator.py config/modules/well_performance_module/ --object well_master_data

# Generate a diff report showing what changed
python tools/yaml_diff.py config/modules/well_performance_module/ --before-snapshot before_changes/ --after-snapshot config/modules/well_performance_module/ --output changes_report.md
```

**Sample YAML Output (Updated `well_master_data.container.yaml`):**
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
    wellDepth:
      type: float64
      nullable: true
      description: Total depth of the well in meters
    productionCapacity:
      type: float64
      nullable: true
      description: Maximum production capacity in barrels per day
    sourceLastUpdatedTime:
      type: timestamp
      nullable: false
      description: Timestamp when the record was last updated in the source system
```

**Sample YAML Output (Updated `well_master_data.view.yaml`):**
```yaml
apiVersion: v1
kind: View
metadata:
  name: well_master_data
  externalId: well_master_data
  description: View for well master data with all properties and relationships
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
    wellDepth:
      type: float64
      nullable: true
      description: Total depth of the well in meters
    productionCapacity:
      type: float64
      nullable: true
      description: Maximum production capacity in barrels per day
    sourceLastUpdatedTime:
      type: timestamp
      nullable: false
      description: Timestamp when the record was last updated in the source system
  relationships: []
  timeSeries:
    - name: Well Pressure
      sourceExternalId: "scada:well:{{wellId}}:pressure"
      description: Real-time pressure measurements from the well
    - name: Well Temperature
      sourceExternalId: "scada:well:{{wellId}}:temperature"
      description: Real-time temperature measurements from the well
    - name: Flow Rate
      sourceExternalId: "scada:well:{{wellId}}:flow_rate"
      description: Real-time flow rate measurements from the well
```

**Sample YAML Output (Updated `well_master_data_transformation.transformation.yaml`):**
```yaml
apiVersion: v1
kind: Transformation
metadata:
  name: well_master_data_transformation
  externalId: well_master_data_transformation
  description: Transformation for well master data from RAW to processed format
spec:
  source:
    type: raw
    database: raw_scada
    table: well_master_data
  destination:
    type: view
    externalId: well_master_data
  query: |
    SELECT
      WELL_ID as wellId,
      WELL_NAME as wellName,
      CAST(LATITUDE as DOUBLE) as latitude,
      CAST(LONGITUDE as DOUBLE) as longitude,
      COALESCE(WELL_TYPE, 'Unknown') as wellType,
      CAST(WELL_DEPTH as DOUBLE) as wellDepth,
      CAST(PROD_CAPACITY as DOUBLE) as productionCapacity,
      LAST_UPDATED as sourceLastUpdatedTime
    FROM raw_scada.well_master_data
    WHERE WELL_ID IS NOT NULL
```

- **Output:** Overwrite only the specific YAML files that were affected by the change.
