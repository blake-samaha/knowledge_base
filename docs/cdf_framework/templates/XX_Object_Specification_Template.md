# Business Object: `<REPLACE_ME: The name of this object, e.g., "Well">`

<!--
This document defines the detailed specification for a single business object.
As the Solution Architect, your goal is to fill in all placeholders.
A separate file should be created for each object in your Conceptual Data Model.
-->

- **Author:** `<REPLACE_ME: Your Name>`
- **Date:** `<REPLACE_ME: YYYY-MM-DD>`
- **Version:** `1.0`

______________________________________________________________________

## 1. Description

- **Summary:**
  `<REPLACE_ME: A one-paragraph summary of what this business object represents.>`
- **External ID:**
  `<REPLACE_ME: Unique external ID for this object. Use snake_case. e.g., well_master_data>`

______________________________________________________________________

## 2. Data Source & Lineage

- **Source System:**
  `<REPLACE_ME: The name of the system providing the data, e.g., "SAP S/4HANA">`
- **CDF Data Set:**
  `<REPLACE_ME: The externalId of the dataSet this object belongs to (from 00_Solution_Design_Principles.md)>`
- **Primary RAW Table:**
  `<REPLACE_ME: The specific RAW table where the source data resides, e.g., "sap_zpm_workorders">`

______________________________________________________________________

## 3. Properties

<!--
Define all the properties for this object. Copy this entire block for each new property.
The AI will map these properties to a CDF Container and View.
-->

- **Property:**
  - **Name:**
    `<REPLACE_ME: The desired property name in camelCase, e.g., workOrderNumber>`
  - **Data Type:**
    `<REPLACE_ME: text | int32 | int64 | float32 | float64 | boolean | timestamp | json>`
  <!--
    - `text` = A string
    - `int32` / `int64` = 32 or 64-bit integer
    - `float32` / `float64` = 32 or 64-bit floating point number
    - `timestamp` = An ISO 8601 timestamp with timezone
    -->
  - **Nullable:** `<REPLACE_ME: true|false>`
        <!-- Can this property be empty? -->
  - **Source Field:**
    `<REPLACE_ME: The exact column name from the RAW table, e.g., "AUFNR">`
  - **Description:**
    `<REPLACE_ME: A clear, concise description of the property.>`
  - **Transformation Rule:**
    `(Optional) <REPLACE_ME: A specific SQL expression if the mapping is not direct, e.g., "COALESCE(column_name, 'Unknown')">`

______________________________________________________________________

## 4. Relationships

<!--
Define how this object connects to other objects. Copy this block for each new relationship.
The AI will add these relationships to the object's View.
-->

- **Relationship:**
  - **Name:**
    `<REPLACE_ME: The desired relationship name in camelCase, e.g., "asset">`
  - **Data Type:** `direct` <!-- This should always be 'direct' for now. -->
  - **Source Field:**
    `<REPLACE_ME: The column in this object's RAW table that contains the key for the target object>`
  - **Target Type:** `<REPLACE_ME: The External ID of the target object's View>`
  - **Description:**
    `<REPLACE_ME: Explain the nature of the relationship, e.g., "A work order is performed on an asset.">`

______________________________________________________________________

## 5. Time Series

<!--
(Optional) Define any time series that should be attached to instances of this object.
-->

- **Time Series:**
  - **Name:**
    `<REPLACE_ME: A descriptive name for the time series, e.g., "Annulus Pressure">`
  - **Source External ID Pattern:**
    `<REPLACE_ME: A pattern to find the source time series external ID. Use {{field_name}} to reference a property from this object, e.g., "acme:well:{{wellName}}:annulus_pressure">`
  - **Description:**
    `<REPLACE_ME: A clear description of what the time series measures.>`

______________________________________________________________________

## 6. Data Quality & Validation Rules

Specify automatic validation checks to ensure data integrity.

| Rule ID | Description | Severity | Implementation Example |
|---------|-------------|----------|------------------------| | **DQ-001** |
`externalId` must be unique within the data set | Critical | SQL
`SELECT COUNT(*), COUNT(DISTINCT externalId)` | | **DQ-002** | Timestamps must
be in the past (no future dates) | High | Transformation
`WHERE timestamp <= CURRENT_TIMESTAMP` | | **DQ-003** | `status` enum must be
one of ["CREATED", "IN_PROGRESS", "COMPLETED"] | Medium | dbt `accepted_values`
test | | **DQ-004** | Missing mandatory property values < 1% | Warning | Python
assertion on null ratio |

> **Tip**: Integrate these checks into your CI/CD pipeline using dbt or pytest.

## 7. Best Practice Guidelines

1. **Use camelCase** for property names and snake_case for external IDs.
1. Prefer **int64** over int32 for IDs to future-proof key space.
1. Store reference enums as **text** but document allowed values.
1. Add **units** in property descriptions for all numeric measurements.
1. Keep **relationships single-directional** to reduce graph complexity; reverse
   edges can be derived in queries.

## 8. Fully-Populated Reference – *Well* (Oil & Gas)

| Section | Example Values | |---------|----------------| | **Business Object**
| Well | | **Author** | Jane Doe | | **Date** | 2024-05-15 | | **External ID** |
well_master_data | | **Summary** | Represents an individual production well,
including static metadata and current status. |

### 8.1 Properties

| Name | Type | Nullable | Source Field | Description |
|------|------|----------|--------------|-------------| | `wellName` | text |
false | `WELL_NAME` | Human-readable well identifier | | `field` | text | false
| `FIELD_ID` | Field (oilfield) where the well is located | | `spudDate` |
timestamp | true | `SPUD_DATE` | Date drilling started | | `status` | text |
false | `STATUS` | Enum: OPEN, SHUT_IN, ABANDONED | | `wellHeadElevationM` |
float32 | true | `WH_ELEV_M` | Wellhead elevation in meters |

### 8.2 Relationships

| Name | Target Type | Source Field | Description |
|------|-------------|-------------|-------------| | `asset` | asset_view |
`ASSET_ID` | Links well to physical asset in CDF hierarchy | | `reservoir` |
reservoir_view | `RESERVOIR_ID` | Geologic reservoir that the well produces from
|

### 8.3 Time Series

| Name | External ID Pattern | Description |
|------|---------------------|-------------| | `wellheadPressure` |
`pi:well:{{wellName}}:whp` | Wellhead pressure (kPa) | | `oilRate` |
`pi:well:{{wellName}}:oil_rate` | Oil production rate (bbl/day) |

### 8.4 Validation Rules (Examples)

- Ensure `status` in [OPEN, SHUT_IN, ABANDONED].
- `spudDate` cannot be after today.
- `wellHeadElevationM` between ‑500 and 5000.

> Duplicate this reference file, change values, and remove guidance sections for
> each new object in your model.
