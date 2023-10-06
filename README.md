Welcome to your new dbt project!

## How to migrate from database to data lake with dbt Cloud and Starburst Galaxy

With the advent of modern table formats such as Apache Iceberg that provide data warehousing capabilities on object storage, there has been a huge groundswell around the concept of a modern data lake. However, the process of actually standing up a data lake can be quite daunting if you don’t know where to start. 

In this blog post, we will be walking through the necessary steps involved to migrate a table currently residing in Postgres into a modern data lake in AWS S3. During this process, we will leverage Starburst Galaxy as our data lake analytics platform and dbt Cloud as our data transformation tool. This will involve connecting to the underlying Postgres database and transforming the data into a manageable format by adhering to SCD Type #2 to account for DML statements. 

### Pre-requisites

Before getting started, ensure you have the following:

- A GitHub account
- A Starburst Galaxy domain
- A running PostgreSQL instance (any RDBMS instance will work)
- Access to a dbt Cloud account 
- Authentication credentials to Postgres and AWS S3

### Setup Process

1. Configure two new catalogs within Starburst Galaxy
  - Postgresql catalog to your existing database
  - AWS S3 catalog for your data lake table
2. Locate your connection variables in Starburst Galaxy’s Partner Connect pane
3. Navigate to dbt Cloud and configure a new project
  - From account settings (using the gear menu in the top right corner), click “+ New Project”.
  - Enter a project name and choose Starburst as your connection.
  - Enter the settings for your new project (Host and Port) obtained from the second step above.
  - Enter the development credentials for your new project.
      - User and password (step 2)
      - Catalog: Name of the AWS S3 catalog you created in step 1
      - Schema: Name of the schema that you would like your data lake to reside in (e.g. “burst_bank”)
4. Configure integration between dbt Cloud and GitHub
  - Install dbt Cloud in your Github account
  - Clone the following repo within dbt Cloud using HTTPS: https://github.com/YCat33/rds_to_s3_dbt.git
