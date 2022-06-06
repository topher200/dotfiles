FROM gitpod/workspace-base:latest

# RUN sudo adduser topher sudo
WORKDIR /home/gitpod/dotfiles

RUN sudo apt-get install -y make

COPY --chown=gitpod scripts/install-fast-packages.sh ./scripts/install-fast-packages.sh
RUN ./scripts/install-fast-packages.sh
COPY --chown=gitpod scripts/install-slow-packages.sh ./scripts/install-slow-packages.sh
RUN ./scripts/install-slow-packages.sh

COPY --chown=gitpod . .
# hidden files are ignored by COPY by default
COPY --chown=gitpod .circleci .circleci
COPY --chown=gitpod .dockerignore .dockerignore
COPY --chown=gitpod .gitignore .gitignore
COPY --chown=gitpod .gitpod.yml .gitpod.yml

RUN make

CMD zsh
