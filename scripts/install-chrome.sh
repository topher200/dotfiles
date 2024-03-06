#!/bin/bash

# from https://www.geekersdigest.com/how-to-install-google-chrome-from-apt-repository/ (2024)
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/chrome.list
sudo apt-get update
sudo apt-get install google-chrome-stable
