# install packages
sudo apt install -y \
    autojump \
    fzf \
    silversearcher-ag \
    stow \
    tig \
    zsh

# install python packages
sudo apt install -y python3-dev python3-pip python3-setuptools python3-venv

sudo pip3 install thefuck

# pet snippet manager
wget https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb -O /tmp/pet.deb
sudo dpkg -i /tmp/pet.deb

# set shell to zsh
chsh -s `which zsh`
