# 00. Solution Design Principles & Governance

<!--
This document captures the highest-level decisions for the solution.
As the Solution Architect, your goal is to fill in all placeholders.
The AI will use this document to generate the foundational configuration.
-->

## 1. Project Overview

- **Project Name:**
  `<REPLACE_ME: The overall name of the solution, e.g., "Well Performance Monitoring">`
- **Module Name:**
  `<REPLACE_ME: The desired name for the toolkit module, e.g., "well_performance_module">`
- **Business Goal:**
  `<REPLACE_ME: A one-sentence summary of the primary business objective.>`
- **Primary Use Cases:**
  - `<REPLACE_ME: Use Case 1>`
  - `<REPLACE_ME: Use Case 2>`
- **Key Stakeholders:**
  - `<REPLACE_ME: Role 1, e.g., Reliability Engineer>`
  - `<REPLACE_ME: Role 2, e.g., Operations Manager>`

______________________________________________________________________

## 2. Project Glossary

<!-- Add all key business terms, acronyms, and abbreviations here to ensure clarity. -->

- **`<REPLACE_ME: Term>`:** `<REPLACE_ME: Definition>`
- **`<REPLACE_ME: Term>`:** `<REPLACE_ME: Definition>`

______________________________________________________________________

## 3. CDF Project Configuration

### Environments

<!--
Define the different environments for your project (e.g., dev, test, prod).
For each environment, provide the source ID for each security group.
A source ID is the unique identifier from your Identity Provider (e.g., an Azure AD group object ID).
The AI will use these to create `config.[env].yaml` files.
-->

- **Environment:** `dev`
  - **`admin_group_source_id`:**
    `<REPLACE_ME: IdP source ID for the admin group in dev>`
  - **`user_group_source_id`:**
    `<REPLACE_ME: IdP source ID for the user group in dev>`
- **Environment:** `prod`
  - **`admin_group_source_id`:**
    `<REPLACE_ME: IdP source ID for the admin group in prod>`
  - **`user_group_source_id`:**
    `<REPLACE_ME: IdP source ID for the user group in prod>`

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
  - **Source ID Variable:** `{{ admin_group_source_id }}`
        <!-- This MUST match a variable in the Environments section -->
  - **Permissions Summary:** "Full control over all resources in this solution."
  - **CDF Capabilities:** <!-- List the required permissions for this role -->
    - `datamodels:read,write`
    - `datasets:read,write`
- **Role:** `<REPLACE_ME: e.g., Application User>`
  - **Source ID Variable:** `{{ user_group_source_id }}`
        <!-- This MUST match a variable in the Environments section -->
  - **Permissions Summary:** "Read-only access to the final processed data."
  - **CDF Capabilities:** <!-- List the required permissions for this role -->
    - `datamodels:read`

______________________________________________________________________

## 4. Key Architectural Decisions & Standards

<!-- Document critical technical standards to be enforced by the AI. -->

- **Global Naming Convention:** `<REPLACE_ME: e.g., prefix:scope:name>`
- **Timestamp Standard:** `<REPLACE_ME: e.g., ISO 8601 with UTC timezone>`
- **Required Property for All Objects:**
  `<REPLACE_ME: e.g., source_last_updated_time>`

## 5. Core Model Inheritance

<!-- This section defines default inheritance for views, propagating to lower-tier templates. Why? Inheritance from Cognite Core (e.g., CogniteAsset) enables built-in features like hierarchy support and query optimization. -->

- **Default Inheritance for Asset Objects:**
  `<REPLACE_ME: e.g., CogniteAsset v1>`
- **Default Inheritance for Event Objects:**
  `<REPLACE_ME: e.g., CogniteEvent v1>`

## 6. Cross-Model Integrations

<!-- Specify external models to import for reuse. This allows referencing objects from other spaces/models, enabling modular designs. Example: Import Cognite Core for standard assets. -->

- **Import from Space:** `<REPLACE_ME: e.g., cdf_cdm>`
  - **Models to Import:** `<REPLACE_ME: e.g., CogniteAsset v1, CogniteEvent v1>`
