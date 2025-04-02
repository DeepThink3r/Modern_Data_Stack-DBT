
  create view "adventureworks"."staging"."stg_aw_sales_person__dbt_tmp"
    
    
  as (
    with fonte as (
    select * from "adventureworks"."airbyte"."SalesPerson"
),
renomeado as (
    select
        "BusinessEntityID" as COD_VENDEDOR,
        Coalesce("SalesQuota", 0) AS META_VENDA,
        "CommissionPct" as PCT_COMISSAO,
        "SalesYTD" as VENDAS_YTD,
        "SalesLastYear" as VENDAS_ULTIMO_ANO,
        Coalesce("TerritoryID", -1) AS COD_REGIAO
    from fonte
)
select * from renomeado
  );