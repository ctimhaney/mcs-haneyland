MINECRAFT_SERVER_URL="https://launcher.mojang.com/v1/objects/7361a24df069a06748844cc7483c35d4abd2d80c/server.jar"
MINECRAFT_SERVER_VERSION="1.16"
DOCKER_IMAGE_NAME="colinthaney/mcs-haneyland"
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

docker build -t $DOCKER_IMAGE_NAME:latest $SCRIPT_DIR
if [ $? -eq 0 ]
then
  docker tag $DOCKER_IMAGE_NAME:latest $DOCKER_IMAGE_NAME:$MINECRAFT_SERVER_VERSION
fi
