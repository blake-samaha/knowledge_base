# Python SDK Best Practices

**Rule Type**: Auto Attached

**File Pattern**: \*.py importing 'cognite.client'

**Description**: Secure and efficient use of Cognite Python SDK, with lessons
from production for error handling and scaling.

## Key Principles

- Prioritize OAuth authentication for security.
- Use batch methods for all operations to handle scale.
- Implement retries and pagination to manage rate limits and large queries.
- Reference:
  [Cognite Python SDK Docs](https://cognite-sdk-python.readthedocs-hosted.com/en/latest/)

## Best Practices

1. **Authentication**: Use `OAuthClientCredentials` or `OAuthInteractive`; avoid
   static tokens.
1. **Data Ingestion**: Batch with methods like
   `client.assets.create_hierarchy()`. Abstract IDs with variables (e.g.,
   `{{external_id}}`).
1. **Error Handling**: Wrap calls in try-except with exponential backoff—cuts
   costs by 50% in real projects.
1. **Querying**: Enforce `limit=None` with pagination for complete results.

## Example Template

@sdk_ingestion_template.py

```python
from cognite.client import CogniteClient, ClientConfig
from cognite.client.credentials import OAuthClientCredentials

creds = OAuthClientCredentials(...)
config = ClientConfig(...)
client = CogniteClient(config)

try:
    client.assets.create_hierarchy(assets=...)  # Batch example
except Exception as e:
    # Handle with retry logic
    pass
```
