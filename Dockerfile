FROM sdd330/maven-oraclejdk

MAINTAINER Yang Leijun <yang.leijun@gmail.com>

ENV DOCKER_COMPOSE_VERSION 1.2.0

ADD https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 \
    /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose

# Define mount point to access data on host system.
VOLUME ["/workspace"]

# Command
CMD ["mvn"]