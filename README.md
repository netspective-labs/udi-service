# Universal Data Infrastructure (`UDI`) Service

Code and governance for deploying Universal Data Infrastructure as a Service (`UDIaaS`). `UDIaaS` is a _batteries included_ pre-configured PostgreSQL ecosystem with a highly opinionated Infrastructure as Code (`IaC`) deployment model for traditional 3-tier business applications. `UDIaaS` is ideal for modern web front-ends that need limited or zero middleware for data services and rely almost entirely on PostgreSQL for their backend (including heavy use of stored procedures, FDWs, polyglot languages, and other native PostgreSQL capabilities). 

## Setup the operating system

Server Prerequisites:

Ubuntu 22.04 64 bit operating system or similar Linux distribution on a virtual or physical machine is required.

    * RAM: minimum 2048  megabytes, preferably **4096 megabytes**
    * Storage: minimum 32 gigabytes, preferably **256 gigabytes**
    * Network: **Accessible outbound to the Internet** (both IPv4 and IPv6), inbound access not required
    * Firewall Route: The publically accessible IP should point to this server, a Linux firewall is automatically managed by the appliance
    * Software Packages: *OpenSSH is the only package that must be installed by default*
    * Default User Full Name: **UDIaaS User**
    * Default User Name: **udiaas**
    * Default User Password: **s3cR3T!**

## Prepare required GHCR docker images via GitHub Actions

 - https://github.com/udi-service/udi-service/actions

```
PostgreSQL UDIaaS GitHub Action - Dockerfile.UDIaaS 

Keycloak UDIaaS GitHub Action - Dockerfile.keycloak

PostGraphile UDIaaS GitHub Action - Dockerfile.postGraphile

TODO.. (other docker images if required)

pg_graphql

pg_later

...
```

## Prepare UDIaaS software installation

After Ubuntu operating system installation is completed, log into the server as the *UDIaaS user* (see above).

Bootstrap the core utilities ( Ansible, chezmoi, build-tools etc.. ):

    sudo apt update && sudo apt install net-tools curl -y && \
    curl https://raw.githubusercontent.com/udi-service/udi-service/main/master/bin/bootstrap.sh | bash

After bootstrap.sh is complete, restart the shell.


## Chezmoi - The Configuration Management Tool 

Initialize Chezmoi, 

`chezmoi init <your-preffered-directory>`

## Create an ansible variable template for environment variables

Create below template file for ansible variables with placeholders

`vim.tiny udiaas.secrets.ansible-vars.tmpl` 

```
DATABASE_URL={{ .chezmoi.secret.database_url }}
API_KEY={{ .chezmoi.secret.api_key }}
```

## Create or update secret in Chezmoi

`chezmoi edit-secret`

## Generate ansible variable file with Chezmoi

Run the following Chezmoi command to generate the Chezmoi template file to an actual YAML file

`chezmoi apply`

The below file can now be called in ansible like,

```bash
  vars_files:
    - /etc/udiaas-framework/udiaas.secrets.ansible-vars.yml
```
    
## Install docker daemon and deploy containers via ansible.

    cd /etc/udiaas-framework
    bash bin/install.sh

After setup is completed, reboot the server,

    sudo reboot
