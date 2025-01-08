#!/bin/sh

SCRIPT="$(readlink -e "$0")"
SCRIPTPATH="$(dirname "$SCRIPT")"

echo "# SCRIPTPATH:"
echo "$SCRIPTPATH"

. "$SCRIPTPATH"/config.sh

# throw if workspace-folder not set
if [ "${WORKSPACE}" = "/" ]; then
   echo "# Please set your workspace-folder at the config.sh"
   exit 1
else
  echo "# Workspace-folder: ${WORKSPACE}"
fi

MODULENAME="js_devenv"

echo "# Starting vs-code-in-docker.."

rebuild() {
	echo "# delete old container"	
	# use the kill command instead of stop to make it faster
	docker kill $MODULENAME	
	docker rm $MODULENAME

	#build docker image
	echo "delete old image: $MODULENAME"
	#docker rmi $MODULENAME
	echo "building image"
	docker build -t $MODULENAME "$SCRIPTPATH"/docker
  
  mkdir -p "${WORKSPACE}"/userdata
  # SEQURITY WARNING. 
  # It was done to change files from main user and from docker user.
  # 
  # To make everything even more secure:
  # 1) add your host user to developers group
  # 2) comment next line and uncomment these:
  # chown :developers "${WORKSPACE}
  # chmod 770 "${WORKSPACE}
  chmod -R 777 "${WORKSPACE}"

  # clear logs
  echo "# clear logs"
  rm -rf userdata/logs/*
  
  cp -r ${SCRIPTPATH}/userdata/* ${WORKSPACE}/userdata/

	echo "# allow xHost"
	xhost +

	#make and run container
	echo "make container"
	echo "IMPORTANT: DONT close this terminal or vscode will close"

	# pass to current display set DISPLAY= if you're passing it through VNC
	XAUTHORITY=$(xauth info | grep "Authority file" | awk '{ print $3 }')
	docker run --name=$MODULENAME \
	-it \
	--privileged \
	-v $WORKSPACE:/workspace \
	--net=host \
	--device=/dev/dri \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
  -v $SCRIPTPATH/userdata:/userdata:Z \
	-e DISPLAY=$DISPLAY \
	$MODULENAME

	echo "# disallow xHost"
	xhost -
}

exec_existing() {
  if ! [ $(docker ps -a -q -f name="$MODULENAME") ]; then
    echo 'No '$MODULENAME' container found. Please run '$(basename "$0")' with `--rebuild` option'
    exit 1
  fi
  echo "# allow xHost"
	xhost +
  
  docker start -ai $MODULENAME

  echo "# disallow xHost"
	xhost -
}

cli_argparse() {
	echo $(basename "$0"): ERROR: "$@" 1>&2
	echo usage: $(basename "$0") '[--rebuild]' 1>&2
	exit 1
}

while :
do
    case "$1" in
	--rebuild) rebuild; break;;
	--) shift; break;;
	-*) cli_argparse "bad argument $1";;
	*) exec_existing; break;;
    esac
    shift
done
