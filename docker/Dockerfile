FROM alpine:latest

# https://github.com/cmiles74/docker-vscode
# https://hub.docker.com/r/joengenduvel/docker-vscode/dockerfile
# https://github.com/pubkey/vscode-in-docker

##
## alpine stuff
##

RUN apk update \
  && apk add bash bash-completion dbus

# install nodejs and npm
RUN apk add --no-cache npm

# npm autocomplete https://docs.npmjs.com/cli/v6/commands/npm-completion
RUN npm completion >> ~/.bashrc

# npm modules
RUN npm install -g eslint
RUN npm install -g typescript

# install vscode itself (from package code-oss)
RUN apk add --no-cache code-oss --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

##
## /alpine stuff
##

##
## vscode stuff
##

RUN apk add --no-cache msttcorefonts-installer fontconfig && \
update-ms-fonts && \
  fc-cache -f

# change user so vscode does not run as root
ENV USER=dev
ENV GROUP=developers
RUN addgroup -S $GROUP
RUN adduser -S $USER -G $GROUP
USER $USER

# vscode-extensions
RUN code-oss --install-extension vscodevim.vim

USER root

##
## /vscode stuff
##

WORKDIR /workspace
COPY ../userdata/* /workspace/userdata

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT /bin/sh /usr/local/bin/entrypoint.sh
