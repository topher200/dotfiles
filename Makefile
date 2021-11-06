.PHONY: stow
stow:
	stow --restow -v --target ~ files

.PHONY: install
install: install-packages stow

.PHONY: test
test:
	./test/run_shellcheck.sh
	./test/test-install-packages.sh

.PHONY: stow-force
stow-force:
	stow --restow --adopt -v files

.PHONY: stow-uninstall
stow-uninstall:
	stow --delete -v files

.PHONY: install-spacemacs
install-spacemacs:
	# rm -r ~/.emacs.d # deleting the .emacs dir created by 'stow'
	git clone git@github.com:topher200/spacemacs.git ~/.emacs.d
	make stow

.PHONY: install-packages
install-packages:
	./install-packages.sh

.PHONY: docker
docker:
	docker build --tag dotfiles .
	docker run --rm -it dotfiles /bin/bash
