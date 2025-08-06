# Performance Optimization Guide

## Batching Strategies

Use chunks of 1000 for asset creation.

## Indexing

Add BTREE indexes on queried fields.

## Query Examples

Optimized GraphQL queries.

## RAW Partitioning

By time or category.

### Datapoint Limits

Max 100k per request.

### Code Example

```python
def batch_ingest(client, data):
    for chunk in chunks(data, 100000):
        client.datapoints.insert(chunk)
```
