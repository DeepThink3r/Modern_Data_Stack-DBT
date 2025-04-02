with fonte as (
    select * from "adventureworks"."airbyte"."ProductModel"
),
renomeado as (
    select
        "ProductModelID" as COD_PROD_MODELO,
        "Name" as MODELO
    from fonte
)
select * from renomeado