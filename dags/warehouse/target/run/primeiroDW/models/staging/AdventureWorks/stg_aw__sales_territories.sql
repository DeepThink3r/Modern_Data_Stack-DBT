
  create view "adventureworks"."staging"."stg_aw__sales_territories__dbt_tmp"
    
    
  as (
    with fonte as (
    select * from "adventureworks"."airbyte"."SalesTerritory"
),
renomeado as (
    select
        "TerritoryID" as COD_REGIAO,
        "CountryRegionCode" as UF,
        "Name" as REGIAO,   
        "Group" as GRUPO,
        "CostYTD" as CUSTO_YTD,
        "SalesYTD" as VENDAS_YTD,
        "CostLastYear" as CUSTO_ULTIMO_ANO,
        "SalesLastYear" as VENDAS_ULTIMO_ANO
    from fonte
)
select * from renomeado
  );