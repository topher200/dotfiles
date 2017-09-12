#! /bin/bash

find . -type d -d 1 -not -path '*/\.*' | sed -e 's/\.\///' | xargs stow -R
