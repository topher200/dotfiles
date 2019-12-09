.PHONY: install
install:
	stow -R -v files

.PHONY: uninstall
uninstall:
	stow -D -v files
