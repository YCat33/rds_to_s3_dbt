{{
    config(
        materialized="incremental",
        unique_key="custkey",
        properties={
            "format": "'PARQUET'",
            "type": "'ICEBERG'",
            "partitioning": "ARRAY['month(registration_date)']",
            "sorted_by": "ARRAY['custkey']",
        },
    )
}}

with
    dedup_hive as (
        select *
        from
            (
                select
                    *,
                    row_number() over (
                        partition by custkey order by last_updated_time desc
                    ) as row_num
                from {{ ref("hive_customer") }}
                where registration_date > '1999-12-31'
            )
        where row_num = 1
    ),

    postgres_iceberg_customer_ as (
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
        from dedup_hive
    )

select *
from postgres_iceberg_customer_
