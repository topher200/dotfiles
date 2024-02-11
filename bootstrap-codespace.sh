#!/bin/bash
set -Eeuox pipefail

echo Installing fast packages at "$(date)"
make install-fast-packages || true
echo Finished installing fast packages at "$(date)"
