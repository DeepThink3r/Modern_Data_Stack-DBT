from datetime import datetime

from cosmos import DbtDag, ProjectConfig

from include.profiles import airflow_db
from include.constants import projeto_warehouse, venv_execution_config

adventureworks_dag = DbtDag(
    project_config=ProjectConfig(projeto_warehouse),
    profile_config=airflow_db,
    execution_config=venv_execution_config,

    schedule_interval="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    dag_id="dbt_adventureworks",
    tags=["comercial"],
)