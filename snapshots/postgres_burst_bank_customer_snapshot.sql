{% snapshot postgres_burst_bank_customer_snapshot %}

{{
    config(
      target_database='demo_aws_s3',
      target_schema='dbt_snapshots',
      unique_key='custkey',
      strategy='check',
      check_cols='all',
      properties={
            "format": "'PARQUET'",
            "type": "'ICEBERG'",
        },
    )
}}

select custkey,
    first_name,
    last_name,
    cast(registration_date as timestamp(6) with time zone) as registration_date,
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
    from {{ source("demo_postgres_aws", "customer") }}

{% endsnapshot %}

