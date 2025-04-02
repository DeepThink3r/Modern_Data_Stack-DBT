from pathlib import Path
from cosmos import ExecutionConfig

projeto_warehouse = Path("/usr/local/airflow/dags/warehouse")
dbt_executable = Path("/usr/local/airflow/dbt_venv/bin/dbt")

venv_execution_config = ExecutionConfig(
    dbt_executable_path=str(dbt_executable),
)