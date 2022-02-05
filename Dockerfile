FROM gitpod/workspace-base:latest

# add my user user; sudo access with no password required
# https://dev.to/emmanuelnk/using-sudo-without-password-prompt-as-non-root-docker-user-52bg
RUN sudo adduser --disabled-password --gecos '' topher
# overwrite gitpod's home setting
ENV HOME=/home/topher
RUN usermod --home /home/topher topher
RUN sudo adduser topher sudo
USER topher
WORKDIR /home/topher/dev/dotfiles

RUN sudo apt-get install -y make

COPY --chown=topher install-packages.sh ./
COPY --chown=topher Makefile ./
RUN make install-packages

COPY --chown=topher . /home/topher/dev/dotfiles
RUN sudo chown topher -R -f /home/topher/dev/dotfiles
# hidden files are ignored by COPY by default
COPY --chown=topher .circleci /home/topher/dev/dotfiles/.circleci
COPY --chown=topher .dockerignore /home/topher/dev/dotfiles/.dockerignore
COPY --chown=topher .gitignore /home/topher/dev/dotfiles/.gitignore
COPY --chown=topher .gitpod.yml /home/topher/dev/dotfiles/.gitpod.yml

RUN make stow

CMD bash
