dotfiles repo

# dotfiles
managed by GNU stow

Installation instructions:
1. install 'stow' (`brew install stow`)
1. install 'make'
1. 'make install-full'

# manually installing stuff

## linux
- make install-packages-linux

## macos: brew packages
- cd macos
- update: './regenerate-brewfile.sh'
- install with `brew bundle install`
- check packages with `brew bundle check`
- freeze with `brew bundle dump`

# gem packages
- update: 'gem list'
- bropages
- tmuxinator

# install spacemacs
- git clone git@github.com:topher200/spacemacs.git ~/.emacs.d
(requires deleting the .emacs dir created by 'stow')

# updates
we have a clone of 'pure-prompt' in the zsh-custom directory. update with `https://github.com/sindresorhus/pure`
