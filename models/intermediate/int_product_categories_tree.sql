{{ config(materialized='view') }}

with recursive tree as (
    
    select
        category_id,
        category_name,
        parent_category_id,
        1 as level,
        category_name as root_category_name,
        cast(null as text) as parent_category_name
    from {{ ref('stg_shop__product_categories') }}
    where parent_category_id is null

    union all

    -- Рекурсия
    select
        c.category_id,
        c.category_name,
        c.parent_category_id,
        t.level + 1,
        t.root_category_name,
        t.category_name as parent_category_name
    from {{ ref('stg_shop__product_categories') }} c
    join tree t on c.parent_category_id = t.category_id
)

select * from tree