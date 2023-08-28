{{
    config(
        materialized='incremental',
        unique_key='custkey',
    )
}}

with postgres_customer_ as (
    select * from demo_postgres_aws.burst_bank.customer
)

select * from postgres_customer_