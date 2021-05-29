FROM ubuntu:20.10

# install sudo and bash: https://github.com/dwyl/learn-circleci/issues/12
RUN apt-get update && apt-get install -y sudo
RUN ls -al /bin/sh && sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh && ls -al /bin/sh

# add gitpod user; sudo access with no password required
# https://dev.to/emmanuelnk/using-sudo-without-password-prompt-as-non-root-docker-user-52bg
RUN adduser --disabled-password --gecos '' gitpod
RUN adduser gitpod sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER gitpod
WORKDIR /home/gitpod/dotfiles

RUN sudo apt-get install -y make

COPY install-packages.sh ./
COPY Makefile ./
RUN make install-packages

COPY files files
RUN make stow

CMD bash
