# CDF Troubleshooting Guide

## Common API Errors

- 429 Rate Limit: Implement backoff.

## Error Handling Patterns

```python
try:
    client.assets.create(asset)
except CogniteAPIError as e:
    logger.error(e)
```

## Transformation Debugging

Steps to inspect failed jobs.

### Error Decision Tree

```mermaid
graph TD
    A[Error Occurs] --> B{HTTP Code?}
    B -->|429| C[Rate Limit - Backoff]
    B -->|400| D[Bad Request - Check Params]
    B -->|500| E[Server Error - Retry]
```
