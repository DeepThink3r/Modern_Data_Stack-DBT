from cosmos import ProfileConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping

airflow_db = ProfileConfig(
    profile_name="warehouse",  # Nome do profile
    target_name="dev",         # Nome do target
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="container_postgres_db",  # Nome único do conn_id
        profile_args={         
            "schema":"airbyte"
        }
    ),
)
