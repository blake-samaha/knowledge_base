# 00. Solution Design Principles & Governance
<!--
This document captures the highest-level decisions for the solution.
As the Solution Architect, your goal is to fill in all placeholders.
The AI will use this document to generate the foundational configuration.
-->

## 1. Project Overview

- **Project Name:** `<REPLACE_ME: The overall name of the solution, e.g., "Well Performance Monitoring">`
- **Module Name:** `<REPLACE_ME: The desired name for the toolkit module, e.g., "well_performance_module">`
- **Business Goal:** `<REPLACE_ME: A one-sentence summary of the primary business objective.>`
- **Primary Use Cases:**
    - `<REPLACE_ME: Use Case 1>`
    - `<REPLACE_ME: Use Case 2>`
- **Key Stakeholders:**
    - `<REPLACE_ME: Role 1, e.g., Reliability Engineer>`
    - `<REPLACE_ME: Role 2, e.g., Operations Manager>`

---

## 2. Project Glossary

<!-- Add all key business terms, acronyms, and abbreviations here to ensure clarity. -->
- **`<REPLACE_ME: Term>`:** `<REPLACE_ME: Definition>`
- **`<REPLACE_ME: Term>`:** `<REPLACE_ME: Definition>`

---

## 3. CDF Project Configuration

### Environments

<!--
Define the different environments for your project (e.g., dev, test, prod).
For each environment, provide the source ID for each security group.
A source ID is the unique identifier from your Identity Provider (e.g., an Azure AD group object ID).
The AI will use these to create `config.[env].yaml` files.
-->
- **Environment:** `dev`
    - **`admin_group_source_id`:** `<REPLACE_ME: IdP source ID for the admin group in dev>`
    - **`user_group_source_id`:** `<REPLACE_ME: IdP source ID for the user group in dev>`
- **Environment:** `prod`
    - **`admin_group_source_id`:** `<REPLACE_ME: IdP source ID for the admin group in prod>`
    - **`user_group_source_id`:** `<REPLACE_ME: IdP source ID for the user group in prod>`

### CDF Data Space

<!-- A space is the top-level container for data models in CDF. -->
- **Space External ID:** `<REPLACE_ME: e.g., sp_my_project_space>`
- **Description:** `<REPLACE_ME: A brief explanation of the space's purpose.>`

### CDF Data Sets

<!-- Define each data set required. Data sets group data from a common source. -->
- **Data Set:**
    - **External ID:** `<REPLACE_ME: e.g., ds_source_system_raw_data>`
    - **Name:** `<REPLACE_ME: e.g., Source System - RAW Data>`
    - **Description:** `<REPLACE_ME: A summary of the data set's contents.>`
- **Data Set:**
    - **External ID:** `<REPLACE_ME: e.g., ds_my_project_processed_data>`
    - **Name:** `<REPLACE_ME: e.g., My Project - Processed Data>`
    - **Description:** `<REPLACE_ME: A summary of the data set's contents.>`

### RAW Databases & Tables

<!-- Define each source system that will provide data to CDF RAW. -->
- **Source System:** `<REPLACE_ME: e.g., "SAP S4/HANA">`
    - **RAW Database Name:** `<REPLACE_ME: e.g., raw_sap_s4hana>`
    - **RAW Table(s):**
        - `<REPLACE_ME: table_name_1>`
        - `<REPLACE_ME: table_name_2>`
    - **Description:** `<REPLACE_ME: What data these tables hold.>`

### Access Management & Security Roles

<!-- Define the access roles needed for this solution. -->
- **Role:** `<REPLACE_ME: e.g., Data Administrator>`
    - **Source ID Variable:** `{{ admin_group_source_id }}` <!-- This MUST match a variable in the Environments section -->
    - **Permissions Summary:** "Full control over all resources in this solution."
    - **CDF Capabilities:** <!-- List the required permissions for this role -->
        - `datamodels:read,write`
        - `datasets:read,write`
- **Role:** `<REPLACE_ME: e.g., Application User>`
    - **Source ID Variable:** `{{ user_group_source_id }}` <!-- This MUST match a variable in the Environments section -->
    - **Permissions Summary:** "Read-only access to the final processed data."
    - **CDF Capabilities:** <!-- List the required permissions for this role -->
        - `datamodels:read`

---

## 4. Key Architectural Decisions & Standards

<!-- Document critical technical standards to be enforced by the AI. -->
- **Global Naming Convention:** `<REPLACE_ME: e.g., prefix:scope:name>`
- **Timestamp Standard:** `<REPLACE_ME: e.g., ISO 8601 with UTC timezone>`
- **Required Property for All Objects:** `<REPLACE_ME: e.g., source_last_updated_time>`

---

## 5. Best Practices Summary

Follow these universal guidelines when completing this template:

- Keep object and dataset **external IDs** lowercase and snake_case for consistency.
- Align **RAW database names** with their **source system** (e.g., `raw_sap_pm`).
- Use **ISO-8601** timestamps with UTC for all time fields.
- Leverage **batch operations** in all data ingestion scripts to honour CDF rate limits.
- Map **business terms** in the glossary to data model objects to avoid ambiguity.
- Define **security roles** first; they drive every downstream IaC file the AI will generate.

## 6. Common Pitfalls & How to Avoid Them

| Pitfall | Consequence | How to Mitigate |
|---------|-------------|-----------------|
| Vague business goal | Misaligned data model & KPIs | Summarise the business value in **one measurable sentence** |
| Missing source IDs | CI/CD pipeline fails during security-group creation | Collect Azure AD group object IDs before running generation workflow |
| Ambiguous glossary terms | Inconsistent naming across modules | Add glossary entries for **every new acronym** introduced |
| Over-granular RAW tables | Excessive ingestion cost | Group low-volume tables into a single RAW table where possible |

## 7. Validation Checklist

Use this checklist before committing the filled template:

- [ ] All `<REPLACE_ME>` placeholders removed
- [ ] At least **one environment** (`dev`) configured with valid IDs
- [ ] Every dataset has a clear **ownership description**
- [ ] Security roles reference **existing** variables from *Environments* section
- [ ] Global naming convention example matches sample IDs in the template
- [ ] Document lint passes (`markdownlint .`)

## 8. Integration Examples

Below are example snippets showing how the AI will convert this template into code.

### Python SDK: Reading Config
```python
from pathlib import Path
import yaml
from cognite.client import CogniteClient

config = yaml.safe_load(Path("config.dev.yaml").read_text())
client = CogniteClient(
    project=config["project"],
    api_key=os.getenv("CDF_API_KEY"),
)
print(client.datasets.list(limit=5))
```

### Cognite Toolkit: Deploying Resources
```bash
cognite toolkit apply \
  --project my-cdf-project \
  --environment dev \
  --module well_performance_module
```

---

# 📚 Reference Examples

The following three fully-populated examples illustrate how to complete this template for different industries. **Copy & adapt** the sections as needed.

## Example A – Oil & Gas: Well Performance Monitoring

### 1. Project Overview (Filled)
- **Project Name:** Well Performance Monitoring
- **Module Name:** well_performance_module
- **Business Goal:** Improve production efficiency by 5% through real-time visibility of well KPIs.
- **Primary Use Cases:**
    - Detect under-performing wells automatically
    - Correlate downtime events with production loss
- **Key Stakeholders:**
    - Reliability Engineer
    - Production Supervisor

### 2. Project Glossary (Excerpt)
- **`ESP`**: Electric Submersible Pump
- **`GOR`**: Gas-Oil Ratio

### 3. CDF Project Configuration (Excerpt)
- **Environment:** dev
    - **`admin_group_source_id`:** 0a1b2c3d-dev
    - **`user_group_source_id`:** 9f8e7d6c-dev
- **Space External ID:** sp_well_perf
- **Data Set:**
    - **External ID:** ds_pi_raw
    - **Name:** PI Historian RAW
    - **Description:** Minute-level sensor data from PI

### 4. Key Architectural Decisions
- **Global Naming Convention:** og:{asset_type}:{tag}
- **Timestamp Standard:** ISO-8601 UTC
- **Required Property for All Objects:** source_last_updated_time

---

## Example B – Manufacturing: Predictive Maintenance

*(Provide similar filled sections tailored to a manufacturing plant with CNC machines)*

---

## Example C – Utilities: Grid Analytics Platform

*(Provide similar filled sections tailored to a power-grid asset hierarchy & SCADA data)*

---

> **Next Step**: Duplicate a reference example closest to your industry, update specific values, then run the *Initial Project Generation* workflow to scaffold your CDF project.
