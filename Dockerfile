FROM ubuntu:20.10

# install sudo and bash: https://github.com/dwyl/learn-circleci/issues/12
RUN apt-get update && apt-get install -y sudo
RUN ls -al /bin/sh && sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh && ls -al /bin/sh

# create the gitpod user early so gitpod doesn't re-write /etc/sudo
# from https://github.com/gitpod-io/workspace-images/blob/master/base/Dockerfile#L38
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

# add my user user; sudo access with no password required
# https://dev.to/emmanuelnk/using-sudo-without-password-prompt-as-non-root-docker-user-52bg
RUN adduser --disabled-password --gecos '' topher
RUN adduser topher sudo
USER topher
WORKDIR /home/topher/dotfiles

RUN sudo apt-get install -y make

COPY install-packages.sh ./
COPY Makefile ./
RUN make install-packages

COPY files files
RUN make stow

CMD bash