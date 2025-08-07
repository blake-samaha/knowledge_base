# AI Playbook: 07 - CI/CD Pipeline

This playbook provides a blueprint for a robust CI/CD pipeline that automates
the entire "docs-as-code" lifecycle. It orchestrates the previously defined
playbooks (`04`, `05`, `06`) into a cohesive workflow within GitHub Actions,
ensuring that every change is validated, translated, and deployed in a safe and
repeatable manner.

**Trigger:** A pull request is created or updated, targeting the `main` branch.\
**Goal:** To fully automate the validation, YAML generation, and deployment
process, enabling continuous delivery for the CDF project.

______________________________________________________________________

## 1. CI/CD Pipeline Vision

The pipeline is designed around a core principle: **the `main` branch is the
source of truth for production.** Any code merged into `main` should be
automatically deployed to the `prod` environment after passing all quality
gates. The `dev` environment is updated on every push to a feature branch.

______________________________________________________________________

## 2. GitHub Actions Workflow Example

Below is a complete `workflow.yaml` example that implements the full CI/CD
process.

```yaml
name: Docs-as-Code CI/CD Pipeline

on:
  push:
    branches:
      - main # Trigger production deployment on merge to main
      - 'feature/**' # Trigger development deployment on push to feature branches
  pull_request:
    branches:
      - main # Trigger validation on PRs to main

jobs:
  ################################################################
  # 1. VALIDATE KNOWLEDGE BASE (on Pull Requests)
  ################################################################
  validate:
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run Sanity Check (Playbook 04)
        id: sanity_check
        run: |
          # This script executes the logic from 04_SANITY_CHECK.md
          python tools/run_sanity_check.py
          # The script must exit with a non-zero code on failure

      - name: Comment on PR with status
        if: failure()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '❌ Knowledge Base validation failed. Please fix the inconsistencies before merging.'
            })

  ################################################################
  # 2. DEPLOY TO DEVELOPMENT (on push to feature branches)
  ################################################################
  deploy-dev:
    needs: validate # Only run if validation on the PR passed
    if: github.event_name == 'push' && startsWith(github.ref, 'refs/heads/feature/')
    runs-on: ubuntu-latest
    environment: development
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Generate Toolkit YAML (Playbook 05)
        run: |
          # This script executes the logic from 05_TOOLKIT_YAML_SYNC.md
          python tools/run_yaml_sync.py --output-dir cognite_toolkit_configs/

      - name: Deploy to Dev Environment (Playbook 06)
        run: |
          # This script executes the logic from 06_ENVIRONMENT_PROMOTION.md
          cognite-toolkit apply \
            --project ${{ secrets.CDF_PROJECT }} \
            --env dev \
            --module-path cognite_toolkit_configs/ \
            --yes

  ################################################################
  # 3. DEPLOY TO PRODUCTION (on merge to main)
  ################################################################
  deploy-prod:
    needs: validate # Ensure validation passed on the PR before it was merged
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production # Requires manual approval gate in GitHub settings
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Generate Toolkit YAML (Playbook 05)
        run: |
          python tools/run_yaml_sync.py --output-dir cognite_toolkit_configs/

      - name: Generate Deployment Plan for Prod (Diff)
        run: |
          cognite-toolkit diff \
            --project ${{ secrets.CDF_PROJECT }} \
            --env prod \
            --module-path cognite_toolkit_configs/ \
            > deployment_plan.txt

      - name: Upload Deployment Plan
        uses: actions/upload-artifact@v3
        with:
          name: prod-deployment-plan
          path: deployment_plan.txt

      # The 'production' environment in GitHub should be configured
      # with a required reviewer to act as the manual approval gate.

      - name: Deploy to Prod Environment (Playbook 06)
        run: |
          cognite-toolkit apply \
            --project ${{ secrets.CDF_PROJECT }} \
            --env prod \
            --module-path cognite_toolkit_configs/ \
            --yes
```

______________________________________________________________________

## 3. Key Features of this Pipeline

- **Separation of Concerns:** The pipeline is broken into distinct jobs for
  validation, dev deployment, and prod deployment.
- **Gated Production Deployment:** The `environment: production` setting in the
  `deploy-prod` job allows you to configure a manual approval step in GitHub's
  settings. An authorized user must approve the deployment run after reviewing
  the uploaded `deployment_plan.txt`, preventing accidental changes to
  production.
- **Environment-Specific Secrets:** The pipeline uses GitHub secrets (e.g.,
  `secrets.CDF_PROJECT`) to manage credentials and other sensitive information
  for each environment.
- **Clear Feedback Loop:** If the validation job fails on a pull request, it
  posts a comment directly on the PR, immediately notifying the author that
  changes are needed.

______________________________________________________________________

> **Note:** This playbook provides the skeleton and orchestration logic. The
> actual implementation of the helper scripts (`run_sanity_check.py`,
> `run_yaml_sync.py`) is what brings this workflow to life and is tracked in
> separate backlog items.
