with fonte as (
    select * 
    from {{source('sources','Product')}}
),
renomeado AS (
    select
        "ProductID" as COD_PRODUTO,
        "Name" as PRODUTO,
        "ProductModelID" as MODELO,
        "ProductSubcategoryID" as COD_PROD_SUBCAT,
        "Class" as TAMANHO,
        "Color" as COR,
        CASE 
            WHEN UPPER(TRIM("Style")) = 'W' THEN 'Feminino'
            WHEN UPPER(TRIM("Style")) = 'M' THEN 'Masculino'
            WHEN UPPER(TRIM("Style")) = 'U' THEN 'Unissex'
            ELSE COALESCE("Style", 'Desconhecido')
        END as GENERO,
        CASE
            WHEN UPPER(TRIM("ProductLine")) = 'R' THEN 'Road'
            WHEN UPPER(TRIM("ProductLine")) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM("ProductLine")) = 'T' THEN 'Touring'
            WHEN UPPER(TRIM("ProductLine")) = 'S' THEN 'Standard'
            ELSE COALESCE("ProductLine", 'Desconhecido')
        END as LINHA
    from fonte
    where "FinishedGoodsFlag" = true
)
select * 
from renomeado
