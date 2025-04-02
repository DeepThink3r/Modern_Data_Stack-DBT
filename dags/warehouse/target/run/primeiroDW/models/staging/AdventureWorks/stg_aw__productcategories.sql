
  create view "adventureworks"."staging"."stg_aw__productcategories__dbt_tmp"
    
    
  as (
    with fonte as (
    select * from "adventureworks"."airbyte"."ProductCategory"
),
renomeado as (
    select
        "ProductCategoryID" as COD_PROD_CAT,
        "Name" as PRODUTO
    from fonte
)
select * from renomeado
  );