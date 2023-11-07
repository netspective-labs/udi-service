# Universal Data Infrastructure (UDI) Service Setup

Code and governance for deploying Universal Data Infrastructure as a Service (UDIaaS). UDIaaS is a batteries included pre-configured PostgreSQL ecosystem with a highly opinionated Infrastructure as Code (IaC) deployment model for traditional 3-tier business applications. UDIaaS is ideal for modern web front-ends that need limited or zero middleware for data services and rely almost entirely on PostgreSQL for their backend (including heavy use of stored procedures, FDWs, polyglot languages, and other native PostgreSQL capabilities).

![Screenshot](udi-service-architecture.drawio.svg)

This is a [chezmoi](https://www.chezmoi.io/), [ansible](https://www.ansible.com/) and [docker](https://www.docker.com/) based setup for UDIaaS deployment on a Linux-like operating systems. 

## Setup the operating system

- Debian 12 64 bit operating system.
- Ubuntu 22.04 64 bit operating system.
  
Any Debian-based distro (Default - Debian 12) which supports Fish Shell 3.6+ should also work, including Ubuntu 22.04 LTS, Kali with Fish upgrades, etc.

Everything done here should be scripted, with the scripts stored in GitHub for easy re-running through Fish shell or `chezmoi`.

## One-time setup

Bootstrap our preferred Ubuntu environment with required utilities (be sure to use `bootstrap-admin-debian.sh` or `bootstrap-admin-kali.sh` if you're not using Ubuntu):

```bash
cd $HOME && sudo apt-get -qq update && sudo apt-get install curl -y -qq && \
   sudo apt-get -qq update && sudo apt-get -qq install -y lsb-release && \
   curl -fsSL https://raw.githubusercontent.com/udi-service/udi-service/master/bootstrap-admin-ubuntu.sh | bash
```

Once the admin (`sudo`) part of the boostrap is complete, continue with non-admin:

```bash
curl -fsSL https://raw.githubusercontent.com/udi-service/udi-service/master/bootstrap-common.sh | bash
```

We use [chezmoi](https://www.chezmoi.io/) with templates to manage our dotfiles across multiple diverse machines, securely. The `bootstrap-*` script has already created the `chezmoi` config file which you should personalize _before installing_ `chezmoi`. See [chezmoi.toml Example](dot_config/chezmoi/chezmoi.toml.example) to help understand the variables that can be set and used across chezmoi templates.

```bash
vim.tiny ~/.config/chezmoi/chezmoi.toml
```

Install `chezmoi` and generate configuration files based on values in UDIaaS `chezmoi` templates:

```bash
sh -c "$(curl -fsSL git.io/chezmoi)" -- init --apply udi-service/udi-service
```
***
### This now installs the entire Universal Data Infrastructure (UDI) Utilities + Docker containers using Ansible
***

Now, exit the current session by running below command and this should switch your default shell to `Fish` upon your next login:

```bash
exit
```

We can then use docker ps to list the UDIaaS Docker containers

```bash
docker ps
```

`pgpass` utility can be used to login to the UDIaaS database

```bash
fish -c "psql $(pgpass psql-fmt --conn-id='UDIAAS_DB')"
```

## TODO (Roadmap)

- Prepare GitHub Actions for custom images
- GHCR container image registry

## Secrets Management

* Generate [GitHub personal access tokens](https://github.com/settings/tokens) and update `$HOME/.config/chezmoi/chezmoi.toml` file (this file is created at installation and is private to the user). Then, run `chez apply` to regenerate all configuration files that use the global `chezmoi.toml` file.
* `$HOME/.pgpass` should follow [PostgreSQL .pgpass](https://tableplus.com/blog/2019/09/how-to-use-pgpass-in-postgresql.html) rules for password management.

## Maintenance

Regularly run, or when `github.com/udi-service/udi-service` repo is updated:

```bash
chez upgrade
chez update
```
