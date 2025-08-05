# 01. Conceptual Data Model Overview
<!--
This document outlines the high-level structure of the data model.
Fill in the [placeholders] to define the core business objects and their relationships.
-->

## 1. Core Business Objects

<!--
List all the primary real-world entities or concepts that the data model will represent.
For each object, specify its type to guide the modeling process.
-->
- **Object:** `[e.g., Well]`
    - **Type:** `[Physical Asset]`
- **Object:** `[e.g., Work Order]`
    - **Type:** `[Event]`
- **Object:** `[e.g., Maintenance Report]`
    - **Type:** `[Document]`
- **Object:** `[e.g., ProductionData]`
    - **Type:** `[Process]`

---

## 2. Relationships Between Objects

<!--
Define how the core business objects connect to each other.
This describes the essential graph structure of the model.
-->
- **Relationship:** `[Work Order]` -> `[Well]`
    - **Description:** `[A Work Order is performed on a Well.]`
- **Relationship:** `[Maintenance Report]` -> `[Work Order]`
    - **Description:** `[A Maintenance Report documents the results of a Work Order.]`
- **Relationship:** `[ProductionData]` -> `[Well]`
    - **Description:** `[Production Data is measured from a Well.]`
