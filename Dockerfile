FROM gitpod/workspace-base:latest

# RUN sudo adduser topher sudo
WORKDIR /home/gitpod/dotfiles

RUN sudo apt-get install -y make

COPY scripts/install-fast-packages.sh ./scripts/install-fast-packages.sh
RUN ./scripts/install-fast-packages.sh
COPY scripts/install-slow-packages.sh ./scripts/install-slow-packages.sh
RUN ./scripts/install-slow-packages.sh

COPY . .
# hidden files are ignored by COPY by default
COPY .circleci .circleci
COPY .dockerignore .dockerignore
COPY .gitignore .gitignore
COPY .gitpod.yml .gitpod.yml

RUN make

CMD zsh
