# Security Framework for CDF Projects

## RBAC Patterns

Implement least-privilege access using CDF capabilities.

## OAuth2 Setup

Configure client credentials flow with Azure AD.

## YAML Group Templates

```yaml
kind: Group
spec:
  capabilities:
    - dataModelsAcl: [READ, WRITE]
```
