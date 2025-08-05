# AI Instructions: Targeted Component Update

This document provides a step-by-step guide for an AI Assistant to perform a
**targeted update** to a single business object within an existing project.

______________________________________________________________________

## **Step 1: Update the Specification Files**

- **Input:** The user-modified `docs/[ObjectName]_Specification.md` file.
- **Instructions:**
  1. Read the updated Markdown specification file.
  1. **Regenerate JSON:** Based on the updated content, regenerate the
     corresponding `docs/specifications/[ObjectName]_spec.json` file.
  1. **Update Master Spec:** Load the master
     `docs/specifications/project_specification.json` file and replace the old
     object definition with the newly generated one.
  1. **Summarize Gaps:** Append any new assumptions or identified gaps for this
     change to `docs/ASSUMPTIONS_AND_GAPS.md`.

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

- **Output:** The updated `docs/specifications/[ObjectName]_spec.json` and
  `docs/specifications/project_specification.json` files.

______________________________________________________________________

## **Step 2: Regenerate Only Affected CDF Artifacts**

- **Input:** The updated `docs/specifications/project_specification.json` and
  the `externalId` of the business object that changed.
- **Process:**
  1. Parse the `project_specification.json` to find the changed business object.
  1. Regenerate only the specific YAML files related to that object. This
     includes:
     - `data_models/containers/{object_externalId}.container.yaml`
     - `data_models/views/{object_externalId}.view.yaml`
     - `transformations/{object_externalId}_transformation.transformation.yaml`
       (if applicable)
  1. Update the main `{datamodel_name}.datamodel.yaml` file to ensure its
     `views` list is still correct.

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

**Sample YAML Output (Updated
`well_master_data_transformation.transformation.yaml`):**

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

- **Output:** Overwrite only the specific YAML files that were affected by the
  change.

______________________________________________________________________

## **Step 3: Impact Analysis & Rollback Plan**

Once YAML artefacts are regenerated, assess downstream impact *before*
deployment.

1. **Generate Diff Report**

   ```bash
   cognite toolkit diff --project my-cdf-project --module well_performance_module \
       --env dev --new-config config/ --output diff_report.md
   ```

1. **Classify Changes**\
   Parse `diff_report.md` and tag each change: `BREAKING`, `NON_BREAKING`,
   `PERFORMANCE`, `SECURITY`.

1. **Estimate Downtime**\
   Use `tools/impact_estimator.py` to predict ingestion lag or API downtime.

1. **Stakeholder Sign-Off**\
   Update `CHANGE_REQUEST.md` with summary and obtain approvals (Ops, Data
   Governance).

1. **Rollback Scripts**\
   Auto-generate rollback YAML:

   ```bash
   python tools/generate_rollback.py diff_report.md --output rollback/ --mode safety
   ```

> **Rollback Policy:** Always keep previous YAML bundle (`before_changes/`) for
> instant re-apply using `cognite toolkit apply --dir before_changes/`.

### Before / After Example

| Metric | Before Update | After Update |
|--------|---------------|--------------| | Container properties | 6 | 8 | |
Transformation runtime | 2m 15s | 2m 18s | | View query latency (p95) | 750 ms |
780 ms |

If p95 latency ↑ >10 %, mark as `PERFORMANCE` and re-evaluate query.

______________________________________________________________________

## **Step 4: Deploy & Monitor**

1. **Dry-Run Deployment**

   ```bash
   cognite toolkit apply --dry-run --project my-cdf-project --env dev --dir config/
   ```

1. **Live Deployment** (if dry-run clean)

   ```bash
   cognite toolkit apply --project my-cdf-project --env dev --dir config/ --yes
   ```

1. **Post-Deploy Smoke Tests**\
   Run `pytest tests/smoke/` which includes:

   - Container existence check
   - Transformation run status == `Completed`
   - Sample view query returns >0 rows

1. **Performance Monitoring**\
   Execute
   `python tools/perf_monitor.py --object well_master_data --duration 60` to
   track latency and ingest rate.

1. **Alerting**\
   If error rate >1 % or latency ↑ 20 % => auto-trigger rollback script.

______________________________________________________________________

## **Real-World Scenario: Add New Property to Well**

**Change Request:** Add `completionDate` (timestamp) to **Well** object.

### 1. Update Spec (Markdown)

```md
- **Property:**
    - **Name:** completionDate
    - **Data Type:** timestamp
    - **Nullable:** true
    - **Source Field:** COMPLETION_DATE
    - **Description:** Date well was completed and ready for production
```

### 2. Run Steps 1-4 Above

Expected artefact changes: container, view, transformation SQL.

### 3. Validation

- Transformation SQL recompiles ✅
- View returns `completionDate` column ✅
- No existing queries fail (nullable) ✅

______________________________________________________________________

## **Common Pitfalls & Solutions**

| Pitfall | Symptom | Fix | |---------|---------|-----| | Forgetting to update
`datamodel.yaml` | Toolkit error "view not found" | Re-run `update_datamodel.py`
step. | | Adding non-nullable property without default | Transformation fails on
NULL | Provide `COALESCE()` or set `nullable: true` initially. | | Breaking
relationship targets | View creation fails | Validate target external IDs exist;
regenerate dependent views first. | | Overwriting unrelated YAML | Git diff
shows large changes | Use `--object` flag to limit generator to specific
component. |

______________________________________________________________________

> **Next Step**: After stable deployment in *dev*, promote YAML to *prod* via
> standard Git flow (PR & review) and rerun Steps 3-4 with `--env prod`.
