.PHONY: stow
stow:
	# temp adding --adopt to grab any existing files; existing files were
	# causing issues when running `make stow` during the prebuild in
	# .gitpod.Dockerfile. we probably want this to be a '--force' (which doesn't
	# seem to exist!). i'm afraid this solution might cause some files to be not
	# correctly overridden (ie we get a system zshrc)... might have to solve
	# that problem later
	stow --restow -v --adopt --target ~ files

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
