# Context Engineering

Context engineering is the strategic discipline of designing and building dynamic systems that provide AI assistants with the right information, in the right format, at the right time. It's the foundation of effective AI-assisted development.

## 🎯 What is Context Engineering?

While **prompt engineering** focuses on crafting the perfect instructions for a single request-response cycle, **context engineering** governs the selection, compression, memory, and tool schemas for an entire workflow.

### Key Distinction
- **Prompt Engineering**: "How do I ask the question?"
- **Context Engineering**: "What does the AI need to know before I even ask the question?"

## 🏗️ The Three Tiers of Context

### Tier 1: Project-Level Context (Global Blueprint)
**Purpose**: Define the overall project environment and standards

**Contents**:
- Technology stack and specific versions
- Overarching architectural patterns
- Core design principles and coding standards
- Code organization and folder structure
- Naming conventions and workflows

**Implementation**: Store in `.cursor/rules.md` file in project root

### Tier 2: Feature-Level Context (Local Schematic)
**Purpose**: Provide information relevant to a specific feature or module

**Contents**:
- Related component interfaces
- API schemas and data models
- State management patterns
- Relevant test files and documentation

**Implementation**: Have relevant files open in editor or use `@file` references

### Tier 3: Task-Level Context (Immediate Instruction)
**Purpose**: Provide specific details for a single, immediate action

**Contents**:
- Specific implementation goal
- Acceptance criteria
- Performance requirements
- Environment compatibility needs

**Implementation**: Include directly in the prompt or chat message

## 🛠️ Implementation in Cursor IDE

### 1. Project-Level Context (`.cursor/rules.md`)

#### Real Example: CDF Asset Monitoring Solution
```markdown
# Project Rules for AI Assistant - CDF Asset Monitoring

## Technology Stack
- Cognite Python SDK 7.13.0 for CDF interactions
- Cognite Toolkit 0.1.0 for infrastructure as code
- Python 3.11.7 with type hints everywhere
- FastAPI 0.109.0 for custom APIs
- Apache Spark 3.5.0 for data transformations
- Docker + Kubernetes for deployment
- Poetry for dependency management

## CDF Architecture Standards
- Data Space: `sp_asset_monitoring` for all data models
- Core Data Model: Extend from cdf_cdm:CogniteAsset v1
- Naming Convention: `{source}:{type}:{identifier}`
  - Example: `sap:pump:P-101`, `scada:sensor:temperature`
- External IDs: Use snake_case for all external IDs
- Timestamps: ISO 8601 with UTC timezone everywhere

## Data Modeling Patterns
- Always extend from Cognite Core Data Model (CDM)
- Container structure:
  ```
  containers/
    Pump.container.yaml          # Custom properties for pumps
    Compressor.container.yaml    # Custom properties for compressors
    MaintenanceOrder.container.yaml
  views/
    Pump.view.yaml              # Implements CogniteAsset
    Compressor.view.yaml        # Implements CogniteAsset
    MaintenanceOrder.view.yaml  # Implements CogniteActivity
  ```
- Use `requires` constraints to ensure data integrity
- Link time series using consistent patterns: `{asset_type}:{asset_id}:{measurement}`

## Transformation Standards
- Use Cognite Transformations for all data ingestion
- SQL transformations must include:
  - Proper error handling with COALESCE
  - Data quality checks (NOT NULL constraints)
  - Consistent timestamp handling
  - node_reference() for relationships
- Schedule patterns:
  - Real-time data: Every 5 minutes
  - Master data: Daily at 02:00 UTC
  - Historical loads: One-time with backfill

## Time Series Patterns
- External ID format: `{source}:{asset}:{measurement}:{unit}`
  - Example: `pi:pump:P-101:flow:m3h`
- Metadata requirements:
  - unit: Required for all measurements
  - description: Human-readable description
  - assetId: Link to parent asset
  - source: Origin system identifier

## Security & Access Control
- Groups follow pattern: `{environment}_{role}`
  - Example: `prod_admins`, `dev_users`
- Capabilities assignment:
  - Admins: Full access to space and transformations
  - Users: Read-only access to views and time series
  - Service accounts: Specific write permissions

## Query Optimization
- Use GraphQL for complex queries with relationships
- Implement pagination for large result sets
- Cache frequently accessed master data
- Use projections to limit returned fields
- Index commonly filtered properties

## Error Handling
- All SDK calls must handle CogniteAPIError
- Implement exponential backoff for rate limits
- Log errors with correlation IDs
- Never expose internal IDs in error messages
```

#### Real Example: CDF Data Pipeline Solution
```markdown
# Project Rules for AI Assistant - CDF Data Pipeline

## Technology Stack
- Cognite Python SDK 7.13.0 for CDF operations
- Apache Spark 3.5.0 for large-scale transformations
- Databricks Runtime 14.3 LTS
- Delta Lake for data storage
- GitHub Actions for CI/CD
- Cognite Functions for serverless compute
- Great Expectations for data quality

## Pipeline Architecture Standards
- RAW databases follow pattern: `raw_{source_system}`
  - Example: `raw_sap`, `raw_pi`, `raw_scada`
- Staging pattern: RAW → Staging → Core
- Data lineage tracking via CDF Datasets
- Idempotent operations (safe to re-run)
- Checkpoint-based processing for reliability

## Transformation Patterns
- Cognite Transformations structure:
  ```yaml
  transformations/
    01_raw_to_staging/
      assets_transformation.sql
      timeseries_transformation.sql
    02_staging_to_core/
      asset_hierarchy.sql
      relationships.sql
    03_data_quality/
      validation_checks.sql
  ```
- Use MERGE for upsert operations
- Window functions for time-based calculations
- CTEs for complex transformations
- Parameterized queries with Jinja2 templates

## Data Quality Standards
- Implement quality gates at each stage:
  1. Schema validation on RAW ingestion
  2. Business rule validation in staging
  3. Referential integrity in core
- Quality metrics to track:
  - Completeness: % of non-null required fields
  - Uniqueness: Duplicate detection
  - Timeliness: Data freshness checks
  - Accuracy: Range and format validation

## CDF Functions Patterns
- Function naming: `{purpose}_{source}_{target}`
  - Example: `ingest_sap_assets`, `calculate_oee_metrics`
- Standard function structure:
  ```python
  def handle(client: CogniteClient, data: dict) -> dict:
      # Input validation
      # Business logic
      # Error handling
      # Return status
  ```
- Environment variables for configuration
- Structured logging with correlation IDs
- Timeout handling for long-running operations

## Time Series Ingestion
- Batch size: 100,000 data points per request
- Use async operations for parallel ingestion
- Implement backpressure handling
- Data point validation:
  - Timestamp within reasonable range
  - Value within expected bounds
  - No duplicate timestamps
- Aggregation patterns for downsampling

## Monitoring & Alerting
- Log all transformation runs to CDF Events
- Track metrics:
  - Records processed
  - Processing time
  - Error rates
  - Data quality scores
- Alert thresholds:
  - Failed transformations
  - Data quality below 95%
  - Processing time > 2x average

## Error Recovery
- Implement circuit breaker pattern
- Dead letter queues for failed records
- Automatic retry with exponential backoff
- Manual intervention workflows
- Rollback procedures for critical failures
```

#### Real Example: CDF InField Inspector App
```markdown
# Project Rules for AI Assistant - CDF InField Mobile App

## Technology Stack
- React Native 0.73.2 with TypeScript 5.3.3
- Cognite React Components 6.2.0
- Cognite SDK JS 9.13.0 for CDF access
- React Navigation 6.x for navigation
- Redux Toolkit for offline state management
- React Native MMKV for secure storage
- Mapbox for asset location display
- React Native Camera for inspection photos

## CDF Integration Patterns
- Authentication via Cognite OAuth2
- Project configuration:
  ```typescript
  const client = new CogniteClient({
    appId: 'cdf-infield-inspector',
    project: process.env.CDF_PROJECT,
    baseUrl: process.env.CDF_CLUSTER,
    authentication: {
      type: 'OIDC',
      options: { /* OIDC config */ }
    }
  });
  ```
- Offline-first architecture with sync queue
- Cache CDF resources locally for offline access

## Asset Inspection Workflow
- Load asset hierarchy from CDF
- Display asset 360 images and documents
- Create inspection events:
  ```typescript
  interface InspectionEvent {
    externalId: string;
    type: 'inspection';
    subtype: 'routine' | 'corrective' | 'preventive';
    assetIds: number[];
    startTime: Date;
    endTime: Date;
    metadata: {
      inspector: string;
      findings: Finding[];
      photos: FileReference[];
    };
  }
  ```

## Offline Capabilities
- Download asset data for offline routes
- Queue all CDF operations when offline
- Sync strategy:
  1. Store operations in MMKV queue
  2. Retry with exponential backoff
  3. Handle conflicts with server data
  4. Notify user of sync status
- Maximum offline storage: 500MB

## 3D Model Integration
- Use Cognite 3D Web Viewer
- Support for CAD and point cloud models
- Highlight equipment in 3D view
- Link 3D positions to assets:
  ```typescript
  const assetMapping3D = {
    nodeId: model.nodeId,
    assetId: asset.id,
    boundingBox: {...}
  };
  ```

## Time Series Display
- Show last 24 hours by default
- Support for multiple series overlay
- Gesture-based zoom and pan
- Offline caching of recent data
- Aggregation for performance:
  ```typescript
  const datapoints = await client.timeseries.data.retrieve({
    items: [{ id: timeseriesId }],
    start: '24h-ago',
    aggregates: ['average'],
    granularity: '1h'
  });
  ```

## Work Order Integration
- Create work orders from findings
- Link to maintenance system
- Required fields:
  - Asset reference
  - Priority level
  - Description with photos
  - Estimated completion
- Status tracking and updates

## Performance Requirements
- Asset list loading < 2 seconds
- 3D model initial load < 10 seconds
- Support 10,000+ assets in hierarchy
- Smooth 60fps scrolling
- Image upload with compression
- Background sync without UI blocking

## Security Standards
- Biometric authentication for app access
- Encrypted local storage for sensitive data
- Certificate pinning for CDF endpoints
- Session timeout after 15 minutes
- Audit trail for all inspections
- GDPR compliance for personal data
```

### 2. Feature-Level Context

#### Example: CDF Asset Hierarchy Feature
When working on asset hierarchy management, provide these contexts:

**Open Files:**
```yaml
# @file:config/modules/asset_monitoring/containers/Pump.container.yaml
apiVersion: v1
kind: Container
metadata:
  externalId: Pump
  name: Pump
  description: Container for pump assets with operational data
spec:
  usedFor: node
  properties:
    flowRate:
      type: float64
      description: Current flow rate in m3/h
    pressure:
      type: float64  
      description: Operating pressure in bar
    efficiency:
      type: float64
      description: Pump efficiency percentage
    lastMaintenance:
      type: timestamp
      description: Last maintenance date
    mtbf:
      type: float64
      description: Mean time between failures in hours
```

```python
# @file:src/transformations/asset_hierarchy.py
from cognite.client import CogniteClient
from cognite.client.data_classes import Asset
from typing import List, Dict

def build_asset_hierarchy(
    client: CogniteClient,
    source_data: List[Dict]
) -> List[Asset]:
    """Build asset hierarchy from source system data.
    
    Args:
        client: CogniteClient instance
        source_data: Raw asset data from source system
        
    Returns:
        List of Asset objects ready for upload
    """
    assets = []
    
    # Create asset mapping for parent-child relationships
    asset_map = {item['TAG']: item for item in source_data}
    
    for item in source_data:
        asset = Asset(
            external_id=f"sap:{item['TAG']}",
            name=item['DESCRIPTION'],
            parent_external_id=f"sap:{item['PARENT_TAG']}" if item.get('PARENT_TAG') else None,
            metadata={
                'source': 'SAP',
                'equipmentType': item['EQUIPMENT_TYPE'],
                'location': item['LOCATION'],
                'criticality': item['CRITICALITY']
            },
            labels=[item['EQUIPMENT_TYPE'], item['LOCATION']]
        )
        assets.append(asset)
    
    return assets
```

```yaml
# @file:config/modules/asset_monitoring/views/Pump.view.yaml
apiVersion: v1
kind: View
metadata:
  externalId: Pump
  name: Pump
  description: View for pump assets with relationships and time series
spec:
  implements:
    - type: view
      space: cdf_cdm
      externalId: CogniteAsset
      version: v1
  properties:
    # Inherited from CogniteAsset
    name:
      container:
        space: cdf_cdm
        externalId: CogniteAsset
      containerPropertyIdentifier: name
    # Custom pump properties  
    flowRate:
      container:
        externalId: Pump
      containerPropertyIdentifier: flowRate
    pressure:
      container:
        externalId: Pump
      containerPropertyIdentifier: pressure
  # Time series links
  timeSeries:
    - source: pi
      pattern: "pi:pump:{{externalId}}:flow_rate"
      property: flowRate
    - source: pi
      pattern: "pi:pump:{{externalId}}:pressure"
      property: pressure
```

#### Example: CDF Maintenance Management Feature
**Context Setup for Maintenance Workflow:**

```yaml
# @file:config/modules/maintenance/containers/MaintenanceOrder.container.yaml
apiVersion: v1
kind: Container
metadata:
  externalId: MaintenanceOrder
  name: MaintenanceOrder
  description: Container for maintenance work orders
spec:
  usedFor: node
  properties:
    orderNumber:
      type: text
      description: SAP work order number
    orderType:
      type: text
      description: Type of maintenance (PM01, PM02, PM03)
    priority:
      type: int32
      description: Priority level (1-5)
    plannedStart:
      type: timestamp
      description: Planned start date
    plannedEnd:
      type: timestamp
      description: Planned completion date
    actualStart:
      type: timestamp
      nullable: true
    actualEnd:
      type: timestamp
      nullable: true
    status:
      type: text
      description: Current status (CRTD, REL, TECO, CLSD)
    cost:
      type: float64
      nullable: true
      description: Total cost in USD
```

```python
# @file:src/functions/maintenance_analytics.py
from cognite.client import CogniteClient
from cognite.client.data_classes import Event
from datetime import datetime, timedelta
import pandas as pd

def calculate_maintenance_kpis(
    client: CogniteClient,
    asset_ids: List[int],
    start_date: datetime,
    end_date: datetime
) -> Dict[str, float]:
    """Calculate maintenance KPIs for assets.
    
    Args:
        client: Cognite client instance
        asset_ids: List of asset IDs to analyze
        start_date: Start of analysis period
        end_date: End of analysis period
        
    Returns:
        Dictionary of KPI values
    """
    # Fetch maintenance events
    events = client.events.list(
        asset_ids=asset_ids,
        type="maintenance",
        start_time={"min": start_date, "max": end_date},
        limit=None
    )
    
    # Convert to DataFrame for analysis
    df = pd.DataFrame([
        {
            'asset_id': e.asset_ids[0],
            'type': e.subtype,
            'duration': (e.end_time - e.start_time) / 3600000,  # hours
            'cost': e.metadata.get('cost', 0)
        }
        for e in events if e.end_time
    ])
    
    # Calculate KPIs
    kpis = {
        'mttr': df.groupby('asset_id')['duration'].mean().mean(),  # Mean Time To Repair
        'maintenance_cost': df['cost'].sum(),
        'preventive_ratio': len(df[df['type'] == 'preventive']) / len(df),
        'emergency_ratio': len(df[df['type'] == 'corrective']) / len(df)
    }
    
    return kpis
```

```sql
-- @file:transformations/maintenance_order_transformation.sql
-- Transform SAP PM orders to CDF maintenance events
SELECT
  node_reference('MaintenanceOrder', concat('sap:pm:', AUFNR)) as id,
  'maintenance' as type,
  CASE 
    WHEN AUART = 'PM01' THEN 'preventive'
    WHEN AUART = 'PM02' THEN 'corrective'
    WHEN AUART = 'PM03' THEN 'emergency'
    ELSE 'other'
  END as subtype,
  KTEXT as description,
  GSTRP as startTime,
  GETRI as endTime,
  array(node_reference('Asset', concat('sap:', TPLNR))) as assetIds,
  to_json(object(
    'orderNumber', AUFNR,
    'priority', PRIOK,
    'status', STTXT,
    'cost', ACTUAL_COST,
    'plannedCost', PLANNED_COST,
    'technician', RESPONSIBLE
  )) as metadata
FROM 
  `raw_sap`.`pm_orders`
WHERE
  AUFNR IS NOT NULL
  AND GSTRP >= CURRENT_TIMESTAMP - INTERVAL '90 days'
```

#### Example: CDF Time Series Analytics Feature
**Context for Time Series Processing:**

```python
# @file:src/analytics/time_series_processor.py
from cognite.client import CogniteClient
from cognite.client.data_classes import TimeSeries, DatapointsList
from typing import List, Dict, Tuple
import numpy as np
import pandas as pd

class TimeSeriesAnalyzer:
    def __init__(self, client: CogniteClient):
        self.client = client
        self.aggregation_methods = ['average', 'min', 'max', 'sum', 'count']
        
    async def calculate_asset_oee(
        self,
        asset_external_id: str,
        start_time: str,
        end_time: str
    ) -> Dict[str, float]:
        """Calculate Overall Equipment Effectiveness (OEE) for an asset.
        
        OEE = Availability × Performance × Quality
        
        Args:
            asset_external_id: External ID of the asset
            start_time: Start of calculation period
            end_time: End of calculation period
            
        Returns:
            Dictionary with OEE components and overall score
        """
        # Define time series external IDs
        ts_mapping = {
            'runtime': f'pi:{asset_external_id}:runtime:hours',
            'planned_runtime': f'pi:{asset_external_id}:planned_runtime:hours',
            'actual_output': f'pi:{asset_external_id}:production:units',
            'target_output': f'pi:{asset_external_id}:target_production:units',
            'good_units': f'pi:{asset_external_id}:good_units:count',
            'total_units': f'pi:{asset_external_id}:total_units:count'
        }
        
        # Fetch all required time series
        datapoints = self.client.time_series.data.retrieve(
            external_id=list(ts_mapping.values()),
            start=start_time,
            end=end_time,
            aggregates=['sum'],
            granularity='1d'
        )
        
        # Calculate OEE components
        availability = self._calculate_availability(datapoints)
        performance = self._calculate_performance(datapoints)
        quality = self._calculate_quality(datapoints)
        
        return {
            'availability': availability,
            'performance': performance,
            'quality': quality,
            'oee': availability * performance * quality,
            'calculation_period': f'{start_time} to {end_time}'
        }
```

```yaml
# @file:config/functions/oee_calculator.function.yaml
apiVersion: v1
kind: CogniteFunction
metadata:
  externalId: calculate_oee_daily
  name: Daily OEE Calculator
  description: Calculate OEE metrics for all production assets
spec:
  runtime: python39
  handler: handler.main
  schedule:
    cronExpression: "0 2 * * *"  # Run daily at 2 AM UTC
  env:
    - name: AGGREGATION_WINDOW
      value: "24h"
    - name: ASSET_FILTER
      value: "type:production_line"
  secrets:
    - name: CDF_PROJECT
      value: my-project
  cpu: 0.5
  memory: 512
  timeout: 300
```

```python
# @file:src/transformations/time_series_aggregation.py
import pandas as pd
from cognite.client.data_classes import TimeSeriesUpdate
from typing import List

def create_aggregated_timeseries(
    client: CogniteClient,
    source_ts_id: str,
    target_ts_external_id: str,
    aggregation: str = 'average',
    granularity: str = '1h'
) -> TimeSeries:
    """Create aggregated time series for performance optimization.
    
    Args:
        client: CogniteClient instance
        source_ts_id: Source time series ID
        target_ts_external_id: External ID for aggregated series
        aggregation: Aggregation method
        granularity: Time granularity
        
    Returns:
        Created aggregated time series
    """
    # Get source time series metadata
    source_ts = client.time_series.retrieve(id=source_ts_id)
    
    # Create aggregated time series
    aggregated_ts = client.time_series.create(
        TimeSeries(
            external_id=target_ts_external_id,
            name=f"{source_ts.name} ({aggregation} per {granularity})",
            description=f"Aggregated {aggregation} values per {granularity}",
            asset_id=source_ts.asset_id,
            unit=source_ts.unit,
            metadata={
                **source_ts.metadata,
                'aggregation_method': aggregation,
                'aggregation_granularity': granularity,
                'source_timeseries': source_ts.external_id
            }
        )
    )
    
    # Set up continuous aggregation job
    client.transformations.create(
        external_id=f"aggregate_{target_ts_external_id}",
        name=f"Aggregate {source_ts.name}",
        query=f"""
        SELECT 
          date_trunc('{granularity}', timestamp) as timestamp,
          {aggregation}(value) as value
        FROM 
          timeseries('{source_ts.external_id}')
        GROUP BY 
          date_trunc('{granularity}', timestamp)
        """,
        destination={
            "type": "timeseries",
            "external_id": target_ts_external_id
        },
        schedule="0 * * * *"  # Run hourly
    )
    
    return aggregated_ts
```

### 3. Task-Level Context

#### Example: Implementing Asset Search in CDF
```markdown
I need to implement an asset search feature using CDF that:

**Functional Requirements:**
- Search across asset name, description, and metadata fields
- Support fuzzy matching for equipment tags (e.g., "P101" matches "P-101")
- Filter by asset type, location, criticality, and status
- Include parent/child assets in results optionally
- Search within specific asset subtrees
- Support saved search queries per user

**CDF Integration Requirements:**
- Use CDF search API with proper query syntax
- Implement search across multiple asset properties:
  ```python
  search_filter = {
      "search": {
          "name": search_term,
          "description": search_term
      },
      "filter": {
          "labels": {"containsAny": selected_labels},
          "metadata": {"location": location_filter}
      }
  }
  ```
- Handle pagination with cursor-based navigation
- Respect user's access permissions (capability-based filtering)

**Performance Requirements:**
- Search results return in < 500ms for up to 10,000 assets
- Implement client-side caching of recent searches
- Use CDF's search suggestions endpoint for autocomplete
- Batch API requests when fetching related assets

**UI Requirements:**
- Display asset hierarchy in tree view
- Show asset preview with key metadata
- Highlight matching terms in results
- Include asset type icons and criticality indicators
- Export search results to CSV/Excel

**Acceptance Criteria:**
- [ ] Search works across all indexed asset properties
- [ ] Filters correctly narrow results
- [ ] Performance meets targets with large asset hierarchies
- [ ] Search history persists across sessions
- [ ] Results respect data access permissions
- [ ] Export includes all relevant asset metadata
```

#### Example: Debugging CDF Query Performance
```markdown
I'm experiencing slow asset hierarchy loading in our CDF application:

**Current Behavior:**
- Asset tree takes 15-20 seconds to load for facility with 5,000 assets
- CDF API calls show high latency (3-5 seconds per request)
- Browser freezes when expanding large asset nodes
- Memory usage spikes to 1.5GB when loading full hierarchy

**Expected Behavior:**
- Initial load should complete in < 3 seconds
- Smooth expansion of asset nodes without UI freeze
- Incremental loading of child assets
- Memory usage under 300MB

**What I've Checked:**
- Using latest Cognite SDK version (7.13.0)
- API requests include proper projections to limit fields
- Implemented pagination with 1000 items per request
- Network latency to CDF cluster is normal (< 50ms)

**Current Implementation:**
```python
# Loading entire hierarchy at once
assets = client.assets.list(
    asset_subtree_ids=[root_asset_id],
    limit=None  # This might be the issue
)
```

**Environment:**
- Cognite Python SDK 7.13.0
- CDF Project: acme-production
- Asset count: ~50,000 total, ~5,000 in this facility
- Running from Azure East US, CDF cluster in Europe

**Code Context:**
@file:src/services/asset_service.py (asset loading logic)
@file:src/components/AssetTree.tsx (React component)
@file:src/hooks/useAssetHierarchy.ts (data fetching hook)
```

#### Example: CDF Events Integration Task
```markdown
Implement event tracking system for equipment failures in CDF:

**Integration Requirements:**
- Create events in CDF for all equipment failures
- Link events to affected assets and work orders
- Include root cause analysis data in event metadata
- Support batch event creation for historical data import
- Integrate with notification system for critical events

**Event Schema:**
```python
event = Event(
    external_id=f"failure:{asset_id}:{timestamp}",
    type="equipment_failure",
    subtype=failure_category,  # mechanical, electrical, instrumentation
    description=failure_description,
    asset_ids=[affected_asset_id],
    start_time=failure_start,
    end_time=failure_end,
    metadata={
        "severity": "critical|high|medium|low",
        "root_cause": root_cause_code,
        "detection_method": "sensor|inspection|operator",
        "downtime_hours": downtime_duration,
        "production_loss": units_lost,
        "repair_cost": estimated_cost
    }
)
```

**Data Quality Requirements:**
- Validate asset IDs exist before creating events
- Ensure start_time < end_time
- Require minimum metadata fields for analysis
- Check for duplicate events (same asset + time)
- Validate against business rules (e.g., severity thresholds)

**Performance Requirements:**
- Batch create up to 1000 events per API call
- Process historical data (100k+ events) within 1 hour
- Real-time event creation latency < 1 second
- Support concurrent event streams from multiple sources

**Integration Points:**
- Pull failure data from maintenance system (SAP PM)
- Trigger notifications via CDF Functions
- Update asset metadata with failure counts
- Generate KPI metrics for dashboards

**Testing Requirements:**
- Unit tests for event validation logic
- Integration tests with CDF SDK
- Load tests for batch import performance
- End-to-end test including notifications
```

## 📈 Benefits of Context Engineering

### Reduced Refactoring
When AI assistants understand project architecture upfront, developers report **60-80% reduction** in manual code refactoring time.

### Accelerated Debugging
With system-level context, debugging shifts from reactive symptom-chasing to proactive root-cause analysis.

### Enhanced Consistency
Centralized context ensures all developers and AI assistants build to the same standards, leading to more uniform, maintainable codebases.

### Improved Onboarding
New team members can leverage the same context as experienced developers, accelerating their productivity.

## 🔄 The Virtuous Cycle

Context engineering creates a positive feedback loop:

1. **Better Documentation** → Forces teams to codify implicit knowledge
2. **Better AI Output** → AI produces code that adheres to standards
3. **Better Developer Adherence** → All developers follow established patterns
4. **Better Failure Analysis** → Structured analysis identifies context gaps
5. **Even Better Documentation** → Continuous improvement of shared knowledge

## 🎯 Best Practices

### Start Simple
Begin with basic project-level context in `.cursor/rules.md` and gradually expand as needed.

### Be Specific
Include concrete examples, not just abstract principles. Show the AI exactly what you want.

### Keep Current
Regularly update context as your project evolves. Outdated context is worse than no context.

### Validate Results
Monitor AI outputs and refine context based on what works and what doesn't.

### Share Knowledge
Make context engineering a team practice. Share successful patterns and learn from failures.

## 📊 Before/After: The Context Impact

### Without Context: Generic, Error-Prone Output

**Prompt**: "Create a function to fetch asset data"

**AI Output** (without context):
```python
def get_asset_data(asset_id):
    # Generic implementation
    response = requests.get(f"https://api.example.com/assets/{asset_id}")
    return response.json()
```

❌ **Problems**:
- No CDF SDK usage
- No error handling
- No authentication
- No type hints
- Doesn't follow project patterns

### With Context: Production-Ready Code

**Same Prompt** with proper context:

**AI Output** (with context):
```python
from typing import Optional, List, Dict
from cognite.client import CogniteClient
from cognite.client.data_classes import Asset
from cognite.client.exceptions import CogniteAPIError
import logging
from src.config import get_cdf_client
from src.utils.retry import exponential_backoff

logger = logging.getLogger(__name__)

@exponential_backoff(max_retries=3)
async def get_asset_with_hierarchy(
    asset_external_id: str,
    include_subtree: bool = False,
    client: Optional[CogniteClient] = None
) -> Optional[Asset]:
    """Fetch asset data with optional subtree from CDF.
    
    Args:
        asset_external_id: External ID of the asset to fetch
        include_subtree: Whether to include all descendant assets
        client: Optional CogniteClient instance (uses default if None)
        
    Returns:
        Asset object with metadata and relationships
        
    Raises:
        CogniteAPIError: If asset not found or API error occurs
    """
    if not client:
        client = get_cdf_client()
    
    try:
        # Fetch main asset with optimized projection
        asset = client.assets.retrieve(
            external_id=asset_external_id,
            ignore_unknown_ids=False
        )
        
        if not asset:
            logger.warning(f"Asset not found: {asset_external_id}")
            return None
            
        # Optionally fetch subtree
        if include_subtree:
            subtree_assets = client.assets.list(
                asset_subtree_external_ids=[asset_external_id],
                limit=None
            )
            asset.subtree = subtree_assets
            
        logger.info(
            f"Successfully fetched asset: {asset.name}",
            extra={
                "asset_external_id": asset_external_id,
                "subtree_count": len(subtree_assets) if include_subtree else 0
            }
        )
        
        return asset
        
    except CogniteAPIError as e:
        logger.error(
            f"Failed to fetch asset: {asset_external_id}",
            extra={"error": str(e), "code": e.code}
        )
        raise
```

✅ **Improvements**:
- Uses Cognite SDK properly
- Comprehensive error handling
- Follows project logging standards
- Includes retry logic
- Type hints throughout
- Proper documentation
- Performance optimizations

## 🤝 Team Collaboration Strategies

### Shared Context Repository

Create a centralized context repository that all team members contribute to:

```
team-context/
├── .cursor/
│   ├── rules.md                    # Main project rules
│   ├── rules.backend.md            # Backend-specific rules
│   ├── rules.frontend.md           # Frontend-specific rules
│   └── rules.data-pipeline.md     # Data pipeline rules
├── examples/
│   ├── asset-hierarchy/            # Example implementations
│   ├── time-series-processing/
│   └── transformations/
├── templates/
│   ├── function-template.py
│   ├── transformation-template.sql
│   └── container-template.yaml
└── docs/
    ├── patterns.md                 # Documented patterns
    └── anti-patterns.md           # What to avoid
```

### Context Review Process

1. **Context Pull Requests**: Treat context updates like code
   ```bash
   git checkout -b update/context-maintenance-patterns
   # Edit .cursor/rules.md
   git add .cursor/rules.md
   git commit -m "feat(context): add maintenance event patterns"
   git push origin update/context-maintenance-patterns
   ```

2. **Weekly Context Sync**: Team meeting agenda
   - Review AI output failures
   - Identify missing context
   - Update rules collaboratively
   - Share successful patterns

3. **Context Ownership**: Assign domain experts
   - Data Models: Data Architect owns model patterns
   - Transformations: Data Engineer owns SQL patterns
   - Functions: Backend Lead owns Python patterns
   - Security: Security Lead owns access patterns

### Knowledge Sharing Workflows

```yaml
# .github/workflows/context-validation.yml
name: Validate Context Updates

on:
  pull_request:
    paths:
      - '.cursor/**'
      - 'team-context/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Validate Markdown Syntax
        run: |
          npm install -g markdownlint-cli
          markdownlint .cursor/rules.md
          
      - name: Check for Placeholders
        run: |
          if grep -r "TODO\|FIXME\|<REPLACE_ME>" .cursor/; then
            echo "Found uncommitted placeholders"
            exit 1
          fi
          
      - name: Validate Code Examples
        run: |
          python scripts/validate_context_examples.py
```

## 🔧 Troubleshooting Common Context Issues

### Issue: AI Ignores Project Context

**Symptoms**: AI generates generic code despite `.cursor/rules.md`

**Solutions**:
1. **Check file location**: Must be exactly `.cursor/rules.md` in project root
2. **Verify file detection**:
   ```bash
   ls -la .cursor/rules.md
   # Should show file with content
   ```
3. **Test with explicit reference**:
   ```
   Following our project rules in .cursor/rules.md, create a function to...
   ```
4. **Restart Cursor IDE**: Sometimes requires fresh context load

### Issue: Inconsistent AI Outputs

**Symptoms**: Same prompt gives different styles/patterns

**Solutions**:
1. **Add concrete examples**:
   ```markdown
   ## Good Example
   ```python
   def calculate_oee(asset_id: str) -> float:
       """ALWAYS include docstrings like this."""
       pass
   ```
   
   ## Bad Example  
   ```python
   def calc_oee(id):  # NO: Missing types and docstring
       pass
   ```
   ```

2. **Use explicit constraints**:
   ```markdown
   ## MANDATORY Rules
   - ALWAYS use type hints
   - NEVER use print() - use logger instead
   - ALWAYS handle CogniteAPIError
   ```

### Issue: Context Too Large/Slow

**Symptoms**: AI responses are slow or incomplete

**Solutions**:
1. **Split context by domain**:
   ```
   .cursor/
   ├── rules.md          # Core rules only (< 1000 lines)
   ├── examples.md       # Separate examples file
   └── domain/
       ├── assets.md     # Asset-specific rules
       └── timeseries.md # Time series rules
   ```

2. **Use context hierarchy**:
   ```markdown
   # Core Rules (Always Active)
   Essential patterns here...
   
   # Extended Rules (Reference when needed)
   See .cursor/domain/specific-feature.md
   ```

### Issue: Conflicting Team Patterns

**Symptoms**: Different team members' code conflicts

**Solutions**:
1. **Version control context**:
   ```bash
   git log -p .cursor/rules.md  # Review context history
   ```

2. **Context linting**:
   ```python
   # scripts/lint_context.py
   def check_context_conflicts(file_path):
       rules = parse_rules(file_path)
       conflicts = find_contradictions(rules)
       if conflicts:
           raise ContextConflictError(conflicts)
   ```

## 🚀 Getting Started

1. **Create `.cursor/rules.md`** in your project root
2. **Use a context template** (see below) as starting point
3. **Document your tech stack** and coding standards
4. **Include real examples** from your codebase
5. **Test and iterate** based on AI outputs
6. **Share with team** via version control

## 📋 Context Templates for Different Domains

### CDF Data Modeling Context Template
```markdown
# CDF Data Modeling Project Context

## Project Overview
- **Project**: [Project Name]
- **CDF Project**: [CDF project name]
- **Data Space**: sp_[project_identifier]
- **Purpose**: [Brief description]

## Data Model Standards
- Extend Cognite Core Data Model (CDM) v1
- Use containers for data storage
- Use views for data consumption
- Implement proper inheritance hierarchies

## Naming Conventions
- Containers: PascalCase (e.g., `PumpStation`)
- Views: PascalCase matching container
- Properties: camelCase (e.g., `maxFlowRate`)
- External IDs: snake_case (e.g., `pump_station_01`)

## Required Properties
All business objects must include:
- `name` (inherited from CDM)
- `sourceId` (reference to source system)
- `sourceUpdatedTime` (last update in source)
- `validityStatus` (active|inactive|deleted)

## Relationship Patterns
[Include your specific patterns]

## Example Implementation
[Include a complete example]
```

### CDF Functions Context Template
```markdown
# CDF Functions Project Context

## Function Standards
- Python 3.11 runtime
- Use Cognite Function handler pattern
- Include comprehensive error handling
- Return structured responses

## Handler Pattern
```python
def handle(client: CogniteClient, data: dict, secrets: dict) -> dict:
    """Standard function handler.
    
    Args:
        client: Authenticated CogniteClient
        data: Input parameters
        secrets: Environment secrets
        
    Returns:
        Structured response dict
    """
    try:
        # Implementation
        return {"status": "success", "result": result}
    except Exception as e:
        logger.error(f"Function failed: {e}")
        return {"status": "error", "error": str(e)}
```

## Deployment Configuration
[Include your deployment patterns]
```

### CDF Transformations Context Template
```markdown
# CDF Transformations Project Context

## SQL Standards
- Use Spark SQL syntax
- Include NULL handling
- Use CTEs for readability
- Add comments for complex logic

## Transformation Patterns
- RAW to Staging: Data cleaning and validation
- Staging to Core: Business logic and relationships
- Core to Mart: Aggregations and reporting

## Node Reference Pattern
```sql
SELECT
  node_reference('ViewName', external_id) as id,
  property1,
  property2,
  node_reference('RelatedView', related_id) as relationshipName
FROM source_table
```

## Error Handling
[Include your error handling patterns]
```

### CDF InField App Context Template
```markdown
# CDF InField App Project Context

## Mobile App Architecture
- React Native with TypeScript
- Offline-first with sync queue
- Cognite SDK for all CDF operations
- Biometric authentication required

## Offline Patterns
- Cache asset hierarchies locally
- Queue mutations when offline
- Conflict resolution: Server wins
- Sync on connection restore

## UI/UX Standards
- Follow Cognite Design System
- Support iOS and Android patterns
- Minimum touch targets: 44pt
- Loading states for all async operations

## Performance Requirements
[Include your specific requirements]
```

## 📖 Next Steps

- **[Quick Start Guide](quickstart_context_engineering.md)** - Practical setup instructions
- **[Advanced Prompting](advanced_prompting.md)** - Combine context with sophisticated prompting
- **[AI Workflows](ai_workflows/index.md)** - Real-world implementation examples

## 🎯 Success Metrics

Track these metrics to measure context engineering success:

### Productivity Metrics
- **Time to Working Code**: 60-80% reduction after context implementation
- **Refactoring Required**: < 20% of AI-generated code needs changes
- **Review Comments**: 70% reduction in style-related PR comments
- **Onboarding Time**: New developers productive in 2-3 days vs 2-3 weeks

### Quality Metrics  
- **Code Consistency**: 95%+ adherence to patterns
- **Error Rates**: 50% reduction in common mistakes
- **Test Coverage**: AI generates tests meeting coverage requirements
- **Documentation**: 100% of generated code includes proper docs

### Team Metrics
- **Context Contributions**: Each team member contributes monthly
- **Pattern Reuse**: 80% of new code uses established patterns
- **Knowledge Sharing**: Weekly context improvements
- **Satisfaction**: Team reports higher confidence in AI tools

---

**Ready to implement context engineering?** Start with the **[Quick Start Guide](quickstart_context_engineering.md)** for immediate, practical steps.
