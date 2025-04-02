with fonte as (
    select * from {{source('sources','ProductCategory')}}
),
renomeado as (
    select
        "ProductCategoryID" as COD_PROD_CAT,
        "Name" as CATEGORIA
    from fonte
)
select * from renomeado