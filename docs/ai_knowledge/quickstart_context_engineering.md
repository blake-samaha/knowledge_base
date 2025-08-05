# Quick-start: Context Engineering with Cursor

Get up and running with context engineering in Cursor IDE in under 10 minutes.
This guide provides immediate, practical steps to improve your AI-assisted
development workflow.

## 🎯 Before You Begin

### Prerequisites Checklist

- [ ] Cursor IDE installed (version 0.20+ recommended)
- [ ] Project repository initialized
- [ ] Basic understanding of your project structure
- [ ] 10 minutes for initial setup
- [ ] CDF project access (for CDF-specific setup)

## 🚀 5-Minute Setup

### Step 1: Create Your First Context File

Create a `.cursor/rules.md` file in your project root:

```bash
mkdir .cursor
touch .cursor/rules.md
```

### Step 2: Choose Your Project Type

<details>
<summary><b>🏭 Option A: CDF Data Pipeline Project</b></summary>

````markdown
# CDF Data Pipeline Project Rules

## Technology Stack
- Cognite Python SDK 7.13.0
- Python 3.11 with type hints
- Apache Spark 3.5 for transformations
- Pytest for testing
- GitHub Actions for CI/CD

## CDF Standards
- Project: my-cdf-project
- Cluster: api.cognitedata.com
- Data Space: sp_data_platform
- Naming: {source}:{type}:{identifier}

## Coding Standards
- Use type hints for all functions
- Follow PEP 8 with Black formatter
- Document with Google-style docstrings
- Handle CogniteAPIError explicitly
- Use async where possible

## Architecture Patterns
- RAW → Staging → Core data flow
- Idempotent transformations
- Batch operations (1000 items max)
- Exponential backoff for retries

## Example Pattern
```python
from cognite.client import CogniteClient
from cognite.client.data_classes import Asset
from typing import List
import logging

logger = logging.getLogger(__name__)

async def create_assets_batch(
    client: CogniteClient,
    assets: List[dict],
    data_set_id: int
) -> List[Asset]:
    """Create assets in CDF with proper error handling.

    Args:
        client: Authenticated CogniteClient
        assets: List of asset dictionaries
        data_set_id: Target dataset ID

    Returns:
        List of created Asset objects
    """
    try:
        asset_objects = [
            Asset(
                external_id=f"sap:{asset['TAG']}",
                name=asset['NAME'],
                data_set_id=data_set_id,
                metadata={
                    'source': 'SAP',
                    'lastUpdated': asset.get('CHANGED_DATE')
                }
            )
            for asset in assets
        ]

        return client.assets.create(asset_objects)

    except CogniteAPIError as e:
        logger.error(f"Failed to create assets: {e}")
        raise
````

````

</details>

<details>
<summary><b>📈 Option B: CDF Analytics Project</b></summary>

```markdown
# CDF Analytics Project Rules

## Technology Stack
- Cognite Python SDK 7.13.0
- Pandas 2.0+ for data analysis
- Plotly for visualizations
- Streamlit for dashboards
- Jupyter for exploration

## CDF Query Patterns
- Use projections to limit fields
- Implement pagination for large datasets
- Cache frequently accessed data
- Use aggregates for time series

## Analysis Standards
- Document all assumptions
- Include data quality checks
- Version control notebooks
- Export reusable functions

## Example Analysis Pattern
```python
import pandas as pd
from cognite.client import CogniteClient
from datetime import datetime, timedelta
import plotly.express as px

def analyze_equipment_performance(
    client: CogniteClient,
    asset_ids: List[int],
    days_back: int = 30
) -> pd.DataFrame:
    """Analyze equipment performance metrics."""

    # Fetch time series data
    end_time = datetime.now()
    start_time = end_time - timedelta(days=days_back)

    # Get relevant time series
    timeseries = client.time_series.list(
        asset_ids=asset_ids,
        limit=None
    )

    # Aggregate data
    aggregates = client.time_series.data.retrieve(
        external_id=[ts.external_id for ts in timeseries],
        start=start_time,
        end=end_time,
        aggregates=['average', 'min', 'max'],
        granularity='1h'
    )

    # Convert to DataFrame for analysis
    df = aggregates.to_pandas()

    # Calculate KPIs
    df['efficiency'] = (df['actual'] / df['target']) * 100
    df['availability'] = df['runtime'] / (24 * days_back)

    return df
````

````

</details>

<details>
<summary><b>📱 Option C: CDF InField App Project</b></summary>

```markdown
# CDF InField App Project Rules

## Technology Stack
- React Native 0.73 with TypeScript
- Cognite SDK JS 9.13.0
- React Navigation 6.x
- React Native Paper for UI
- Offline storage with MMKV

## Mobile-Specific Patterns
- Offline-first architecture
- Queue mutations when offline
- Sync on connection restore
- Handle auth token refresh
- Optimize for battery life

## CDF Mobile Integration
```typescript
import { CogniteClient } from '@cognite/sdk';
import NetInfo from '@react-native-community/netinfo';
import { MMKV } from 'react-native-mmkv';

const storage = new MMKV();

export class OfflineCDFClient {
  private client: CogniteClient;
  private syncQueue: any[] = [];

  constructor(config: ClientConfig) {
    this.client = new CogniteClient(config);
    this.setupOfflineHandling();
  }

  private setupOfflineHandling() {
    NetInfo.addEventListener(state => {
      if (state.isConnected && this.syncQueue.length > 0) {
        this.processSyncQueue();
      }
    });
  }

  async createAsset(asset: AssetInput): Promise<Asset> {
    const isOnline = await NetInfo.fetch().then(s => s.isConnected);

    if (!isOnline) {
      // Queue for later
      this.syncQueue.push({ type: 'CREATE_ASSET', data: asset });
      storage.set('syncQueue', JSON.stringify(this.syncQueue));
      return asset as Asset; // Optimistic response
    }

    return this.client.assets.create([asset])[0];
  }
}
````

```

</details>

### Step 3: Test Your Context
Open Cursor IDE and try a prompt specific to your project type:

**For CDF Data Pipeline:**
```

Create a function to fetch all pumps from CDF and enrich with maintenance data

```

**For CDF Analytics:**
```

Create an analysis function to calculate MTBF for equipment

```

**For CDF InField App:**
```

Create a component to display asset details with offline support

```

The AI should now generate code that follows your CDF-specific patterns.

## 🎯 Immediate Improvements

### Better Prompts with Context
**Before** (without context):
```

Write a function to handle user authentication

```

**After** (with context):
```

Write a function to handle user authentication that follows our project's
patterns:

- Use TypeScript with proper types
- Include error handling
- Follow our API structure
- Add JSDoc documentation

```

### Feature-Level Context
When working on a specific feature, open relevant files in your editor:

1. **Open related components** that the AI should reference
2. **Include API schemas** or data models
3. **Show existing patterns** you want to follow

### Task-Level Context
Be specific about your immediate goal:

```

I need to add a new field to the user profile form. The field should:

- Be called "phoneNumber"
- Accept international phone numbers
- Include validation
- Update the existing User interface
- Follow our form component patterns

````

## 📈 Quick Wins & Success Metrics

### Immediate Improvements (Day 1)

| Metric | Without Context | With Context | Improvement |
|--------|----------------|--------------|-------------|
| **Code Accuracy** | 45-60% | 85-95% | +40-50% |
| **Refactoring Time** | 20-30 min/feature | 5-10 min/feature | -60-80% |
| **Pattern Consistency** | 40% | 90%+ | +50% |
| **First-Try Success** | 30% | 75% | +45% |

### How to Measure Your Success

1. **Time Tracking**
   ```bash
   # Before context engineering
   Feature A: 2h (30m coding, 90m refactoring)

   # After context engineering
   Feature B: 45m (35m coding, 10m refactoring)
````

2. **Iteration Counter**

   - Track how many prompts needed per feature
   - Target: 1-2 iterations vs 4-5 without context

1. **Code Review Metrics**

   - Count style-related comments
   - Should drop by 70%+ with good context

## 🛠️ Advanced Setup

### Environment-Specific Context

Create different context files for different environments:

```bash
.cursor/
├── rules.md              # General project rules
├── rules.frontend.md     # Frontend-specific patterns
├── rules.backend.md      # Backend-specific patterns
└── rules.testing.md      # Testing patterns
```

### Team-Shared Context

Store context files in version control so the entire team benefits:

```bash
git add .cursor/rules.md
git commit -m "Add AI context rules for project standards"
```

### Context Validation

Regularly review and update your context:

- **Monthly**: Review and update technology stack
- **Weekly**: Add new patterns and examples
- **Daily**: Refine based on AI outputs

## 👥 Team Onboarding Checklist

### New Developer Setup (30 minutes)

#### Day 1: Context Basics

- [ ] Clone repository with `.cursor/rules.md`
- [ ] Read through project context file
- [ ] Install Cursor IDE and open project
- [ ] Try 3 simple prompts using context
- [ ] Compare outputs with existing code

#### Day 2: Feature Development

- [ ] Pick a simple feature to implement
- [ ] Use context-aware prompts
- [ ] Measure time to completion
- [ ] Get code review feedback
- [ ] Update context based on learnings

#### Day 3: Advanced Usage

- [ ] Create feature-specific context
- [ ] Use multiple context files
- [ ] Share successful prompts with team
- [ ] Contribute to context improvements

### Team Lead Checklist

#### Initial Setup

- [ ] Create comprehensive `.cursor/rules.md`
- [ ] Add project-specific examples
- [ ] Document unique patterns
- [ ] Set up version control
- [ ] Schedule context review meetings

#### Ongoing Maintenance

- [ ] Weekly: Review AI outputs for drift
- [ ] Bi-weekly: Update examples
- [ ] Monthly: Team retrospective
- [ ] Quarterly: Major context revision

## 🎯 Common Issues & Solutions

### Issue 1: AI Generates Generic Code

**Symptom**: Code doesn't follow project patterns

**Solution**:

````markdown
# Add to .cursor/rules.md

## IMPORTANT: Always follow these patterns

### ❌ Bad Example (DO NOT GENERATE):
```python
def get_data():
    return requests.get(url).json()
````

### ✅ Good Example (ALWAYS USE)

```python
from cognite.client import CogniteClient
from typing import Optional
import logging

logger = logging.getLogger(__name__)

def get_asset_data(
    client: CogniteClient,
    asset_id: int
) -> Optional[Asset]:
    """Fetch asset with proper error handling."""
    try:
        return client.assets.retrieve(id=asset_id)
    except CogniteAPIError as e:
        logger.error(f"Failed to fetch asset {asset_id}: {e}")
        return None
```

### Issue 2: Inconsistent Outputs

**Symptom**: Same prompt gives different styles

**Solution**: Add explicit constraints

```markdown
## MANDATORY Rules
- ALWAYS use type hints
- NEVER use print() - use logger
- ALWAYS handle CogniteAPIError
- MUST include docstrings
```

### Issue 3: Context Not Loading

**Symptom**: AI ignores your rules

**Diagnostic Steps**:

1. Check file location:

   ```bash
   ls -la .cursor/rules.md
   ```

1. Verify in Cursor:

   - Open Command Palette (Cmd/Ctrl + Shift + P)
   - Search "Reload Window"

1. Test with explicit reference:

   ```
   Following the rules in .cursor/rules.md, create...
   ```

## 🔍 Deep Dive: Performance Optimization

### Context File Size Management

```markdown
# Optimal Context Structure

## Critical Rules (Always Active) - Keep under 500 lines
- Core patterns
- Essential standards
- Must-follow rules

## Extended Context (Reference as needed) - Can be larger
- Detailed examples
- Edge cases
- Historical decisions
```

### Loading Performance

| Context Size | Load Time | AI Response Time | Recommendation |
|-------------|-----------|------------------|----------------| | < 1KB |
Instant | Fast | Minimum viable context | | 1-5KB | < 0.1s | Fast | Optimal for
most projects | | 5-10KB | < 0.5s | Slightly slower | Good for complex projects
| | > 10KB | > 1s | Noticeably slower | Split into multiple files |

### Multi-File Strategy

```bash
.cursor/
├── rules.md                 # Core rules (2KB)
├── examples/
│   ├── assets.md            # Asset examples (3KB)
│   ├── timeseries.md        # Time series examples (3KB)
│   └── transformations.md   # Transform examples (4KB)
└── architecture/
    ├── decisions.md         # ADRs and rationale (5KB)
    └── patterns.md          # Detailed patterns (5KB)
```

## 🎯 Next Steps by Experience Level

### Beginner (Weeks 1-2)

1. **Master Basic Context**

   - Complete 5-minute setup
   - Use context for 10 tasks
   - Track time savings
   - Share learnings with team

1. **Expand Context**

   - Add 5 real examples
   - Document 3 anti-patterns
   - Create domain-specific rules

### Intermediate (Weeks 3-4)

3. **Optimize Workflow**

   - Create feature templates
   - Build prompt library
   - Implement team standards
   - Measure quality metrics

1. **Advanced Patterns**

   - Multi-file contexts
   - Dynamic context loading
   - Custom workflows
   - Performance optimization

### Advanced (Month 2+)

5. **Scale Across Organization**
   - Standardize context patterns
   - Create governance process
   - Build shared libraries
   - Train other teams

## 🏆 Success Stories

### Team A: 75% Faster Feature Development

- **Context**: Comprehensive CDF patterns
- **Result**: 2-day features now take 4 hours
- **Key**: Detailed examples in context

### Team B: 90% Reduction in Bugs

- **Context**: Error handling patterns
- **Result**: Critical bugs nearly eliminated
- **Key**: Explicit anti-patterns

### Team C: 10x Faster Onboarding

- **Context**: Complete project rules
- **Result**: New devs productive in 2 days
- **Key**: Progressive context introduction

## 📖 Resources & Next Steps

### Essential Reading

- **[Context Engineering Deep Dive](context_engineering.md)** - Master the
  theory and advanced patterns
- **[Advanced Prompting](advanced_prompting.md)** - Combine context with
  sophisticated techniques
- **[AI Workflows](ai_workflows/index.md)** - Real-world CDF implementation
  examples
- **[ROI Taxonomy](includes/roi_taxonomy.md)** - Measure and justify your
  investment

### Quick Reference Cards

<details>
<summary><b>📋 Context Engineering Cheat Sheet</b></summary>

```markdown
# Quick Context Template

## Must Have
- Technology stack with versions
- Primary coding patterns
- Error handling approach
- 2-3 concrete examples

## Should Have
- Architecture decisions
- Performance requirements
- Security patterns
- Testing approach

## Nice to Have
- Historical context
- Migration guides
- Team preferences
- Future roadmap
```

</details>

<details>
<summary><b>🚀 Prompt Improvement Formula</b></summary>

```
1. Start with basic prompt
2. Add role: "As a CDF expert..."
3. Add context: "Following our patterns..."
4. Add constraints: "Must handle errors..."
5. Add examples: "Like this: ..."
6. Iterate based on output
```

</details>

### Community Resources

- [Cursor Documentation](https://cursor.sh/docs)
- [CDF Best Practices](https://docs.cognite.com/best-practices/)
- [Team Context Templates](./templates/)
- [Success Stories](./case-studies/)

______________________________________________________________________

**Ready to transform your development workflow?** Start with the 5-minute setup,
measure your improvements, and share your success story!
