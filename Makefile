.PHONY: install
install: stow-dotfiles install-npm-packages

.PHONY: stow-dotfiles
stow-dotfiles:
	stow --restow -v files

.PHONY: stow-dotfiles-force
stow-dotfiles-force:
	stow --restow --adopt -v files

.PHONY: uninstall
uninstall-stow:
	stow --delete -v files

.PHONY: install-packages-linux
install-packages-linux:
	./linux/install-packages.sh

.PHONY: install-npm-packages
install-npm-packages:
	npm install \
		pure-prompt \
		yaml2json
