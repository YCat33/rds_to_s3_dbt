{{
    config(
        materialized='incremental',
        unique_key='custkey'
    )
}}

{{ ctas_statement('demo_postgres_aws.burst_bank.customer','demo_aws_s3.burst_bank.postgres_customer', 'ORC', 'Hive', 'state') }}

{% if is_incremental()%}
    where custkey not in (select * from {{ this }})

{% endif %}