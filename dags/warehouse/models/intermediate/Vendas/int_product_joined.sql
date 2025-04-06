with categoria as (
    select
        s.cod_prod_subcat,
        s.subcategoria,
        c.categoria
    from {{ref('stg_aw__product_subcategories')}} s
    left join {{ref('stg_aw__product_categories')}} c
        on s.cod_prod_cat = c.cod_prod_cat
)
select
    p.cod_produto,
    p.produto,
    c.categoria,
    c.subcategoria,
    p.modelo,
    Coalesce(p.tamanho,'Não Definido') as tamanho,
    p.cor,
    p.genero,
    p.linha
from {{ref('stg_aw__products')}} p
left join categoria c
    on  p.cod_prod_subcat = c.cod_prod_subcat
