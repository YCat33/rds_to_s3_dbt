{{
    config(
        materialized="incremental",
        unique_key="custkey",
        properties= {
            "format": "'PARQUET'",
            "type": "'HIVE'"
        }
    )
}}

with
    postgres_customer_ as (
        select *
        from {{ source("demo_postgres_aws", "customer") }}
    ),

add_timestamp as (
 select *, 
    cast(current_timestamp as varchar)  ---timestamp(3) is not supported in hive
                                        as last_updated_time
    from postgres_customer_
),

new_rows as (
    select * from add_timestamp 
    {% if is_incremental() %}
      where last_updated_time > (
        select max(last_updated_time)
        from {{ this }}
      )
    {% endif %}
)

select * from new_rows
