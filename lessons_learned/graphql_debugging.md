# Best Practices for Debugging GraphQL Queries on Relational Data

This document outlines a systematic approach to troubleshooting GraphQL queries that unexpectedly return empty results, particularly when dealing with data models involving relationships (e.g., in Cognite Data Fusion).

## Principle: Empty Results in Deeply Nested Queries Often Point to Data Integrity Issues

When a GraphQL query traversing multiple levels of relationships (e.g., `Grandchild` -> `Child` -> `Parent`) returns no data, the root cause is frequently not the query syntax but a broken or missing link in the underlying data model's relationship chain.

### Symptom

- A syntactically correct GraphQL query for a deeply nested relationship returns an empty list.
- A query for a shallower part of the same relationship (e.g., `Grandchild` -> `Child`) successfully returns data.

### Example Scenario

Imagine a data model with three entity types: `A`, `B`, and `C`. `A` is a child of `B`, and `B` is a child of `C`. A query to find all `A` instances under a specific `C` instance might look something like this, traversing `C` -> `B` -> `A`. If this query returns empty, but a query for `A` instances under a specific `B` works, the problem likely lies in the `B` -> `C` relationship.

### Root Cause Analysis

The empty result set indicates that the relationship link between one level and the next is broken. In the example above, the `B` instances are not correctly linked to their parent `C` instances. The GraphQL query is valid, but since no `B` instances have a relationship with the specified `C`, the traversal fails to find any `A` instances.

### Systematic Troubleshooting Steps

To diagnose and resolve these issues, follow these steps in order:

1. **Validate the Shallowest Query Level**:
    - **Action**: Construct and run a query for the first level of the relationship (e.g., retrieve `Child` entities linked to a specific `Parent`).
    - **Purpose**: This confirms that the base of your query is working and that the initial relationship is correctly established in the data model. If this fails, the problem is at the first link in the chain.

2. **Inspect Source Data for Relationship Keys**:
    - **Action**: Directly examine the raw source data (e.g., in `.csv` files, databases, or staging areas). Look for the columns used to define relationships, such as `parentExternalId` or other foreign keys.
    - **Purpose**: Verify that the linking identifiers exist, are correctly populated, and match between the parent and child datasets. Missing or mismatched keys are a common cause of broken relationships.

3. **Analyze the Data Transformation Logic**:
    - **Action**: If the source data is correct, scrutinize the transformation pipeline (e.g., CDF Transformations) that populates the data model. Pay close attention to how relationship objects are constructed and how `source` and `target` external IDs are mapped.
    - **Purpose**: This is often where the error lies. The transformation might be failing to create the relationship instances correctly, even if the source data contains the necessary information. Check for logic errors, incorrect column mappings, or issues in handling data types.

4. **Examine GraphQL Debug and Tracing Information**:
    - **Action**: Check the `extensions` block or similar debugging output in the GraphQL response.
    - **Purpose**: While it may not pinpoint the exact missing data link, this output reveals how the backend (e.g., CDF) translates the GraphQL query into underlying filters and operations. It can help confirm whether your query's filters are being applied as you expect, providing clues about where the traversal is failing.
