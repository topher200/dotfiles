.PHONY: stow
stow:
	stow --restow -v --target ~ files

.PHONY: install-all-packages
install-all-packages: install-fast-packages install-slow-packages

.PHONY: install-fast-packages
install-fast-packages:
	./scripts/install-fast-packages.sh

.PHONY: install-slow-packages
install-slow-packages:
	./scripts/install-slow-packages.sh

.PHONY: lint
lint:
	# envrc is used here to set env vars such that pre-commit is on the PATH
	BASH_ENV="${HOME}/envrc" ./test/run-precommit-on-all-files.sh

.PHONY: test
test: lint
	./test/test-install-slow-packages.zsh

.PHONY: test-in-docker
test-in-docker: docker-build
	docker run --rm -it dotfiles make test

.PHONY: stow-uninstall
stow-uninstall:
	stow --delete -v files

.PHONY: docker-build
docker-build:
	DOCKER_BUILDKIT=1 docker build --tag dotfiles --cache-from topher200/dotfiles:buildcache --build-arg BUILDKIT_INLINE_CACHE=1 .

.PHONY: docker-push
docker-push:
	docker tag dotfiles topher200/dotfiles:buildcache
	docker push topher200/dotfiles:buildcache

.PHONY: docker-repl
docker-repl: docker-build
	docker run --rm -it dotfiles zsh
