.PHONY: install
install:
	stow --restow -v files

.PHONY: install-force
install-force:
	stow --restow --adopt -v files

.PHONY: uninstall
uninstall:
	stow --delete -v files
