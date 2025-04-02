with fonte as (
    select * from {{source('sources','Store')}}
),
renomeado as (
    select
        "BusinessEntityID" as COD_LOJA,
        "Name" as LOJA,
        "SalesPersonID" as VENDEDOR
    from fonte
)
select * from renomeado