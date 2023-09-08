{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key= 'custkey',
        inceremental_strategy= 'merge',
        on_schema_change= 'sync_all_columns',
        properties={
            "format": "'PARQUET'",
            "type": "'ICEBERG'",
            "partitioning": "ARRAY['month(registration_date)']",
            "sorted_by": "ARRAY['custkey']",
        },
    )
}}


with
    snapshot_data as (
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
            fico,
            dbt_valid_from
        from {{ ref('postgres_burst_bank_customer_snapshot') }}
        {% if is_incremental() %}
            -- this filter will only be applied on an incremental run
            where dbt_valid_from > (select max(dbt_valid_from) from {{ this }})
        {% endif %}
    )
    select * from snapshot_data