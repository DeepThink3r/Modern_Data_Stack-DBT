
  create view "adventureworks"."staging"."stg_aw__SalesOrderDetail__dbt_tmp"
    
    
  as (
    with fonte as (
    select * from "adventureworks"."airbyte"."SalesOrderDetail"
),
renomeado as (
    select
        "SalesOrderID" as ID_PEDIDO,
        "SalesOrderDetailID" as NUMERADOR_PEDIDO,
        "OrderQty" as QTD_PEDIDO,
        "ProductID" as COD_PRODUTO,
        "SpecialOfferID" as COD_OFERTA,
        "UnitPrice" as VAL_UNIT
    from fonte
)
select * from renomeado
  );