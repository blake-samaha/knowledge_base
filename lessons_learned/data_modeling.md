# Data Modeling: Choosing Between Event-like and File-like Models

A common data modeling challenge is deciding whether to represent a concept as a time-stamped record (similar to a `CogniteEvent`) or as a document (similar to a `CogniteFile`). The correct choice is not based on the concept's name, but on its primary **access pattern**—how users and applications will need to query and interact with the data.

The decision should be driven by answering the following key questions about the data's usage:

## 1. Are the individual data points first-class citizens?

- **Scenario A**: An "Equipment Test" produces a result with multiple values (e.g., `temperature`, `pressure`, `vibration`). Engineers need to run queries directly against these values, such as "Find all tests where `pressure` was above X" or "Plot the `vibration` from all historical tests for this asset."
- **Conclusion**: The individual data points are queryable. This strongly favors an **Event-like model** where `temperature`, `pressure`, and `vibration` are properties in a container. This makes them visible to the query engine for efficient filtering and aggregation.

- **Scenario B**: An "Operating Procedure" document contains a set of instructions. Users never query the individual steps inside the document. They only ever ask for "the latest operating procedure for this asset."
- **Conclusion**: The data is treated as a single, indivisible blob. This favors a **File-like model**, where the entire document is the payload.

## 2. How critical is historical analysis and trending?

- **Scenario A**: Analyzing the trend of "Monthly Maintenance Reports" over the last two years is a critical workflow. Users need to slice, dice, and compare data from many historical records efficiently.
- **Conclusion**: Efficiently querying over a time range is paramount. An **Event-like model** with native, indexed `startTime` and `endTime` properties is architecturally superior, as it is optimized for performant time-based queries.

- **Scenario B**: For a "Design Specification" document, the only common query is to retrieve the *single* currently active version. Historical analysis is rare.
- **Conclusion**: The primary access pattern is "get the latest." A **File-like model** with a `validFrom` date in its metadata is often sufficient. The performance demands for historical queries are lower, so building a custom solution is less risky than for a time-series-heavy use case.

## Summary: Access-Pattern-Driven Choice

| Factor | Choose an Event-like Model When... | Choose a File-like Model When... |
| :--- | :--- | :--- |
| **Query Pattern** | You need to filter/aggregate on individual properties within the record. | You retrieve the record as a single, whole unit (a blob). |
| **Data Nature** | The record consists of a set of key metrics and values. | The record is a complex document (PDF, CSV, large JSON). |
| **Temporal Needs**| Analyzing trends across many historical records is a common, critical task. | The most common task is retrieving the single "latest" or "active" record. |
| **Example** | `EquipmentTestResult`, `MaintenanceLogEntry`, `QualitySample` | `OperatingProcedure`, `SafetyManual`, `DesignSpecification` |

By focusing on the access pattern first, you can design a data model that is not only conceptually sound but also performant and scalable for its primary engineering and operational workflows.
