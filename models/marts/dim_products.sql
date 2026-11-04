{{ config(materialized='table') }}
select p.product_id, p.product_name, p.brand, c.category_name, c.parent_category_name, c.root_category_name
from {{ ref('stg_shop__products') }} p
left join {{ ref('int_product_categories_tree') }} c on p.category = c.category_name