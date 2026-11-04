{{ config(materialized='table') }}
select * from {{ ref('int_orders_with_payments') }} where not is_test_order
