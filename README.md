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

### Optional

- Install tmux plugins: Prefix + I (`ctrl-a I`)
- `scripts/install-chrome.sh`
- `scripts/install-kitty.sh`
- Download `secretsrc`
- Install Slapdash: https://slapdash.com/download/linux and add the binary to
  Startup Applications
- Add Flameshot as a startup application
- Install vim plugin: open Vim and run `:Copilot setup`
- Install Gnome extensions: https://extensions.gnome.org/local/
- Install VSCode: `$ sudo snap install code --classic`
- `sudo apt install gnome-tweaks` (although the tweaks themselves get migrated
  already with SaveDesktop)
- add to `/etc/sysctl.conf`:

```
fs.inotify.max_user_instances = 1048576
fs.inotify.max_user_watches = 1048576
```

- disable annoying zoom window setting:

```
$ vim snap/zoom-client/225/.config/zoomus.conf
enableMiniWindow=false
```

### Migrating between machines

- Use SaveDestop to migrate Gnome settings between machines (https://github.com/vikdevelop/SaveDesktop)

### How to create a new user

This isn't quite related to dotfiles but could be helpful.

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
