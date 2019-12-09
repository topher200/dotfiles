.PHONY: install
install:
	stow --delete --stow -v files

.PHONY: install-force
install-force:
	stow --delete --stow --adopt -v files

.PHONY: uninstall
uninstall:
	stow --delete -v files
