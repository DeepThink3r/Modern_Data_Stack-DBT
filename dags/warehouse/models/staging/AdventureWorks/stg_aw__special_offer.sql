with fonte as (
    select * from {{source('sources','SpecialOffer')}}
),
renomeado as (
    select
        "SpecialOfferID" as COD_OFERTA,
        "Type" as TIPO,
        "Description" as DESCRICAO,
        "Category" as CATEGORIA,
        "DiscountPct" as PORCENTAGEM,
        Coalesce("MaxQty",0) as QTD_MAX,
        "MinQty" as QTD_MIN,
        to_char("StartDate", 'DD/MM/YYYY') as INICIO_OFERTA,
        to_char("EndDate", 'DD/MM/YYYY') as FIM_OFERTA
    from fonte
)
select * from renomeado