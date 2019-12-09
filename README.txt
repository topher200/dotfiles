dotfiles repo

# dotfiles
managed by GNU stow

Installation instructions:
1. install 'stow' (`brew install stow`)
1. install 'make'
1. 'make install'

# brew packages
- cd macos
- update: './regenerate-brewfile.sh'
- install with `brew bundle install`
- check packages with `brew bundle check`
- freeze with `brew bundle dump`

# gem packages
- update: 'gem list'
- bropages
- tmuxinator

# npm packages
- update: 'npm -g list --depth 0'
- yaml2json
- pure-prompt

# install spacemacs
- git clone git@github.com:topher200/spacemacs.git ~/.emacs.d
(requires deleting the .emacs dir created by 'stow')
