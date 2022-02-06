.PHONY: stow
stow:
	stow --restow -v --target ~ files

.PHONY: install
install: install-all-packages stow

.PHONY: test
test:
	# envrc is used here to set env vars such that pre-commit is on the PATH
	BASH_ENV="/home/topher/envrc" ./test/run-precommit-on-all-files.sh
	./test/run_shellcheck.sh
	./test/test-install-packages.sh

.PHONY: test-in-docker
test-in-docker: docker-build
	docker run --rm -it dotfiles make test

.PHONY: stow-uninstall
stow-uninstall:
	stow --delete -v files

.PHONY: install-all-packages
install-all-packages:
	./scripts/install-base-packages.sh
	./scripts/install-packages.sh

.PHONY: docker-build
docker-build:
	DOCKER_BUILDKIT=1 docker build --tag dotfiles --cache-from topher200/dotfiles:buildcache --build-arg BUILDKIT_INLINE_CACHE=1 .

.PHONY: docker-repl
docker-repl: docker-build
	docker run --rm -it dotfiles zsh
