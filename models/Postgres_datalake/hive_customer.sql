{{
    config(
        materialized='incremental',
        unique_key='custkey',
    )
}}

with postgres_customer_ as (
     select * from {{ source('demo_postgres_aws', 'customer')}}
)
 
select * from postgres_customer_