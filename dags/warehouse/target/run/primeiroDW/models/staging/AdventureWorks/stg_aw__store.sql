
  create view "adventureworks"."staging"."stg_aw__store__dbt_tmp"
    
    
  as (
    with fonte as (
    select * from "adventureworks"."airbyte"."Store"
),
renomeado as (
    select
        "BusinessEntityID" as COD_LOJA,
        "Name" as LOJA,
        "SalesPersonID" as VENDEDOR
    from fonte
)
select * from renomeado
  );