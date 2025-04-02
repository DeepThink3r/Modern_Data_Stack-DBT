
  
    

  create  table "adventureworks"."mart"."dim_cliente__dbt_tmp"
  
  
    as
  
  (
    with __dbt__cte__int_customer_joined as (
with clientes as (
    select
        c.cod_cliente,
        p.nome_completo,
        CASE
            WHEN p.filiacao = 'SC' THEN 'Cliente Comercial'
            ELSE 'Cliente Varejo'
        END as tipo_cliente
    from "adventureworks"."staging"."stg_aw__customers" c
    left join "adventureworks"."staging"."stg_aw__person" p 
        on c.id = p.id
)
select * from clientes
) select * from __dbt__cte__int_customer_joined
  );
  