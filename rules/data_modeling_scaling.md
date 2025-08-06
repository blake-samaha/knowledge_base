# Data Modeling Scaling Best Practices

**Rule Type**: Auto Attached

**File Pattern**: \*\*/models/*.yaml OR*.py containing 'DataModel'

**Description**: Guidelines for scaling data models in CDF, drawing from
real-world lessons on handling large datasets and ensuring portability.

## Key Principles

- Use abstract naming prefixes like `{{domain}}_{{entity}}` for spaces, views,
  and nodes to make models portable across projects.
- For large datasets (>1M nodes), always batch operations to avoid performance
  issues.
- Index frequently queried properties and limit edges to prevent query
  slowdowns.
- Reference:
  [Cognite Data Modeling Performance](https://docs.cognite.com/cdf/dm/dm_guides/dm_performance.html)

## Best Practices

1. **Naming Conventions**: Prefix external IDs with domain-specific placeholders
   (e.g., `sp_{{domain}}_{{space}}` for spaces) to ensure consistency and
   reusability.
1. **Batching for Scale**: Use SDK batch methods for node/edge creation. Avoid
   single-item inserts in loops.
1. **AI-Assisted Workflow**: When generating code, suggest paginated queries and
   backoff retries.

## Example Template

@batch_node_creation_template.py

```python
import cognite.client as cc

def create_nodes_batch(client: cc.CogniteClient, nodes: list[cc.data_modeling.NodeApply]):
    """Batch create nodes for scaling."""
    client.data_modeling.instances.apply(nodes=nodes, edges=[])
    # Add error handling and retries here
```

Apply this template in ingestion scripts for large models.

## Common Pitfalls to Avoid

- Overly deep hierarchies (>7 levels) – flatten where possible.
- Hard-coded IDs – always use variables for abstraction.
