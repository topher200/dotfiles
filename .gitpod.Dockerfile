FROM gitpod/workspace-base

# configure locals
RUN sudo apt-get update && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y locales
RUN sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sudo dpkg-reconfigure --frontend=noninteractive locales && \
    sudo update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

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

# TODO: this is failing when running in gitpod. commenting out for now
# RUN make stow

CMD bash
