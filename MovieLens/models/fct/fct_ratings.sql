--dbt will raise an error and halt the run if it detects any schema mismatch
{{
  config(
    materialized = 'incremental',
    on_schema_change='fail' 
  )
}}

WITH src_ratings AS (
  SELECT * FROM {{ ref('src_ratings') }}
)

SELECT
  user_id,
  movie_id,
  rating,
  rating_timestamp
FROM src_ratings
WHERE rating IS NOT NULL

--dbt will update incrementally if the incoming row has the latest timestamp (t > tmax in the current table). 
{% if is_incremental() %}
--this condition (together with the 'rating IS NOT NULL above) is only added if there is incremental row
  AND rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{ this }})
{% endif %}