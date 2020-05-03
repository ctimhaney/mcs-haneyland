FROM openjdk:8
RUN mkdir /opt/mcs-haneyland
COPY server.jar /opt/mcs-haneyland/
WORKDIR /opt/mcs-haneyland
ENTRYPOINT ["java", "-jar", "server.jar", "nogui"]
