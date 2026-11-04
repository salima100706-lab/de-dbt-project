{{ config(materialized='table') }}
select 
    c.customer_id, c.city, c.acquisition_channel,
    (select order_id from {{ ref('fct_orders') }} fo where fo.customer_id = c.customer_id and fo.is_confirmed = true order by ordered_at asc limit 1) as first_confirmed_order_id,
    (select min(ordered_at) from {{ ref('fct_orders') }} fo where fo.customer_id = c.customer_id and fo.is_confirmed = true) as first_confirmed_at,
    (select count(*) from {{ ref('fct_orders') }} fo where fo.customer_id = c.customer_id and fo.is_confirmed = true) as confirmed_orders_count,
    (select coalesce(sum(net_paid_amount), 0) from {{ ref('fct_orders') }} fo where fo.customer_id = c.customer_id and fo.is_confirmed = true) as confirmed_revenue,
    case when (select count(*) from {{ ref('fct_orders') }} fo where fo.customer_id = c.customer_id and fo.is_confirmed = true) > 0 then true else false end as is_buyer
from {{ ref('stg_shop__customers') }} c