# install packages
sudo apt install -y \
     autojump \
     stow \
     tig

# install python packages
sudo apt install -y python3-dev python3-pip python3-setuptools
sudo pip3 install thefuck

# pet snippet manager
wget https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb
sudo dpkg -i pet_0.3.6_linux_amd64.deb
