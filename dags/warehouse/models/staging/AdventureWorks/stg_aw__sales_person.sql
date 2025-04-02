with fonte as (
    select * from {{source('sources', 'SalesPerson')}}
),
renomeado as (
    select
        "BusinessEntityID" as COD_VENDEDOR,
        Coalesce("SalesQuota", 0) AS META_VENDA,
        "CommissionPct" as PCT_COMISSAO,
        "SalesYTD" as VENDAS_YTD,
        "SalesLastYear" as VENDAS_ULTIMO_ANO,
        Coalesce("TerritoryID", 0) AS COD_REGIAO
    from fonte
)
select * from renomeado
