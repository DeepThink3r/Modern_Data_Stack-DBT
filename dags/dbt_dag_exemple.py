from airflow.decorators import dag, task
from datetime import datetime
import subprocess

@dag(
    dag_id="dbt_ls_check",
    schedule_interval=None,
    start_date=datetime(2023, 1, 1),
    catchup=False
)
def dbt_ls_dag():

    @task
    def run_dbt_ls():
        # Define o comando para listar os recursos do projeto dbt
        command = "cd /usr/local/airflow/warehouse && dbt ls --profiles-dir profile"
        # Executa o comando e captura a saída
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        # Imprime a saída no log do Airflow
        print(result.stdout)
        return result.stdout

    run_dbt_ls()

dag_instance = dbt_ls_dag()