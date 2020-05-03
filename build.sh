MINECRAFT_SERVER_URL="https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"

JAVA_HEAP_INITIAL="-Xms2G"
JAVA_HEAP_MAX="-Xmx6G"

DOCKER_IMAGE_TAG="colinthaney/mcs-haneyland:latest"

SCRIPT_DIR=$(dirname $(realpath $0))

test -f environment.sh

if [ $? -eq 0 ]
then
  source environment.sh
fi

which wget > /dev/null 2>&1

if [ $? -ne 0 ]
then
  echo "please install wget"
  exit 1
fi

test -f server.jar

if [ $? -ne 0 ]
then
  wget $MINECRAFT_SERVER_URL
fi

if [ $UID -ne 0 ]
then
  echo "Communicating with the docker daemon requires privilege escalation"
  exit 1
fi

docker build -t $DOCKER_IMAGE_TAG $SCRIPT_DIR
