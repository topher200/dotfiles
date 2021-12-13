# TODO: make this inherit from ubuntu?
FROM gitpod/workspace-full

# configure locals
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

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
