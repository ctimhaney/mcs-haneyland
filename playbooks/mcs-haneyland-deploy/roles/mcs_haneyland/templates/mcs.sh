#!/bin/sh
CONTAINER_NAME="{{ server_name }}"
VOLUME_NAME="{{ docker_volume_name }}"
DOCKER_IMAGE_TAG="{{ docker_image_tag }}"
SCRIPT_DIR=$(dirname $(realpath $0))

if [ $UID -ne 0 ]
then
  echo "Communicating with the docker daemon requires privilege escalation"
  exit 1
fi

test -f $SCRIPT_DIR/environment.sh

if [ $? -eq 0 ]
then
  source $SCRIPT_DIR/environment.sh
fi

status() {
  docker container inspect $CONTAINER_NAME
}

start() {
  status > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    docker run -d -it \
    --rm \
    --publish 25565:25565 \
    --env JAVA_OPTIONS='-Xms{{ java_opts_Xms }} -Xmx{{ java_opts_Xmx }}' \
    --name $CONTAINER_NAME \
    --mount source=$VOLUME_NAME,target=/opt/mcs-haneyland \
    colinthaney/mcs-haneyland:latest
  else
    echo "$CONTAINER_NAME already started"
  fi
}

stop() {
  status > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    docker container stop $CONTAINER_NAME
  else
    echo "$CONTAINER_NAME not running"
  fi
}

restart() {
  status > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    docker container restart $CONTAINER_NAME
  else
    start
  fi
}

if [ "$1" == "status" ]
then
  status
elif [ "$1" == "start" ]
then
  start
elif [ "$1" == "stop" ]
then
  stop
elif [ "$1" == "restart" ]
then
  restart
else
  echo "usage: mcs.sh status|start|stop|restart"
fi
