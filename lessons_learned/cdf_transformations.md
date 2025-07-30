# Best Practice: Creating Data Model Relationships in CDF Transformations

This document establishes the standard for creating robust relationships between data model instances (nodes/views) within Cognite Data Fusion (CDF). The key takeaway is to use the `node_reference()` function within SQL transformations that are managed and deployed as part of a Cognite Toolkit module.

## Context: Transformations within the Cognite Toolkit

In a typical CDF project, data modeling and transformation logic are not developed in isolation. They are managed as code within a version-controlled repository and deployed to CDF using a CI/CD pipeline powered by the **Cognite Toolkit**.

The Toolkit organizes resources (data models, transformations, etc.) into **modules**. A transformation is defined as a resource in a YAML file, which points to a corresponding `.sql` file containing the transformation logic.

**Example `transformation.yml` in a Toolkit module:**

```yaml
# externalId must be unique within the project
externalId: tra_transform_child_nodes_to_parent_nodes
name: Transform Child Nodes
destination:
  # This should be the externalId of the view you are writing to
  type: view
  externalId: 'sp_my_data_model:ChildNode'
  instanceSpace: '{{ instanceSpace }}'
query:
  # Path to the SQL file within the module directory
  file: transform_child_nodes.sql
action: upsert
# ... other configurations like authentication ...
```

The `node_reference()` function is used within the `transform_child_nodes.sql` file referenced above. Understanding this structure is key to making the technical details portable across projects.

---

## The Correct Method: `node_reference()`

The built-in `node_reference()` function is the correct and only recommended tool for establishing direct relationships between view instances.

### **Correct and Recommended Usage**

Always use the two-argument version to explicitly define the `space` and `externalId` of the node you are referencing.

**Example `transform_child_nodes.sql`:**

```sql
select
    externalId,
    -- This correctly and robustly creates the link to the parent node.
    -- '{{ instanceSpace }}' is a variable populated by the Toolkit from config.
    node_reference('{{ instanceSpace }}', parentExternalId) as parent,
    -- other fields for the ChildNode view...
    name
from
    `my_raw_db`.`child_nodes_table`
```

- **Why it's robust**: This syntax removes all ambiguity. It explicitly tells the transformation which `space` the parent node belongs to, ensuring the relationship is created correctly and reliably. This prevents the common issue of `space` resolving to `null`, which breaks the data model link.

## Common Pitfalls (Deprecated and Incorrect Methods)

To ensure consistency and data quality, avoid the following methods.

1. **`to_direct_relation()`**: This function does not exist in the CDF Spark SQL environment.
2. **`struct(...)`**: Using `struct('{{ instanceSpace }}' as space, ...)` is not a reliable or recommended way to create a relationship. It is an outdated pattern that should be refactored.
3. **`node_reference(externalId)` (Single Argument)**: This version is dangerously ambiguous. It relies on the transformation's context to infer the `space`, which can fail and result in a `[null, 'some_external_id']` reference, breaking the relationship.

## Actionable Summary & Governance

1. **Standardize on the Two-Argument `node_reference()`**: All CDF transformations creating relationships **must** use `node_reference('space', 'externalId')`.
2. **Manage Transformations with the Cognite Toolkit**: Define all transformations in `.yml` and `.sql` files within a version-controlled Toolkit module to ensure predictable, repeatable deployments.
3. **Audit Existing Projects**: Review existing transformation logic and refactor any instances of `struct()` or single-argument `node_reference()` to use the correct two-argument syntax.
