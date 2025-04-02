
  
    

  create  table "adventureworks"."mart"."dim_loja__dbt_tmp"
  
  
    as
  
  (
    select * from "adventureworks"."staging"."stg_aw__store"
  );
  