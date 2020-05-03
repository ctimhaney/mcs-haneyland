#/bin/sh
CONTAINER_NAME="mcs_haneyland_container"
VOLUME_NAME="dankcraft-server-files"

# look for the volume

# look for CONTAINER_NAME
docker container inspect $ > /dev/null 2>&1

if [ $? -eq 0 ]
then
  docker container start $CONTAINER_NAME
else
  docker run -d \
  -p 25565:25565 \
  --name $CONTAINER_NAME \
  --mount source=my-vol,target=/opt/mcs-haneyland \
  colinthaney/mcs-haneyland:latest
fi
