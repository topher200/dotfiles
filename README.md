# Topher's dotfiles repo [![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/topher200/dotfiles)

managed by GNU stow

## Installation instructions

```console
sudo apt-get install make
git clone git@github.com:topher200/dotfiles.git
cd dotfiles
make install-all-packages
make
```

### Install tmux plugins

- Prefix + I (`ctrl-a I`)

### How to create a new user

This isn't quite related to dotfiles, but w/e.

```console
NEWUSER=topher
sudo useradd --create-home -G sudo -s /usr/bin/zsh $NEWUSER
sudo passwd $NEWUSER
sudo su - $NEWUSER
# 'q' to not create .zshrc file
# install https://github.com/topher200/dotfiles
```

## Updates

### Automated updates

```console
./update_external_dependencies.sh
```

### zsh-custom git repo clones

- [Pure prompt](https://github.com/sindresorhus/pure)

  - I have local modifications which need to be re-applied after update.

  ```console
  rm -r files/zsh-custom/pure && git clone https://github.com/sindresorhus/pure files/zsh-custom/pure --depth 1 && rm -rf files/zsh-custom/pure/.git
  ```
