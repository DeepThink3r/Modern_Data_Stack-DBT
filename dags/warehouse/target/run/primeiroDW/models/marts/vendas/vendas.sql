
  
    

  create  table "adventureworks"."mart"."vendas__dbt_tmp"
  
  
    as
  
  (
    with __dbt__cte__int_sales_joined_header_detail_offer as (
with detalhe_pedido as (
    select
        o.id_pedido,
        o.qtd_pedido,
        o.val_unit,
        (o.qtd_pedido * o.val_unit) as val_total,
        (o.val_unit * of.porcentagem ) as val_desconto,
        o.cod_oferta,
        o.cod_produto
    from "adventureworks"."staging"."stg_aw__SalesOrderDetail" o
    left join "adventureworks"."staging"."stg_aw__special_offer" of
        on o.cod_oferta = of.cod_oferta
),
documento_detalhe as (
    select
        h.id_pedido,
        h.num_revisao,
        h.data_pedido,
        h.data_estimada_entrega,
        h.data_embarque,
        h.status_pedido,
        h.cod_cliente,
        h.cod_vendedor,
        h.cod_regiao,
        d.qtd_pedido,
        d.val_unit,
        d.val_total,
        (d.qtd_pedido * (d.val_unit - d.val_desconto)) as val_total_dsc,
        d.cod_oferta,
        d.cod_produto
    from "adventureworks"."staging"."stg_aw__sales_order_header" h
left join detalhe_pedido d
    on h.id_pedido = d.id_pedido
)
select * from documento_detalhe
) select * from __dbt__cte__int_sales_joined_header_detail_offer
  );
  