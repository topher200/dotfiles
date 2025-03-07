# Topher's dotfiles repo [![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/topher200/dotfiles)

managed by GNU stow

## Installation instructions

```console
sudo apt-get install git make vim
git clone git@github.com:topher200/dotfiles.git ~/
cd dotfiles
make install-all-packages
make
```

### Optional

- Start tmux and install tmux plugins: Prefix + I (`ctrl-a I`)
- `$ scripts/install-chrome.sh`
- `$ scripts/install-kitty.sh`
- run `$ syncthing` and add the remote device. choose 'auto accept' and 'sync default folder'
  - This includes `secretsrc`
- Install SaveDesktop (use Applications app), import saved archive from a different computer
- Install Gnome extensions: `sudo apt install gnome-browser-connector`; https://extensions.gnome.org/local/
- Install vim plugin: open Vim and run `:Copilot setup`
- Install VSCode: `$ sudo snap install code --classic`
- `sudo apt install gnome-tweaks` (although the tweaks themselves get migrated
  already with SaveDesktop)
- add to `/etc/sysctl.conf`:

```
fs.inotify.max_user_instances = 1048576
fs.inotify.max_user_watches = 1048576
```

- install zoom. https://zoom.us/download?os=linux, download, `$ sudo apt install ~/Downloads/zoom...`
- disable annoying zoom window setting:

```
$ vim ~/snap/zoom-client/current/.config/zoomus.conf
$ ... OR ...
$ vim .config/zoomus.conf
enableMiniWindow=false
```

- grab graphite user config

```
$ mkdir -p ~/.config/graphite
$ cp ~/Sync/.config/graphite/user_config ~/.config/graphite
```

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

### Install Alacritty theme

```
$ mkdir -p ~/.config/alacritty/themes
$ git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```
