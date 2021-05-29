FROM ubuntu:20.10

# install sudo and bash: https://github.com/dwyl/learn-circleci/issues/12
RUN apt-get update && apt-get install -y sudo
RUN ls -al /bin/sh && sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh && ls -al /bin/sh

RUN sudo apt-get install -y make

USER gitpod
WORKDIR /home/gitpod/dotfiles

COPY install-packages.sh ./
COPY Makefile ./
RUN make install-packages

COPY files files
RUN make stow

CMD bash