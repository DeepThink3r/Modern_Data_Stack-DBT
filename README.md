# Utilizando DBT como o T do ETL

* [Descrição do Projeto](#descrição-do-projeto)
* [Tecnologias Utilizadas](#tecnologias-utilizadas)
* [Configurando a Arquitetura](#configurando-a-arquitetura)
  * [Docker](#docker)
  * [Subindo os Banco de Dados](#subindo-os-bancos-de-dados)
  * [Airbyte](#airbyte)
  * [Modelos](#Modelos)
  * [Orquestração](#orquestração)
* [Conclusão](#conclusão)

# Descrição do Projeto

Esse projeto tem como objetivo a utilização de tecnologias modern data stack(MDS) da disciplina de engenharia de dados do curso de especialização em Analise de Big Data - Data Engineering do LABDATA FIA para a construção de pipelines que atendam tanto demandas de small data quanto Big Data. Aqui iremos desenhar toda uma arquitetura onde a ênfase é uma ferramenta sensacional para intusiastas de transformações com SQL. 

O Data Build Tool surgiu pela necessidade de tornar o processo de transformação e carga de dados menos moroso e mais aderente ao controle de versionamento, CI/CD,data lineage e qualidade de dados para as equipes de dados.

Mesmo com o íntuito do estudo ser voltado para o DBT, maior parte do tempo foi investido para a criação da infraestrutura para preparar a integração do DBT na arquitetura e a orquestração dos scripts .sql também referênciados como modelos.

Esse é apenas o início de uma jornada de estudo orientado à projetos. Bem vindo ao meu primeiro projeto no github!
\

![image](https://github.com/user-attachments/assets/c47e439c-68db-44f3-9828-60e08eecea88)


# Tecnologias Utilizadas

* Docker
* SQL Server
* Airbyte
* Postgres
* DBT
* Airflow

# Configurando a Arquitetura

Antes de começar a configurar, é necessário que tenhamos o Docker instalado em nossas máquinas. Segue abaixo o guia de instalação do Docker de acordo com o seu sistema operacional (OS):

## Docker
[Documentação do Docker](https://docs.docker.com/engine/install/)

## Subindo os Bancos de Dados

Para subir a imagem do MSSQL no Docker, segui as orientações da própria Microsoft. A escolha desse RDBMS foi devido à facilidade de popular os dados utilizando os arquivos `.bak` da AdventureWorks. Eu escolhi subir a imagem diretamente via terminal com os seguintes comandos abaixo:

```bash
docker run -d --name mssql_awdb --hostname awdb -p 1433:1433 \
  --network ambiente_dev \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=sqlserver" \
  -v mssql-db:/var/lib/mssql
```
Feito isso, o comando `docker build -t <nome_da_imagem> .` deve ser executado no terminal para criar o container do MSSQL. \
\
⭐ *Detalhe importate*: Para fins de isolamento, é importante a criação de redes dentro do docker para que os containers se comuniquem dentro dessa rede recém criada. Por que? Caso você suba duas soluções que usam o mesmo banco de dados, evitará com que dê concorrência por causa da porta, ou seja, se um há dois bancos postgres na mesma rede, um deles ficará inativo. A rede pode ser criada no momento da criação da imagem, ou criada préviamente apenas com o comando `docker network create <nome_da_rede>`.\
\
Como boa prática da microsoft, é recomendado criar um usuário novo e desabilitar o usuário padrão administrador. Para isso, execute o comando `docker exec -it <id_do_container> bash` para acessar o terminal do container do MSSQL e, em seguida, execute o seguinte comando `/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "senha" -C` para acessar o banco de dados. Uma vez no banco, crie o seu usuário e, em seguida, desabilite o usuário sa:

```sql
CREATE LOGIN `<user`> WITH PASSWORD = `'<senha>'`;

ALTER SERVER ROLE sysadmin ADD MEMBER `user`;

ALTER LOGIN sa DISABLE;
```
\
⭐ o `-C` no final serve para instruir o sqlcmd a confiar no certificado autoassinado do servidor.
\
Uma vez que o MSSQL já está configurado, vamos para o postgres que não é muito diferente:
```sql
docker run -d \
--name pg_awdb \
--network ambiente_dev \
-p 5431:5432 \
-e POSTGRES_PASSWORD=postgres \
-v postgredb:/var/lib/postgresql/data \
```
\
Acesse o terminal do container do postgresql com o comando `psql -U postgres -d <nome_do_banco>`. Depois de acessar, execute os seguintes comandos:
```sql
CREATE ROLE novo_usuario WITH LOGIN PASSWORD 'Senha';
ALTER ROLE novo_usuario SUPERUSER;
ALTER ROLE postgres NOLOGIN;
CREATE DATABASE AdventureWorks;
```

#### Realizando backup do banco de dados AdventureWorks

Usaremos o seguinte arquivo de backup: https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak
\
Com o container do MSSQL ativo, seguiremos alguns passos: \
\
1.Configure a sua conexão no Azure Data Studio: \
![image](https://github.com/user-attachments/assets/88ce7c06-4e19-4ab0-bd65-c62f79bfb407)
\
2.Importe o arquivo de banco de dados
⭐ Mas antes, você precisará copiar o arquivo .bak para um diretório do seu container. Execute o comando ``docker cp /Users/gabrielbraga/AdventureWorks2022.bak container-id:/var/lib/mssql``
![Captura de Tela 2025-04-05 às 16 04 30](https://github.com/user-attachments/assets/8bd41df1-2b1f-410e-ad1d-03351753fa4c)

### Criando conexão no DBeaver com o postgres

Por que a alteração de IDE de BDMS? O Azure Data Studio ou SQL Server Managemant Studio(SSMS) permite a restauração de banco de dados via arquivo .bak, mas para manuseio e manipulações de bancos de dados, o DBeaver é bem interessante e fácil. Recomendo que aproveite para criar a conexão com o MSSQL lá também. Segue o link de download:
\
https://dbeaver.io/download/ \
\
1.Monte a conexão: \
![Captura de Tela 2025-04-05 às 16 24 57](https://github.com/user-attachments/assets/cb939e56-8358-41c6-992e-31b32fcf266f)

\
2.Em seguida, crie um script sql com os comandos abaixo:
```sql
CREATE SCHEMA airbyte;
CREATE USER airbyte_user PASSWORD 'airbyte';

GRANT CONNECT ON DATABASE adventureworks TO airbyte_user;
GRANT USAGE ON SCHEMA airbyte TO airbyte_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA airbyte TO airbyte_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA airbyte TO airbyte_user;
```
Como no próximo passo configuraremos o airbyte para extrair os dados do MSSQL e mandar para o Postgres, a documentação recomenda como prática, que o usuário crie schema e user específico para essa conexão e com direitos específicos.

## Airbyte

A orientação de instalação do airbyte é encontrada nesse link de documentações: https://docs.airbyte.com/using-airbyte/getting-started/oss-quickstart

### Configurando uma conexão

Depois de baixar e logar no Airbyte. Siga os passos: 

1. Clique em _new connection_ no canto superior direito;
2. Selecione _Set up a new source_;
3. Procure por Microsoft SQL Server;
4. Preencha os campos de conexão;
5. Deixar o schema vazio ou especificar um schema em campos opcionais; \
⭐ Em host, insira `host.docker.internal`.

![image](https://github.com/user-attachments/assets/0eb30e53-ff96-48f8-96c7-0ca281b19c4a)
\
Na configuração do banco de destino, segue a mesma dinâmica. A porta é sempre a do host.
A partir daqui, as configurações são bem intuitivas.

## Modelos

Copie o meu repositório e configure os arquivos, especialmente o profile que está em dags/warehouse/profile. Caso for criar o seu modelo(e eu sei que vai), particulamente recomendo criar fora da dag do airflow(abordaremos isso logo a seguir). Portanto, dentro de uma pasta, crie um ambiente virtual do python e lá siga esses passos orientados pelo próprio DBT: \
https://docs.getdbt.com/docs/core/pip-install 

Feito isso, digite `dbt init <nome do seu projeto>` no terminal e siga as etapas de configuração de projeto. Depois que terminar e a estrutura de pastas for feita, que vai ficar dessa maneira: \
![image](https://github.com/user-attachments/assets/e2090db1-bbc9-4066-9cf4-738cfecc6ce1)

⭐Repare que ao final da configuração do `dbt init`, ele irá retornar onde o seu arquivo profiles.yml está localizado na sua máquina local como segue abaixo: \
`Profile apresentacao2 written to /Users/gabrielbraga/.dbt/profiles.yml using target's profile_template.yml and your supplied values. Run 'dbt debug' to validate the connection.`

Esse mesmo arquivo, para facilitar o próximo passo de Orquestração, crie uma pasta no seu projeto chamada profile e mova-o para cá, logo você executará dentro do seu ambiente virtual o seguinte comando que visa criar uma variável de ambiente apontando para onde as informações do profiles.yml estão. Como eu estou em um MacOS, o comando é esse: /

```cmd
export DBT_PROFILES_DIR="/Users/gabrielbraga/Library/CloudStorage/OneDrive-Pessoal/Documentos/Material de Estudo/DBT/projeto_dbt/warehouse/profile"
```
\
Como é uma boa prática do DBT, recomendo criar uma estrutura de pastas dentro de models e configurar o seu dbt-project.yml semelhante ao meu. Não se esqueça de dar uma olhada na pasta de macros pois criei uma macro que irá ajustar o nome do seus schemas de destino toda vez que for rodar um `dbt run --select <nome_do_modelo.sql>`.





