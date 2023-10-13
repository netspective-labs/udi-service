# Universal Data Infrastructure (UDI) Service Setup

Code and governance for deploying Universal Data Infrastructure as a Service (UDIaaS). UDIaaS is a batteries included pre-configured PostgreSQL ecosystem with a highly opinionated Infrastructure as Code (IaC) deployment model for traditional 3-tier business applications. UDIaaS is ideal for modern web front-ends that need limited or zero middleware for data services and rely almost entirely on PostgreSQL for their backend (including heavy use of stored procedures, FDWs, polyglot languages, and other native PostgreSQL capabilities).

This is a [chezmoi](https://www.chezmoi.io/) and [asdf](https://asdf-vm.com/)-based setup for UDIaaS deployment on a Linux-like operating systems. 

## Setup the operating system (WSL2 Method)

If you're using Windows 10/11 with WSL2, create a "disposable" Linux instance using Powershell CLI or Windows Store. This means everything done here should be scripted, with the scripts stored in GitHub for easy re-running through Fish shell or `chezmoi`.

Linux versions:

Any Debian-based distro which supports Fish Shell 3.6+ should also work, including Ubuntu 22.04 LTS, Kali and Debian 11+ with Fish upgrades, etc.

If you're using Windows WSL, you can use these commands to install/uninstall our preferred distro:

```powershell
$ wsl --unregister Ubuntu-22.04
$ wsl --install -d Ubuntu-22.04
```

If you're using a Debian-based distro you should be able to run this repo in any Debian user account. It will probably work with any Linux-like OS but has only been tested on Debian-based distros (e.g. Kali Linux and Ubuntu 22.04 LTS).

## One-time setup

Bootstrap our preferred Ubuntu environment with required utilities (be sure to use `bootstrap-admin-debian.sh` or `bootstrap-admin-kali.sh` if you're not using Ubuntu):

```bash
cd $HOME && sudo apt-get -qq update && sudo apt-get install curl -y -qq && \
   sudo apt-get -qq update && sudo apt-get -qq install -y lsb-release && \
   curl -fsSL https://raw.githubusercontent.com/RinshadKAsharaf/udi-service/master/bootstrap-admin-ubuntu.sh | bash
```

Once the admin (`sudo`) part of the boostrap is complete, continue with non-admin:

```bash
curl -fsSL https://raw.githubusercontent.com/RinshadKAsharaf/udi-service/master/bootstrap-common.sh | bash
```

We use [chezmoi](https://www.chezmoi.io/) with templates to manage our dotfiles across multiple diverse machines, securely. The `bootstrap-*` script has already created the `chezmoi` config file which you should personalize _before installing_ `chezmoi`. See [chezmoi.toml Example](dot_config/chezmoi/chezmoi.toml.example) to help understand the variables that can be set and used across chezmoi templates.

```bash
vim.tiny ~/.config/chezmoi/chezmoi.toml
```

Install `chezmoi` and generate configuration files based on values in UDIaaS `chezmoi` templates:

```bash
sh -c "$(curl -fsSL git.io/chezmoi)" -- init --apply RinshadKAsharaf/udi-service
```

We prefer `Fish` as the default shell and `Oh My Posh` as the CLI prompts theme manager. These are configured automatically by `chezmoi`'s first-time configuration. You should switch your user's default shell to `Fish` by running:

```bash
chsh -s /usr/bin/fish
exit
```

## TODO (Roadmap)

- Ansible
- Docker desktop integration
- Docker containers
- GHCR

## Secrets Management

* Generate [GitHub personal access tokens](https://github.com/settings/tokens) and update `$HOME/.config/chezmoi/chezmoi.toml` file (this file is created at installation and is private to the user). Then, run `chez apply` to regenerate all configuration files that use the global `chezmoi.toml` file.
* `$HOME/.pgpass` should follow [PostgreSQL .pgpass](https://tableplus.com/blog/2019/09/how-to-use-pgpass-in-postgresql.html) rules for password management.

## Maintenance

Regularly run, or when `github.com/RinshadKAsharaf/udi-service` repo is updated:

```bash
chez upgrade
chez update
```
