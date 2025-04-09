# Databricks Schema Management with Flyway

This repository demonstrates how to implement robust schema management for Databricks using Flyway, a powerful database migration tool. It enables version-controlled, repeatable database schema changes across development, staging, and production Databricks environments.

## Overview

This implementation provides:

- Version control for Databricks database schemas
- Consistent migration process across environments
- Integration with CI/CD pipelines
- Support for both CLI and Flyway Desktop interfaces

## Project Structure

```bash
.
├── README.md
├── .github
│   └── workflows
│       └── deploy.yml            # GitHub Actions for CI/CD automation
├── flyway
│   ├── conf
│   │   ├── flyway.toml           # Development environment config
│   │   ├── flyway.staging.toml   # Staging environment config 
│   │   └── flyway.prod.toml      # Production environment config
│   └── sql                       # Migration scripts folder
│       ├── V001_1725742173__create_raw_tables.sql
│       ├── V002_1725742215__insert_raw_data.sql
│       ├── V003_1725742392__create_silver_tables.sql
│       ├── V004_1725753080__add_pk_silver_tables.sql
│       ├── V005_1725864865__create_liquid_table.sql
│       ├── V006_1725865484__alter_table_properties.sql
│       ├── V007_1725866341__create_streaming_table.sql
│       ├── V008_1725866372__create_materialized_view.sql
│       ├── V009_1725911379__test_github_action.sql
│       └── V010_1712601800__create_customer_view.sql
└── .gitignore
```

## Key Features

- **Multi-schema support**: Manages Bronze, Silver, and Gold data layers
- **Databricks SQL features**: Demonstrates liquid clustering, materialized views, and other Databricks-specific features
- **CI/CD integration**: Includes GitHub Actions workflow for automated migrations
- **Environment configuration**: Separate configurations for dev, staging, and production
- **Both CLI and UI approaches**: Support for both command-line and Flyway Desktop

## Getting Started

### Prerequisites

- Databricks workspace with Unity Catalog enabled
- SQL warehouse in your Databricks workspace
- Flyway Community Edition 11.6.1 or later
- Java Development Kit (JDK) 11 or later

### Setup Instructions

1. **Install Flyway CLI**
   ```bash
   # For macOS
   brew install flyway
   
   # For Windows - Download and extract to a suitable location
   # Add the Flyway bin directory to your PATH
   ```

2. **Create Databricks Resources**
   ```sql
   -- Execute in Databricks SQL
   CREATE CATALOG IF NOT EXISTS qdw_schema_management;
   CREATE SCHEMA IF NOT EXISTS qdw_schema_management.qmc_bronze;
   CREATE SCHEMA IF NOT EXISTS qdw_schema_management.qmc_silver;
   CREATE SCHEMA IF NOT EXISTS qdw_schema_management.qmc_gold;
   ```

3. **Configure Flyway**
   Update `flyway/conf/flyway.toml` with your Databricks connection details:
   ```toml
   [environments.dev]
   url = "jdbc:databricks://<hostname>:443/qdw_schema_management;transportMode=http;ssl=1;AuthMech=3;httpPath=/sql/1.0/warehouses/<warehouse-id>;ConnCatalog=qdw_schema_management;EnableArrow=0;"
   user = "token"
   password = "<your-personal-access-token>"
   schemas = [ "qmc_bronze", "qmc_silver", "qmc_gold" ]

   [flyway]
   environment = "dev" 
   locations = [ "filesystem:<absolute-path-to-project>/flyway/sql" ]
   mixed = true
   outOfOrder = true
   validateMigrationNaming = true
   defaultSchema = "qmc_bronze"
   baselineOnMigrate = true
   ```
   
4. **Authenticate with Flyway**
   ```bash
   flyway auth -IAgreeToTheEula
   ```

5. **Run Migrations**
   ```bash
   flyway migrate -configFiles="./flyway/conf/flyway.toml"
   ```

6. **Check Migration Status**
   ```bash
   flyway info -configFiles="./flyway/conf/flyway.toml"
   ```

## Using Flyway Desktop

1. Install Flyway Desktop from the [Redgate website](https://flywaydb.org/download/flyway-desktop/)
2. Open your project by browsing to your `flyway.toml` file
3. Connect to your Databricks database using the connection details
4. Create and run migrations through the UI

> **Important**: For Flyway Desktop to work correctly with existing migrations, use absolute paths in your `locations` configuration:
> ```toml
> locations = [ "filesystem:C:/Users/username/project-path/flyway/sql" ]
> ```

## CI/CD Integration

The repository includes a GitHub Actions workflow that:

1. Validates migrations against your development environment
2. Applies migrations to development when merged to main
3. Can be extended to promote migrations to staging and production

To set up:
1. Add required secrets to your GitHub repository
2. Customize `.github/workflows/deploy.yml` as needed

## Common Troubleshooting

- **Missing required flag**: Use `-IAgreeToTheEula` with the `auth` command
- **Migration validation failures**: Use `flyway repair` to fix the schema history
- **Non-transactional warning**: Databricks doesn't support transactional DDL - this warning can be ignored if migrations succeed
- **Path resolution**: Use absolute paths when working with Flyway Desktop

## Resources

- [Flyway Documentation](https://flywaydb.org/documentation/)
- [Databricks SQL Documentation](https://docs.databricks.com/sql/index.html)
- [Flyway Community Discussion](https://community.red-gate.com/flyway)