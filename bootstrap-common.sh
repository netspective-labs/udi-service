#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

# Install pkgx standalone binary.
curl -Ssf https://pkgx.sh/$(uname)/$(uname -m).tgz | sudo tar xz -C ~/bin

# use chezmoi.toml template and set it up so that subsequent chezmoi installation can use it
# TODO: switch to https://www.chezmoi.io/reference/special-files-and-directories/chezmoi-format-tmpl/
export CHEZMOI_CONF=~/.config/chezmoi/chezmoi.toml
mkdir -p `dirname $CHEZMOI_CONF`
curl -fsSL https://raw.githubusercontent.com/udi-service/udi-service/main/dot_config/chezmoi/chezmoi.toml.example > $CHEZMOI_CONF
chmod 0600 $CHEZMOI_CONF

echo "Universal Data Infrastructure (UDI) Service Debian-typical boostrap complete. Installed:"
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
