# Personal private spacemacs

This repo contains my personal settings for spacemacs, including
a .spacemacs file

## Installation

### Linux
Run `setup.sh`

### Windows
Windows doesn't like `ln -s` to make symbolic links. The commands needs to be something more like

`mklink /J c:\Users\<name>\.emacs.d\private d:\path\to\this\dir`
`mklink c:\Users\<name>\.spacemacs d:\path\to\this\dir\spacemacs`

These commands must be run from a Administrator command shell.