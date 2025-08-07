# Cognite Toolkit YAML Standards

**Rule Type**: Auto Attached

**File Pattern**: \*.yaml OR \*\*/modules/

**Description**: Standards for YAML configs in Cognite Toolkit, emphasizing
naming and organization for scalable deployments.

## Key Principles

- Follow consistent naming with placeholders for abstraction (e.g.,
  `ds_{{resource}}_{{location}}`).
- Use nested directories for large modules to manage complexity.
- Include README.md in modules for context.
- Reference:
  [Cognite Toolkit YAML Reference](https://docs.cognite.com/cdf/deploy/cdf_toolkit/guides/modules/custom)

## Best Practices

1. **Naming Conventions**: Use patterns like `ep_src_{{resource}}_{{source}}`
   for pipelines; external IDs everywhere.
1. **Structure**: Nest as `modules/{{domain}}/{{submodule}}` for big projects.
1. **Deployment**: Validate with `cdf-tk deploy --dry-run`; integrate in CI/CD.
1. **AI Workflow**: Suggest nested structures and validation in generated YAML.

## Example Template

@toolkit_module_template.yaml

```yaml
- externalId: ds_{{resource}}_{{location}}
  description: '{{resource}} data from {{location}}'
# Nested example:
# modules/{{domain}}/
#   config.yaml
```
