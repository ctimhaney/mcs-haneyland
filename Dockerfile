FROM openjdk:19-jdk-slim
RUN mkdir /opt/mcs-haneyland
COPY server.jar /etc/
WORKDIR /opt/mcs-haneyland
ENTRYPOINT java $JAVA_OPTIONS -jar /etc/server.jar nogui
