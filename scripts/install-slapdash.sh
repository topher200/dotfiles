#!/bin/bash

sudo apt update
sudo apt install libfuse2

wget https://slapdash.com/download/linux -O /tmp/slapdash-linux
chmod +x /tmp/slapdash-linux
/tmp/slapdash-linux
