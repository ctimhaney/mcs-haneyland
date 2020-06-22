FROM openjdk:8-jre-alpine
RUN mkdir /opt/mcs-haneyland
COPY server.jar /etc/
WORKDIR /opt/mcs-haneyland
ENTRYPOINT ["java", "-jar", "/etc/server.jar", "nogui"]
