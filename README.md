# vscode in docker 
# iFoundSilentHouse JS docker dev env
This is a docker-container with the [vscode](https://code.visualstudio.com/)-editor.

## Why you should use this?

* You can commit your vs-code settings and plugins and share them on different devices
* You always have your dependencies installed inside the container
* You can be sure that vs-code cannot access any unwanted files on your device
* You can limit the internet-access to ensure no data will be send to microsoft

## Requirements
* *sh interface (tested on bash)
* configured docker. If you want to run script not with superuser but with your user:
    - `sudo usermod -a -G docker alice` // replace alice with your username
    - logout of your user session, then log back in

## Install
1. `git clone https://github.com/iFoundSilentHouse/vscode-in-docker.git`
2. `cd vscode-in-docker`
3. Edit the `config.bash` and include your workspace-folder
4. `./run.bash --rebuild` on the first time OR when you want to rebuild.
5. (It will take about 15 minutes when it runs for the first time.)
6. `./run.bash` to load existing container

## Preferences
Paste all your vscode configuration files to `/workspace/userdata`. Just folders. With code-oss packaged they're in ~/.config/Code - OSS/. **Every rebuild your configuration made in GUI will be overriden with files from `workspace/userdata`.** So make sure you copied it from your container.

## Security warning
See run.sh:36

Ubuntu-alpine switch, POSIX /bin/sh translation, correction with shellcheck, option to not rebuild container every time, configuration copying, permissions handling by iFoundSilentHouse.
