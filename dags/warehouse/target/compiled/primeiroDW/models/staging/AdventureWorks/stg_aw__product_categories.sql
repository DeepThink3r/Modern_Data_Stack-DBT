with fonte as (
    select * from "adventureworks"."airbyte"."ProductCategory"
),
renomeado as (
    select
        "ProductCategoryID" as COD_PROD_CAT,
        "Name" as CATEGORIA
    from fonte
)
select * from renomeado