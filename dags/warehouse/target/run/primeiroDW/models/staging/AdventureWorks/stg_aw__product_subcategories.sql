
  create view "adventureworks"."staging"."stg_aw__product_subcategories__dbt_tmp"
    
    
  as (
    with fonte as (
    select * from "adventureworks"."airbyte"."ProductSubcategory"
),
renomeado as (
    select
        "ProductSubcategoryID" as COD_PROD_SUBCAT,
        "ProductCategoryID" as COD_PROD_CAT,
        "Name" as SUBCATEGORIA
    from fonte
)
select * from renomeado
  );