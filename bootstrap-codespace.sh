#!/bin/bash
set -Eeuox pipefail

echo Installing fast packages at "$(date)"
make install-fast-packages || true
echo Finished installing fast packages at "$(date)"

# use our .zshrc file, not codespace's
echo removing ~/.zshrc
mv ~/.zshrc ~/.zshrc.codespace-orig.bak

echo Running stow at "$(date)"
make
echo Finished stow at "$(date)"
