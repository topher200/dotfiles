.PHONY: stow
stow:
	stow --restow -v --target ~ files

.PHONY: install
install: install-packages stow

.PHONY: test
test:
	pre-commit run --all-files
	./test/run_shellcheck.sh
	./test/test-install-packages.sh

.PHONY: test-in-docker
test-in-docker: docker-build
	# TODO: enable this when we know it passes
	# pre-commit run --all-files
	docker run --rm -it dotfiles ./test/run_shellcheck.sh
	docker run --rm -it dotfiles ./test/test-install-packages.sh

.PHONY: stow-uninstall
stow-uninstall:
	stow --delete -v files

.PHONY: install-spacemacs
install-spacemacs:
	# rm -r ~/.emacs.d # deleting the .emacs dir created by 'stow'
	git clone git@github.com:topher200/spacemacs.git ~/.emacs.d
	make stow

.PHONY: install-base-packages
install-base-packages:
	./scripts/install-base-packages.sh

.PHONY: install-packages
install-packages:
	./scripts/install-packages.sh

.PHONY: docker-build
docker-build:
	DOCKER_BUILDKIT=1 docker build --tag dotfiles --build-arg BUILDKIT_INLINE_CACHE=1 .

.PHONY: docker-run
docker-run: docker-build
	docker run --rm -it dotfiles zsh

