#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

#-----------------------------------------------------------------------------
# "Typical" Debian admin (`sudo`) boostrap. This should work in most Debian-
# based distros but if you want a faster Kali (Rolling)-based bootstrap you
# should use `bootstrap-admin-kali.sh`.
#-----------------------------------------------------------------------------

# check and exit if not proper distribution
export LINUXD=`lsb_release -a | head -n 1 | awk '{print $3}' | tr '[:upper:]' '[:lower:]'`
if [ "$LINUXD" != "debian" ]; then
    echo "** ERROR **: This scripts only Debian Linux distributions."
    lsb_release -a
    exit -1
else
     echo "Proceeding with installation of acceptable $LINUXD distribution."
fi

# For older Debian distros that don't have it, get add-apt-repository command (Ubuntu has it, Debian doesn't)
sudo apt-get -qq update
sudo apt-get -y -qq install software-properties-common wget jq gpg

# we expect the latest Fish shell so be sure to use package archive provided by the fish project not older Debian packages;
# Debian and Ubuntu have older packages, openSUSE repository supports Debian packages
DEBIAN_VERSION_MAIN=`grep VERSION_ID /etc/os-release | awk -F= '{print $2}' | sed -e 's/^"//' -e 's/"$//'`
FISH_VERSION_MAIN=`curl -s https://api.github.com/repos/fish-shell/fish-shell/releases/latest | jq -r .tag_name | cut -c1`
echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/${FISH_VERSION_MAIN}/Debian_${DEBIAN_VERSION_MAIN}/ /" | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:${FISH_VERSION_MAIN}/Debian_${DEBIAN_VERSION_MAIN}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null

# get the latest packages meta data
sudo apt-get -qq update

# install true "essentials" that will be universally applicable
sudo apt-get -y -qq install fish curl git pass unzip bzip2 tree make bsdmainutils time gettext-base

# install database clients for accessing remote databases
sudo apt-get -y -qq install postgresql-client default-mysql-client

# install "build essentials" that are needed to build local binaries
sudo apt-get -y -qq install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libxml2-dev xz-utils tk-dev libxmlsec1-dev libreadline-dev libffi-dev libbz2-dev liblzma-dev llvm

# install common diagramming as code tools
sudo apt-get -y -qq install graphviz

# install ansible automation tool
sudo apt-get -y -qq install ansible

# install git-extras in bootstrap instead of chezmoi since sudo is required for global setup;
# right now chezmoi `run_once_install-packages.sh.tmpl` doesn't require sudo but if it does later,
# move `git-extras` install into `run_once_install-packages.sh.tmpl` for convenience
curl -sSL https://raw.githubusercontent.com/tj/git-extras/master/install.sh | sudo bash /dev/stdin

# install latest osQuery using Debian package in bootstrap instead of chezmoi since it's Debian-specific
OSQ_VERSION=`curl -fsSL https://api.github.com/repos/osquery/osquery/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`
OSQ_APT_CACHE=/var/cache/apt/archives
OSQ_DEB_FILE=osquery_${OSQ_VERSION}-1.linux_amd64.deb
sudo curl -fsSL -o $OSQ_APT_CACHE/$OSQ_DEB_FILE https://pkg.osquery.io/deb/$OSQ_DEB_FILE
sudo dpkg -i $OSQ_APT_CACHE/$OSQ_DEB_FILE

echo "Universal Data Infrastructure (UDI) ServiceDebian-typical boostrap complete. Installed:"
echo " - fish, curl, git, gitextras, jq, pass, unzip, bzip2, tree, and make"
echo " - osquery (for endpoint observability)"
echo ""
echo "Continue installation by installing non-admin (user) packages:"
echo "--------------------------------------------------------------"
echo ""
echo '$ curl -fsSL https://raw.githubusercontent.com/udi-service/udi-service/master/bootstrap-common.sh | bash'
