{% macro ctas_statement(source_table, destination_table, format, file_type, partition='') %}

{% set ctas %}
CREATE TABLE {{ destination_table }}
WITH
  (format = '{{ format }}', type = '{{ file_type }}')
AS SELECT *
FROM {{ source_table }};
{% endset %}

{% do run_query(ctas) %}

{% endmacro %}