
  
    

  create  table "adventureworks"."mart"."dim_vendedor__dbt_tmp"
  
  
    as
  
  (
    select * from "adventureworks"."staging"."stg_aw__sales_person"
  );
  