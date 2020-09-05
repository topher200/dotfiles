.PHONY: install
install-full: install-spacemacs stow install-packages-linux

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
	git clone git@github.com:topher200/spacemacs.git ~/.emacs.d

.PHONY: install-packages-linux
install-packages-linux:
	./linux/install-packages.sh
