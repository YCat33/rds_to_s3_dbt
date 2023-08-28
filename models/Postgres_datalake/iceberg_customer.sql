{{
    config(
        materialized='incremental',
        unique_key='custkey',
        properties= {
            "format": "'PARQUET'",
            "type": "'ICEBERG'",
            "partitioning": "ARRAY['month(registration_date)']",
            "sorted_by": "ARRAY['custkey']"
        }
    )
}}

with postgres_hive_customer_ as (
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
    from {{ ref('hive_customer')}}
    where registration_date > '1999-12-31'
)

select * from postgres_hive_customer_