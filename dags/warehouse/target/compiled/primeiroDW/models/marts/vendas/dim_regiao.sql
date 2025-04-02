with regiao as (
    select
        cod_regiao,
        uf,
        regiao,
        vendas_ytd,
        vendas_ultimo_ano
    from "adventureworks"."staging"."stg_aw__sales_territories"
)
select * from regiao