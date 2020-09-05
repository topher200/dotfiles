dotfiles repo

# dotfiles
managed by GNU stow

## Installation instructions
```
sudo apt-get install make
git clone git@github.com:topher200/dotfiles.git # requires .ssh keys
cd dotfiles
make install-full
```

### install fzf
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
From https://github.com/junegunn/fzf#using-git

### install spacemacs
```
rm -r ~/.emacs.d # deleting the .emacs dir created by 'stow'
git clone git@github.com:topher200/spacemacs.git ~/.emacs.d
```

### gem packages
- bropages
- tmuxinator

### How to create a new user
This isn't quite related to dotfiles, but w/e.
```
sudo useradd --create-home -G sudo -s /usr/bin/zsh torrentscraper
sudo passwd torrentscraper
sudo su - torrentscraper
# 'q' to not create .zshrc file
# install https://github.com/topher200/dotfiles
```

# Manually installing stuff instead

## linux
- make install-packages-linux

## macos: brew packages
- cd macos
- update: './regenerate-brewfile.sh'
- install with `brew bundle install`
- check packages with `brew bundle check`
- freeze with `brew bundle dump`

# updates
## zsh-custom git repo clones
- https://github.com/sindresorhus/pure

## gem packages
- update with `gem list`

## tmux plugins
```
git clone https://github.com/tmux-plugins/tpm files/.tmux/plugins/tpm
```
