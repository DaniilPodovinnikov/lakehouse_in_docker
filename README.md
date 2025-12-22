# Lakehouse in docker

```
git clone git@github.com:DaniilPodovinnikov/lakehouse_in_docker.git

cd lakehouse_in_docker

./01-generate-env.sh

./02-generate-trino-config.sh

./03-manage-lakehouse.sh start

./03-manage-lakehouse.sh init

./03-manage-lakehouse.sh stop
```

Trino Web UI: https://localhost:443

Trino JDBC: jdbc:trino://localhost:443?SSL=true&SSLVerification=NONE

MinIO UI: http://localhost:9001

Polaris console: http://localhost:8181

Polaris postgres: jdbc:postgresql://localhost:5432/POLARIS

Jupyter lab: http://localhost:8888

Spark UI: http://localhost:4040

