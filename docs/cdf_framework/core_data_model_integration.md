# Cognite Core Data Model Integration Guide

## Overview

Extend Cognite's Core Data Model (CogniteCore) from the `cdf_cdm` system space.
This ensures standardization, AI optimization compatibility, interoperability
with Cognite tools, and alignment with industry best practices.

## Why Extend Core Data Model?

- **Standardization**: Use proven industrial data patterns.
- **Interoperability**: Seamless integration with Cognite applications.
- **AI Readiness**: Better support for machine learning workflows.
- **Efficiency**: Reduce custom development time.

## Core Concepts Mapping

| Framework Type | Cognite Core Concept | Description |
|---------------|----------------------|-------------| | Physical Asset |
`CogniteAsset` | For functional locations like plants or systems. | | Equipment
| `CogniteEquipment` | For devices like pumps or sensors. | | Event |
`CogniteActivity` | For work orders or maintenance tasks. | | Document |
`CogniteFile` | For reports and manuals. |

## Core Features Implementation

### CogniteDescribable

- Properties: name, description, tags, aliases
- Usage: All business objects must extend this.

### CogniteSourceable

- Properties: sourceId, sourceContext, source, sourceCreatedTime
- Usage: All data ingestion objects.

## Python SDK Example

```python
from cognite.client import CogniteClient
from cognite.client.data_classes import data_modeling as dm

client = CogniteClient()

pump_view = dm.View(
    space="my_space",
    external_id="Pump",
    version="v1",
    implements=[dm.ViewId("cdf_cdm", "CogniteAsset", "v1")],
    properties={
        "equipmentClass": dm.PropertyType(dm.Text()),
        "manufacturer": dm.PropertyType(dm.Text()),
    },
)

client.data_modeling.views.apply(pump_view)
```

## GraphQL Schema Example

```graphql
interface CogniteAsset {
  name: String!
  description: String
  tags: [String]
}

type Pump implements CogniteAsset @view(space: "my_space", version: "v1") {
  name: String!
  description: String
  tags: [String]
  equipmentClass: String @indexed
  manufacturer: String
}
```

## Best Practices

- Always extend from `cdf_cdm` space.
- Implement at least CogniteDescribable and CogniteSourceable.
- Use versioned views for evolution.
- Validate extensions with CDF Toolkit.

*For more details, see Cognite documentation on data modeling.*
