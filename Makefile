.PHONY: stow-dotfiles
stow-dotfiles:
	stow --restow -v files

.PHONY: install-full
install-full: install-spacemacs stow-dotfiles install-packages-linux install-npm-packages

.PHONY: stow-dotfiles-force
stow-dotfiles-force:
	stow --restow --adopt -v files

.PHONY: stow-uninstall
stow-uninstall:
	stow --delete -v files

.PHONY: install-spacemacs
	git clone git@github.com:topher200/spacemacs.git ~/.emacs.d

.PHONY: install-packages-linux
install-packages-linux:
	./linux/install-packages.sh

.PHONY: install-npm-packages
install-npm-packages:
	npm install --global \
		pure-prompt \
		yaml2json
