# TODO: make this inherit from ubuntu?
FROM gitpod/workspace-full

# add my user user; sudo access with no password required
# https://dev.to/emmanuelnk/using-sudo-without-password-prompt-as-non-root-docker-user-52bg
RUN sudo adduser --disabled-password --gecos '' topher
RUN sudo adduser topher sudo
USER topher
WORKDIR /home/topher/dotfiles

RUN sudo apt-get install -y make

COPY --chown=topher install-packages.sh ./
COPY --chown=topher Makefile ./
RUN make install-packages

COPY --chown=topher . /home/topher/dotfiles
RUN sudo chown topher -R -f /home/topher/dotfiles
# hidden files are ignored by COPY by default
COPY --chown=topher .circleci /home/topher/dotfiles/.circleci
COPY --chown=topher .dockerignore /home/topher/dotfiles/.dockerignore
COPY --chown=topher .gitignore /home/topher/dotfiles/.gitignore
COPY --chown=topher .gitpod.yml /home/topher/dotfiles/.gitpod.yml

RUN make stow

CMD bash
