with fonte as (
    select * from "adventureworks"."airbyte"."Person"
),
renomeado AS (
    select
        Coalesce("Title",'Sem Titulo') as TITULO,
        CASE
            WHEN LENGTH("MiddleName") > 0 THEN "FirstName"||' '||"MiddleName"||' '||"LastName"
            ELSE "FirstName"||' '||"LastName"
        END as NOME_COMPLETO,
        "BusinessEntityID" as ID,
        "PersonType" as FILIACAO
    from fonte
)
select * from renomeado