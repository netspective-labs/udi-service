#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

# install latest asdf and direnv integration in bootstrap instead of chezmoi since installation is not idempotent
ASDF_DIR=$HOME/.asdf
ASDF_VERSION=`curl -fsSL https://api.github.com/repos/asdf-vm/asdf/tags | jq '.[0].name' -r` \
    bash -c 'git -c advice.detachedHead=false clone --quiet https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch ${ASDF_VERSION}'
. $ASDF_DIR/asdf.sh
$ASDF_DIR/bin/asdf plugin-add direnv
PATH=$PATH:$ASDF_DIR/bin $ASDF_DIR/bin/asdf direnv setup --shell fish --version latest
PATH=$PATH:$ASDF_DIR/bin $ASDF_DIR/bin/asdf global direnv latest
mkdir -p ~/.config/fish/completions
ln -s $ASDF_DIR/completions/asdf.fish ~/.config/fish/completions

# use chezmoi.toml template and set it up so that subsequent chezmoi installation can use it
# TODO: switch to https://www.chezmoi.io/reference/special-files-and-directories/chezmoi-format-tmpl/
export CHEZMOI_CONF=~/.config/chezmoi/chezmoi.toml
mkdir -p `dirname $CHEZMOI_CONF`
curl -fsSL https://raw.githubusercontent.com/udi-service/udi-service/main/dot_config/chezmoi/chezmoi.toml.example > $CHEZMOI_CONF
chmod 0600 $CHEZMOI_CONF

echo "Universal Data Infrastructure (UDI) Service Debian-typical boostrap complete. Installed:"
echo " - asdf (version manager for languages, runtimes, etc.)"
echo " - direnv (per-directory environment variables loader, via asdf)"
echo ""
echo "    FIRST: Prepare for \`chezmoi\` editing config:"
echo "    --------------------------------------------"
echo "    $ vim.tiny ~/.config/chezmoi/chezmoi.toml"
echo ""
echo "    THEN: Continue installation by bootstrapping \`chezmoi\` from GitHub:"
echo "    -------------------------------------------------------------------"
echo "    $ sh -c \"\$(curl -fsSL git.io/chezmoi)\" -- init --apply udi-service/udi-service"
echo ""
text=" You've completed deployed the Universal Data Infrastructure (UDI) Utilities + Docker containers using Ansible "

# Calculate the width of the box
text_length=${#text}
box_width=$((text_length + 4))

# Create the top border of the box
top_border=""
for ((i = 1; i <= box_width; i++)); do
    top_border+="*"
done
# Display the box and the text
echo "$top_border"
echo "* $text *"
echo "$top_border"
echo ""
echo ""
echo "    EXIT: SSH session and re-login. This should switch your default shell to \`Fish\`"
echo "    -------------------------------------------------------------------------------"
echo "    $ exit"
echo ""
echo ""
