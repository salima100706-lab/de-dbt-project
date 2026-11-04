{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

select
    oi.order_id,
    oi.product_id,
    o.customer_id,
    o.order_date,
    oi.quantity,
    oi.unit_price,
    oi.discount_amount,
    (oi.quantity * oi.unit_price - oi.discount_amount) as line_amount,
    coalesce(fo.is_confirmed, false) as is_confirmed
from {{ ref('stg_shop__order_items') }} oi
join {{ ref('stg_shop__orders') }} o 
    on oi.order_id = o.order_id
left join {{ ref('fct_orders') }} fo 
    on oi.order_id = fo.order_id
where o.is_test_order = false
{% if is_incremental() %}
  and o.order_date > (select max(order_date) from {{ this }})
{% endif %}