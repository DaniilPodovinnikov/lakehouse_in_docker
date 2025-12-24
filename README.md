# Lakehouse in docker

```
git clone git@github.com:DaniilPodovinnikov/lakehouse_in_docker.git

cd lakehouse_in_docker
```
## 1. Setting up .env file:

- Automatically (recommended):
```
./01-generate-env.sh
```
- Manually: 
```
cp .env.example .env 
```
Then open the .env file in any text editor to configure it.
## 2. Launching and Managing the Lakehouse Infrastructure
- Generate Trino Configuration:
```
./02-generate-trino-config.sh
```
- Start All Services:
```
./03-manage-lakehouse.sh start
```
- Initialize Polaris (one-time action required):
```
./03-manage-lakehouse.sh init
```
- Stop All Services:
```
./03-manage-lakehouse.sh stop
```

## 3. Accessing Web Interfaces and Clients

After a successful launch (`start`), the services will be available at the following addresses:

| Service | Purpose | URL / Connection String |
|---------|---------|--------------------------|
| **Trino Web UI** | Web interface for the Trino cluster (query monitoring) | `https://localhost:443` |
| **Trino JDBC** | Connection string for BI tools, IDEs (DBeaver, Datagrip) | `jdbc:trino://localhost:443?SSL=true&SSLVerification=NONE` |
| **MinIO UI** | Web console for managing the object storage (S3-compatible) | `http://localhost:9001` |
| **Polaris Console** | Web interface for data management and Iceberg tables | `http://localhost:8181` |
| **Polaris Postgres** | Connection string to the internal Polaris database | `jdbc:postgresql://localhost:5432/POLARIS` |
| **Jupyter Lab** | Interactive development environment for Python/SQL | `http://localhost:8888` |
| **Spark UI** | Web interface for monitoring Spark applications | `http://localhost:4040` |



