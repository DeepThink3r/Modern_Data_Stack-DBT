with fonte as (
    select * from {{source('sources','ProductSubcategory')}}
),
renomeado as (
    select
        "ProductSubcategoryID" as COD_PROD_SUBCAT,
        "ProductCategoryID" as COD_PROD_CAT,
        "Name" as SUBCATEGORIA
    from fonte
)
select * from renomeado