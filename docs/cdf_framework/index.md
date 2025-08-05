# CDF Framework Overview

> A document-driven, AI-accelerated methodology for designing, generating, and
> operating Cognite Data Fusion (CDF) projects.

______________________________________________________________________

## Why a Top-Down, Document-Driven Approach?

- Starts with *business value* rather than technology, ensuring every data model
  serves a measurable goal.
- Creates a **shared vocabulary** between business SMEs and data engineers,
  reducing re-work and mis-alignment.
- Treats Markdown specifications as **living contracts** that AI tools can
  transform directly into executable IaC artifacts.
- Enables *progressive elaboration*: high-level principles first, then
  increasingly granular detail only where needed.

## End-to-End Flow

1. **Business Alignment** – Capture goals and constraints in
   [`Solution Design Principles`](../00_Solution_Design_Principles.md) through
   workshops with SMEs.
1. **Conceptual Modeling** – Co-create
   [`Conceptual Data Model Overview`](../01_Conceptual_Data_Model_Overview.md),
   mapping business concepts to CDF objects.
1. **Object Specifications** – Author one
   [`*_Specification.md`](../XX_Object_Specification_Template.md) file per
   concept (e.g., `Well_Specification.md`) to define properties, relationships,
   and validation rules.
1. **Master Specification Consolidation** – AI consolidates all JSON specs into
   `project_specification.json`, providing a single source of truth.
1. **Artifact Generation** – Using the Cognite **Python SDK** and **CDF
   Toolkit**, AI converts the master spec into YAML containers, views,
   transformations, and configuration files.
1. **Continuous Validation & Deployment** – GitHub Actions and Toolkit `dry-run`
   commands validate schema compliance before live deployment.
1. **Targeted Updates** – When a single object changes, rerun *Targeted
   Component Update* instructions to regenerate only affected artifacts.

## How the Pieces Fit Together

| Stage | Primary Artifact | AI Role | Cognite Tooling |
|-------|-----------------|---------|-----------------| | Strategy |
[Solution Design Principles](../00_Solution_Design_Principles.md) | Gap
detection, JSON conversion | — | | Conceptual Model |
[Conceptual Data Model Overview](../01_Conceptual_Data_Model_Overview.md) |
Relationship validation | — | | Detailed Specs |
[\*\_Specification.md](../XX_Object_Specification_Template.md) | Property/type
checks | — | | Master Spec | `project_specification.json` | Consolidation,
diffing | Python SDK | | IaC Generation | `*.yaml` files | Code synthesis | CDF
Toolkit | | Deployment | GitHub workflow | Automated tests |
`cognite toolkit apply` |

## Benefits

- **Traceability** – Every YAML line traces back to an explicit business
  requirement.
- **Repeatability** – Re-run generators at any time to reproduce the environment
  from scratch.
- **Speed** – AI automates boilerplate, freeing experts to focus on design
  decisions.
- **Quality** – Built-in validation scripts catch model drift, schema
  violations, and data-quality issues early.

## Downsides & Trade-offs

- **Up-Front Effort** – Requires disciplined documentation before any code is
  generated.
- **SME Availability** – Success hinges on timely input from business and data
  SMEs.
- **Learning Curve** – Teams must grasp both CDF concepts and the
  document-driven workflow.
- **Over-Specification Risk** – Excessive detail may slow iteration if not
  managed through targeted updates.
- **AI Dependence** – Poor-quality prompts or model hallucinations can introduce
  subtle errors; always run validation.

## When to Revisit the Model

- Business scope or KPIs change
- New data sources become available
- Performance or cost issues arise
- Governance or compliance requirements evolve

## Conclusion

The CDF Framework marries a top-down, business-first design philosophy with
AI-powered code generation. By treating structured Markdown documents as the
*source of truth*, teams can iterate quickly while maintaining governance,
traceability, and production-grade quality across the entire data-to-insight
pipeline.
