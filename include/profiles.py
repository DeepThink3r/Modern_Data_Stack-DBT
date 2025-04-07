from cosmos import ProfileConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping

airflow_db = ProfileConfig(
    profile_name="warehouse",  
    target_name="dev",         
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="container_postgres_db", 
        profile_args={         
            "schema":"airbyte"
        }
    ),
)
