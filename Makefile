.PHONY: install
install:
	stow -R files

.PHONY: uninstall
uninstall:
	stow -D files
