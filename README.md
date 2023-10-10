# Universal Data Infrastructure (`UDI`) Service

Code and governance for deploying Universal Data Infrastructure as a Service (`UDIaaS`). `UDIaaS` is a _batteries included_ pre-configured PostgreSQL ecosystem with a highly opinionated Infrastructure as Code (`IaC`) deployment model for traditional 3-tier business applications. `UDIaaS` is ideal for modern web front-ends that need limited or zero middleware for data services and rely almost entirely on PostgreSQL for their backend (including heavy use of stored procedures, FDWs, polyglot languages, and other native PostgreSQL capabilities). 

##  Build the `UDIaaS` PostgreSQL Docker Image to GHCR

Run the following command to build the Docker image, tag it, and give it a name:

```bash
docker build -t ghcr.io/udi-service/udi-service/udiaas:15.4 -f Dockerfile.UDIaaS .
```

## Login to GitHub Container Registry (GHCR)

```bash
docker login ghcr.io
```

## Push the PostgreSQL Docker Image to GHCR

```bash
docker push ghcr.io/udi-service/udi-service/udiaas:15.4
```

