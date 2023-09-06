{{
    config(
        materialized="incremental",
        unique_key="custkey",
        inceremental_strategy="merge",
        on_schema_change="sync_all_columns",
        properties={
            "format": "'PARQUET'",
            "type": "'ICEBERG'",
            "partitioning": "ARRAY['month(registration_date)']",
            "sorted_by": "ARRAY['custkey']",
        },
    )
}}

with
    dedup_snapshot as (
        select
            custkey,
            first_name,
            last_name,
            cast(registration_date as date) as registration_date,
            street,
            city,
            state,
            postcode,
            country,
            phone,
            dob,
            gender,
            married,
            ssn,
            paycheck_dd,
            estimated_income,
            fico
        from {{ ref("postgres_burst_bank_customer_snapshot") }}
        where dbt_valid_to is null

    )

select *
from dedup_snapshot




