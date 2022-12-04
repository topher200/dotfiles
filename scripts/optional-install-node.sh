#!/bin/bash

set -Eeuox pipefail

# We don't need to install node/npm, but if we do want to we should install it
# with nvm (which is like npm, but keeps global installs local to the current
# user).

# install nvm
# from https://github.com/nvm-sh/nvm#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# set up nvm in the current shell.
# (we could have also just spawned a new shell)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# install node
nvm install node
