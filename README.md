# Personal private spacemacs

This repo contains my personal settings for spacemacs, including
a .spacemacs file

## Installation

### Linux
Run `setup.sh`

### Windows
Windows doesn't like `ln -s` to make symbolic directory links. The command needs to be something more like
`mklink /J d:\path\to\home\.emacs.d\private d:\path\to\this\dir`

The .spacemacs file installation should work fine.