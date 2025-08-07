# AI Playbook: 08 - Data Ingestion Operations

This playbook provides a framework for managing the data ingestion lifecycle,
from configuring extractors to monitoring transformations. It ensures that the
process of loading data into the Cognite Data Fusion (CDF) project is as
repeatable and automated as the data modeling process itself.

**Goal:** To establish a clear, "docs-as-code" approach for managing extractor
configurations and transformation logic.

______________________________________________________________________

## 1. Managing Extractor Configurations

Extractors are the components that pull data from source systems. Their
configurations should be managed in code to ensure consistency across
environments.

### Step 1.1: Store Configs in Code

- **Action:** Store all extractor configuration files (e.g., `config.yml`)
  within a dedicated directory in your project, such as `extractor_configs/`.
- **Best Practice:** Use environment-specific subdirectories (e.g.,
  `extractor_configs/dev/`, `extractor_configs/prod/`) to manage differences in
  source system connection details. Use variables to handle sensitive
  information like credentials, which should be injected from a secure secret
  store during deployment.

### Step 1.2: Deploying Config Changes

- **Action:** Configuration changes are deployed via a CI/CD pipeline.
- **Details:** The pipeline automates the process of pushing the updated
  configuration files to the environment where the extractor is running (e.g.,
  an on-premise server or a cloud virtual machine) and then restarting the
  extractor service to apply the new settings.

### Example CI/CD Snippet for Extractor Config Deployment

```yaml
jobs:
  deploy-extractor-config:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      # Example: Using SSH to copy config to a remote server
      - name: Deploy config to extractor host
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.EXTRACTOR_HOST }}
          username: ${{ secrets.EXTRACTOR_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          source: "extractor_configs/prod/config.yml"
          target: "/opt/cognite-extractor/config/"

      - name: Restart extractor service
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.EXTRACTOR_HOST }}
          username: ${{ secrets.EXTRACTOR_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            sudo systemctl restart my-extractor.service
```

______________________________________________________________________

## 2. Managing Transformations

Transformations are the SQL scripts that convert raw data from CDF RAW into the
clean, structured data that populates the data model. The definitions for these
are already generated as part of the `05_TOOLKIT_YAML_SYNC.md` playbook. This
section focuses on their operational management.

### Step 2.1: Monitoring Transformation Runs

- **Action:** Set up automated monitoring and alerting for all transformation
  schedules.
- **Details:** Use a monitoring tool (like Grafana, Datadog, or a custom script)
  to track the status of transformation runs.
- **Key Metrics to Monitor:**
  - **Run Status:** `Completed`, `Failed`, `Timed Out`.
  - **Latency:** How long each transformation takes to run. A sudden increase
    can indicate a performance issue.
  - **Data Processed:** Number of rows created or updated. A sudden drop to zero
    can indicate an issue with the source data.
- **Alerting:** Configure alerts to be sent to the operations team via email,
  Slack, or PagerDuty whenever a transformation fails or key metrics deviate
  from the norm.

### Step 2.2: Handling Backfills

- **Action:** Establish a clear procedure for backfilling data when a
  transformation's logic changes or historical data needs to be re-processed.
- **Procedure:**
  1. **Disable the Schedule:** Temporarily disable the regular schedule for the
     transformation to prevent conflicts.
  1. **Trigger a Manual Run:** Manually trigger the transformation with a
     specific date range to process the historical data. Depending on the
     volume, this may need to be done in batches (e.g., one month at a time).
  1. **Monitor the Backfill:** Closely monitor the progress of the backfill job.
  1. **Re-enable the Schedule:** Once the backfill is complete, re-enable the
     regular schedule.

______________________________________________________________________

> **Note:** This playbook provides a high-level framework. The specific
> implementation details will depend on the choice of extractors, the hosting
> environment, and the monitoring tools used by the project. The key is to

- codify and automate these processes wherever possible.
