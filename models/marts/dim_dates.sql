{{ config(materialized='table') }}

with date_spine as (
    select generate_series(
        (select min(order_date) from {{ ref('stg_shop__orders') }}),
        (select max(order_date) from {{ ref('stg_shop__orders') }}),
        '1 day'::interval
    )::date as date_day
)

select
    date_day,
    extract(year from date_day) as year,
    extract(quarter from date_day) as quarter,
    extract(month from date_day) as month,
    extract(isodow from date_day) as day_of_week,
    case when extract(isodow from date_day) in (6, 7) then true else false end as is_weekend
from date_spine