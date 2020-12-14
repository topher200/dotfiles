.PHONY: install-full
install-full: stow install-packages

.PHONY: stow
stow:
	stow --restow -v files

.PHONY: stow-force
stow-force:
	stow --restow --adopt -v files

.PHONY: stow-uninstall
stow-uninstall:
	stow --delete -v files

.PHONY: install-spacemacs
	rm -r ~/.emacs.d # deleting the .emacs dir created by 'stow'
	git clone git@github.com:topher200/spacemacs.git ~/.emacs.d

.PHONY: install-packages
install-packages:
	./install-packages.sh
