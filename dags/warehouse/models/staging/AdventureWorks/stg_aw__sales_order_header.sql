with fonte as (
    select * from {{source('sources','SalesOrderHeader')}}
),
renomeado as (
    select 
        "SalesOrderID" as ID_PEDIDO,
        "RevisionNumber" as NUM_REVISAO,
        "OrderDate" as DATA_PEDIDO,
        "OrderDate" as DATA_ESTIMADA_ENTREGA,
        "ShipDate" as DATA_EMBARQUE,
        "Status" as STATUS_PEDIDO,
        "OnlineOrderFlag" as ORIGEM_PEDIDO,
        "SalesOrderNumber" as DOC_PEDIDO,
        "CustomerID" as COD_CLIENTE,
        "SalesPersonID" as COD_VENDEDOR,
        "TerritoryID" as COD_REGIAO
    from fonte
)
select * from renomeado