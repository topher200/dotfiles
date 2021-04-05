# install packages
sudo apt install -y \
    autojump \
    curl \
    fzf \
    htop \
    httpie \
    pspg \
    shellcheck \
    silversearcher-ag \
    stow \
    tig \
    tmux \
    tree \
    unp \
    zsh

# install python packages
sudo apt install -y python3-dev python3-pip python3-setuptools python3-venv
sudo pip3 install \
    thefuck

# pet snippet manager
if [ ! -f /tmp/pet.deb ]; then
    wget https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb -O /tmp/pet.deb
    sudo dpkg -i /tmp/pet.deb
fi

# install fzf, from https://github.com/junegunn/fzf#using-git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --completion --no-update-rc --no-key-bindings

# install vim plugins
vim +PlugInstall +qall

# install fusuma
sudo apt install -y \
    libinput-tools \
    ruby \
    xdotool
sudo gem install fusuma
# NEXT: add fusuma to startup programs

# set shell to zsh
chsh -s `which zsh`
