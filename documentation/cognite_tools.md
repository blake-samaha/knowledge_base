# Guide to Cognite Developer Tools

The Cognite Data Fusion (CDF) ecosystem provides a powerful suite of tools for developers, data engineers, and administrators. This guide provides a comprehensive overview of the key tools, their purposes, and how to use them.

## 1. Choosing the Right Tool

Use this table to select the best tool for your task.

| Task                                                     | Recommended Tool(s)                                   |
| -------------------------------------------------------- | ----------------------------------------------------- |
| Initial setup and ongoing management of a CDF project    | **Cognite Toolkit** (`cdf` from pip)                  |
| Automating deployments in a CI/CD pipeline               | **Cognite Toolkit** (`cdf` from pip)                  |
| Quickly creating or modifying data models from the CLI   | **Cognite Fusion CLI** (`fusion` from npm)            |
| Developing data pipelines, scripts, or data science models | **Cognite Python SDK**                                |
| Building a new custom data extractor in Python           | **cogex** and **cognite-extractor-utils**               |
| Running a pre-built extractor to ingest data             | The specific extractor's CLI (e.g., `db-extractor.exe`) |

---

## 2. Overview of Developer Tools

This section provides a detailed overview of each major tool in the Cognite developer ecosystem.

> **Warning: Potential CLI Command Collision**
>
> 1. **Cognite Toolkit**: A Python tool installed via `pip`. Its primary command is `cdf`.
> 2. **Cognite Fusion CLI**: A Node.js tool installed via `npm`. Its primary command is `fusion`, but it also registers `cdf` as an alias.
>
> Which tool runs when you type `cdf` depends on your system's `PATH` configuration. Be aware of which tool you are using. This guide will differentiate them by their primary command (`cdf` vs. `fusion`) and installation source (`pip` vs. `npm`).

### 2.1. Cognite Toolkit (`cdf` from `pip`)

The **Cognite Toolkit** is the cornerstone of managing your CDF environment as code, enabling version-controlled, repeatable deployments.

- **Primary Use**: Full project lifecycle management and CI/CD automation.
- **Installation**:

```bash
pip install cognite-toolkit
```

- **Core Concepts**:
  - **Modules**: Collections of YAML files that define a specific part of your CDF project (e.g., data sets, transformations, data models).
  - **Environments**: The toolkit supports deploying to multiple environments (e.g., `dev`, `prod`) using environment-specific configuration files (`config.dev.yaml`).
  - **Configuration as Code**: Your entire CDF project setup is defined in text files, which can be stored in Git.

### 2.2. Cognite Fusion CLI (`fusion` from `npm`)

The **Cognite Fusion CLI** is a lightweight, focused tool for developers to quickly manage GraphQL data models from the command line.

- **Primary Use**: Rapid, iterative development and management of data models.
- **Installation**:

```bash
npm install --global @cognite/fusion-cli
```

- **Key Features**:
  - Directly interacts with the data modeling services.
  - Ideal for quick creation, publication, and modification of GraphQL schemas during development.

### 2.3. Cognite Python SDK

The **Cognite Python SDK** is the primary tool for programmatic interaction with CDF. It provides a high-level, intuitive interface to the CDF API.

- **Primary Use**: Building data pipelines, data science, and custom applications.
- **Installation**:

```bash
pip install cognite-sdk

# Recommended for data science (includes pandas, etc.)
pip install "cognite-sdk[pandas,geo,data_modeling]"
```

- **Key Features**:
  - Abstracts away the complexity of the underlying REST API.
  - Integrates tightly with the Python data science ecosystem (e.g., pandas, numpy).

### 2.4. `cogex` and `cognite-extractor-utils`

These tools are essential for building your own custom Python data extractors.

- **Primary Use**: Creating and packaging new, custom data extractors.
- **Installation**:

```bash
pip install cognite-extractor-manager
```

- **Core Purpose**:
  - `cogex`: A CLI tool that initializes a standard extractor project structure and bundles your code and dependencies into a single executable.
  - `cognite-extractor-utils`: A Python library providing building blocks for extractor code, such as upload queues, state management, and configuration parsing.

### 2.5. Pre-built Extractor CLIs

For many common industrial data sources (OPC-UA, OSIsoft PI, etc.), Cognite provides standalone, pre-built extractor applications.

- **Primary Use**: Ingesting data from standard systems without writing custom code.
- **Installation**: Downloaded as executables directly from the CDF user interface.
- **Key Features**:
  - Configuration is done via a YAML file.
  - Provides a reliable, out-of-the-box solution for common data sources.

---

## 3. Practical Examples

This section provides concrete examples of how to use each tool.

### 3.1. Full Project Lifecycle with the Cognite Toolkit

1. **Initialize a new project repository:**

```bash
cdf repo init my-cdf-project
cd my-cdf-project
```

1. **Add the official `data-sets` module to your project:**

```bash
cdf modules add data-sets
```

1. **Define a new data set** by creating a YAML file at `my-cdf-project/modules/data-sets/my_first_data_set.DataSet.yaml`:

```yaml
externalId: "my_first_data_set"
name: "My First Data Set"
description: "A data set created with the CDF Toolkit"
```

1. **Configure your environment** in `config.dev.yaml` to select the module:

```yaml
environment:
  name: "development"
  # ... other environment settings
  selected:
    - "data-sets" # Select the module to deploy
```

1. **Build and deploy the configuration to CDF:**

```bash
cdf build
cdf deploy --env dev
```

### 3.2. Quick Data Model Management with the Cognite Fusion CLI

1. **Sign in to your project:**

```bash
fusion signin my-cdf-project
```

2. **Create a new data model container:**

```bash
fusion data-models create --space my-space --external-id my-new-model --name "My New Data Model"
```

3. **Publish a GraphQL schema** from a local file:

```bash
fusion data-models publish --space my-space --external-id my-new-model --file my-schema.graphql
```

### 3.3. Programmatic Data Interaction with the Python SDK

This example authenticates and retrieves time series data into a pandas DataFrame.

```python
from cognite.client import CogniteClient, ClientConfig
from cognite.client.credentials import OAuthClientCredentials
import os

# 1. Authenticate and create a client instance
TENANT_ID = os.getenv("IDP_TENANT_ID")
CLIENT_ID = os.getenv("IDP_CLIENT_ID")
CLIENT_SECRET = os.getenv("IDP_CLIENT_SECRET")
CDF_CLUSTER = os.getenv("CDF_CLUSTER")
CDF_PROJECT = os.getenv("CDF_PROJECT")

TOKEN_URL = f"https://login.microsoftonline.com/{TENANT_ID}/oauth2/v2.0/token"
SCOPES = [f"https://{CDF_CLUSTER}.cognitedata.com/.default"]

creds = OAuthClientCredentials(token_url=TOKEN_URL, client_id=CLIENT_ID, client_secret=CLIENT_SECRET, scopes=SCOPES)
config = ClientConfig(client_name="my-python-app", project=CDF_PROJECT, base_url=f"https://{CDF_CLUSTER}.cognitedata.com", credentials=creds)
client = CogniteClient(config)

# 2. Retrieve 1 million data points into a pandas DataFrame
df = client.time_series.data.retrieve_dataframe(
    external_id="my_temperature_sensor",
    start="1w-ago",
    end="now",
    limit=1_000_000
)

# 3. Perform analysis on the DataFrame
print("Time Series Data Analysis:")
print(df.describe())
```

### 3.4. Building a Custom Extractor with `cogex`

1. **Initialize a new extractor project:**

```bash
cogex init my-custom-extractor
```

This creates a standard project structure with `pyproject.toml` for dependency management.
2. **Develop your extractor logic** in the main Python file, using `cognite-extractor-utils`.
3. **Add any additional dependencies** using `poetry`:

```bash
cd my-custom-extractor
poetry add requests
```

1. **Build the self-contained executable:**

```bash
cogex build
```

This packages your code and dependencies into a single executable in the `dist/` directory.

### 3.5. Running a Pre-built Extractor

Most pre-built extractors are run from the command line with a path to a configuration file:

```bash
# On Windows
./db-extractor-v1.2.3-win.exe --config my-config.yml

# On Linux
./db-extractor-v1.2.3-linux --config my-config.yml

```

**Example `config.yml` for a DB Extractor:**

```yaml
version: 2

cognite:
  project: ${COGNITE_PROJECT}
  api-key: ${COGNITE_API_KEY}
  base-url: "https://api.cognitedata.com"

extractor:
  state-store:
    local:
      path: states.json

source:
  type: "db-extractor"
  databases:
    - name: "my-source-db"
      connection-string: "DRIVER={ODBC Driver 17 for SQL Server};SERVER=myserver;DATABASE=mydatabase;UID=myuser;PWD=mypassword"
      queries:
        - query: "SELECT * FROM my_table WHERE timestamp > ?;"
          incremental-field: "timestamp"
          destination:
            type: "raw"
            raw-db-name: "source-db-raw"
            raw-table-name: "my_table"
```
