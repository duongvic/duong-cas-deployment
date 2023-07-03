## Step 1: Build Kong API Gateway

```sh
export KONG_NETWORK=kong-net
export KONG_DB_IMG=caspostgres
docker network create ${KONG_NETWORK}
cd postgres
docker build --no-cache -t ${KONG_DB_IMG} .

cd ../
docker-compose down --volumes
docker-compose up -d
```

Result:
![Login](./images/kong-login.png)

## Step 2: How to config API Gateway
![Upstream](./images/kong-arch.png)


### 1. Create Kong Upstream
Click UPSTREAMS tab in the sidebar then click Create Upstream
![Upstream](./images/kong-upstream-1.png)

Result:
![Upstream](./images/kong-upstream-2.png)

### 2. Create Kong Upstream target
Click Kong upstream detail then create new target
![Upstream](./images/kong-upstream-target-1.png)

Result:
![Upstream](./images/kong-upstream-target-2.png)

### 3. Create Kong Service
Click SERVICES tab in the sidebar then click Create Service
![Upstream](./images/kong-service-1.png)

Result:
![Upstream](./images/kong-service-2.png)


### 3. Create Kong Service
Click Kong service detail then create new router to service
![Upstream](./images/kong-router-1.png)

Result:
![Upstream](./images/kong-router-2.png)