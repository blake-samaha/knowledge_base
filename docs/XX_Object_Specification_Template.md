# Business Object: `<REPLACE_ME: The name of this object, e.g., "Well">`
<!--
This document defines the detailed specification for a single business object.
As the Solution Architect, your goal is to fill in all placeholders.
A separate file should be created for each object in your Conceptual Data Model.
-->

- **Author:** `<REPLACE_ME: Your Name>`
- **Date:** `<REPLACE_ME: YYYY-MM-DD>`
- **Version:** `1.0`

---

## 1. Description

- **Summary:** `<REPLACE_ME: A one-paragraph summary of what this business object represents.>`
- **External ID:** `<REPLACE_ME: Unique external ID for this object. Use snake_case. e.g., well_master_data>`

---

## 2. Data Source & Lineage

- **Source System:** `<REPLACE_ME: The name of the system providing the data, e.g., "SAP S/4HANA">`
- **CDF Data Set:** `<REPLACE_ME: The externalId of the dataSet this object belongs to (from 00_Solution_Design_Principles.md)>`
- **Primary RAW Table:** `<REPLACE_ME: The specific RAW table where the source data resides, e.g., "sap_zpm_workorders">`

---

## 3. Properties

<!--
Define all the properties for this object. Copy this entire block for each new property.
The AI will map these properties to a CDF Container and View.
-->
- **Property:**
    - **Name:** `<REPLACE_ME: The desired property name in camelCase, e.g., workOrderNumber>`
    - **Data Type:** `<REPLACE_ME: text | int32 | int64 | float32 | float64 | boolean | timestamp | json>`
    <!--
    - `text` = A string
    - `int32` / `int64` = 32 or 64-bit integer
    - `float32` / `float64` = 32 or 64-bit floating point number
    - `timestamp` = An ISO 8601 timestamp with timezone
    -->
    - **Nullable:** `<REPLACE_ME: true|false>` <!-- Can this property be empty? -->
    - **Source Field:** `<REPLACE_ME: The exact column name from the RAW table, e.g., "AUFNR">`
    - **Description:** `<REPLACE_ME: A clear, concise description of the property.>`
    - **Transformation Rule:** `(Optional) <REPLACE_ME: A specific SQL expression if the mapping is not direct, e.g., "COALESCE(column_name, 'Unknown')">`

---

## 4. Relationships

<!--
Define how this object connects to other objects. Copy this block for each new relationship.
The AI will add these relationships to the object's View.
-->
- **Relationship:**
    - **Name:** `<REPLACE_ME: The desired relationship name in camelCase, e.g., "asset">`
    - **Data Type:** `direct` <!-- This should always be 'direct' for now. -->
    - **Source Field:** `<REPLACE_ME: The column in this object's RAW table that contains the key for the target object>`
    - **Target Type:** `<REPLACE_ME: The External ID of the target object's View>`
    - **Description:** `<REPLACE_ME: Explain the nature of the relationship, e.g., "A work order is performed on an asset.">`

---

## 5. Time Series

<!--
(Optional) Define any time series that should be attached to instances of this object.
-->
- **Time Series:**
    - **Name:** `<REPLACE_ME: A descriptive name for the time series, e.g., "Annulus Pressure">`
    - **Source External ID Pattern:** `<REPLACE_ME: A pattern to find the source time series external ID. Use {{field_name}} to reference a property from this object, e.g., "acme:well:{{wellName}}:annulus_pressure">`
    - **Description:** `<REPLACE_ME: A clear description of what the time series measures.>`
  