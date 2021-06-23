dotfiles repo
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/topher200/dotfiles)

# dotfiles
managed by GNU stow

## Installation instructions
```
sudo apt-get install make
git clone git@github.com:topher200/dotfiles.git # requires .ssh keys
cd dotfiles
make install
```

### install spacemacs
```
rm -r ~/.emacs.d # deleting the .emacs dir created by 'stow'
git clone git@github.com:topher200/spacemacs.git ~/.emacs.d
```

### gem packages
- tmuxinator

### How to create a new user
This isn't quite related to dotfiles, but w/e.
```
NEWUSER=topher
sudo useradd --create-home -G sudo -s /usr/bin/zsh $NEWUSER
sudo passwd $NEWUSER
sudo su - $NEWUSER
# 'q' to not create .zshrc file
# install https://github.com/topher200/dotfiles
```

# updates
## zsh-custom git repo clones
- https://github.com/sindresorhus/pure
  - `rm -r files/zsh-custom/pure && git clone https://github.com/sindresorhus/pure files/zsh-custom/pure --depth 1 && rm -rf files/zsh-custom/pure/.git`

- `git clone https://github.com/Aloxaf/fzf-tab files/.oh-my-zsh/custom`

## gem packages
- update with `gem list`

## tmux plugins
```
git clone https://github.com/tmux-plugins/tpm files/.tmux/plugins/tpm
```
