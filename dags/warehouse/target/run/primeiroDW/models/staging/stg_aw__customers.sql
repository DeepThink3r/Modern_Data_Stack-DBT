
  create view "adventureworks"."airbyte"."stg_aw__customers__dbt_tmp"
    
    
  as (
    select * from "adventureworks"."airbyte"."stg_Customer"
  );