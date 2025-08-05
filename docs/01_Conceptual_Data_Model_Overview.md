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

---

## 3. Performance & Scalability Considerations

| Aspect | Recommendation | CDF Implementation |
|--------|----------------|--------------------|
| **Batching** | Use batch writes (1000 items) for assets, time series, and events. | `client.assets.create(items, chunk_size=1000)` |
| **Indexing** | Index frequently queried properties (e.g., `externalId`, `assetType`). | Define **indexes** in containers or use **filter** API with indexed fields. |
| **Data Partitioning** | Split massive RAW tables by time or source to avoid hotspotting. | Create `raw_sensor_2024_q1`, `raw_sensor_2024_q2`, etc. |
| **Granularity** | Choose appropriate aggregation windows (1m, 10m, 1h) to balance storage vs. query cost. | Pre-compute aggregates via transformations. |
| **Query Patterns** | Design relationships to minimise graph traversal depth (<4). | Denormalise with direct relationships or metadata copies. |

## 4. Migration Strategy

1. **Assess Legacy Schemas**: Map source-system tables to CDF objects.
2. **Define Staging RAW**: Land raw data *as-is* in `raw_<system>` databases.
3. **Iterative Mapping**: Use SQL transformations to populate containers/views incrementally.
4. **Parallel Validation**: Run legacy reports vs. CDF queries to ensure parity.
5. **Cut-over & Backfill**: Switch upstream systems to CDF; backfill historical data in batches.

> ⚡ **Tip**: Keep original external IDs from source systems to simplify reconciliation.

## 5. Validation Framework

Use automated checks to guarantee model quality:

```sql
-- Cardinality check: every Work Order references an existing Well
SELECT COUNT(*) AS orphan_workorders
FROM workorders w
LEFT JOIN wells we ON w.wellExternalId = we.externalId
WHERE we.externalId IS NULL;
```

| Check | Threshold | Tool |
|-------|-----------|------|
| Orphan references | 0 | SQL / Transformation jobs |
| Enum correctness | 100% valid values | dbt tests / SQL |
| Time series completeness | >98% non-null per day | Python validation script |

## 6. Reference Examples

### 6.1 Oil & Gas – Well Performance Model

| Object | Type | Key Properties |
|--------|------|----------------|
| **Well** | Asset | `wellName`, `basin`, `field`, `status` |
| **WorkOrder** | Event | `woNumber`, `status`, `plannedStart`, `actualEnd` |
| **MaintenanceReport** | Document | `reportId`, `author`, `createdTime` |
| **ProductionData** | Process | `oilRate`, `waterRate`, `gasRate` |

Relationships:
- `WorkOrder` **performedOn** → `Well`
- `MaintenanceReport` **documents** → `WorkOrder`
- `ProductionData` **measuredAt** → `Well`

### 6.2 Manufacturing – CNC Machine Uptime Model

| Object | Type | Key Properties |
|--------|------|----------------|
| **Plant** | Asset | `plantCode`, `location` |
| **Machine** | Asset | `serialNumber`, `model`, `commissionDate` |
| **JobOrder** | Event | `jobId`, `startTime`, `endTime`, `status` |
| **DowntimeEvent** | Event | `reasonCode`, `durationMin` |

Relationships:
- `Machine` **locatedIn** → `Plant`
- `JobOrder` **executedBy** → `Machine`
- `DowntimeEvent` **affects** → `Machine`

### 6.3 Utilities – Grid Analytics Model

| Object | Type | Key Properties |
|--------|------|----------------|
| **Substation** | Asset | `substationId`, `region`, `voltageLevel` |
| **Feeder** | Asset | `feederId`, `lengthKm` |
| **Outage** | Event | `outageId`, `startTime`, `restoreTime`, `cause` |
| **LoadMeasurement** | TimeSeries | `kwh`, `kw` |

Relationships:
- `Feeder` **partOf** → `Substation`
- `Outage` **occursOn** → `Feeder`
- `LoadMeasurement` **measures** → `Feeder`

---

> **Next Step**: Duplicate the industry example closest to your project, replace placeholders, then move to the **Object Specification Template** to detail each business object.
