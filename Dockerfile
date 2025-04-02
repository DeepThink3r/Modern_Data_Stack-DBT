FROM quay.io/astronomer/astro-runtime:12.7.1

ARG DBT_ENV_CUSTOM_ENV_SENHA

ENV DBT_ENV_CUSTOM_ENV_SENHA=$DBT_ENV_CUSTOM_ENV_SENHA

# instalando o dbt dentro de um ambiente virtual
RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-postgres && deactivate
