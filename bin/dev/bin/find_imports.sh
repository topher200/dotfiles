#! /bin/bash

ag "$1" ~/dev/wordstream | grep import | cut -d: -f 3 | head -n 1

