FROM openjdk:8-jdk-slim-buster as stage

ENV DENODO_INSTALL_FILE denodo-install-7.0.zip
ENV DENODO_UPDATE_JAR denodo-v70-update.jar
ENV DENODO_RESPONSE_FILE response_file_7_0.xml
ENV DENODO_HOME /opt/denodo

# Copy Installation Files
COPY [ "${DENODO_INSTALL_FILE}", "${DENODO_UPDATE_JAR}", "${DENODO_RESPONSE_FILE}", "/tmp/" ]

RUN apt-get update && \
    apt-get install -y unzip && \
    mkdir -p /opt/denodo && \
    unzip /tmp/${DENODO_INSTALL_FILE} -d /tmp && \
    mkdir -p /tmp/denodo-install-7.0/denodo-update && \
    mv /tmp/${DENODO_UPDATE_JAR} /tmp/denodo-install-7.0/denodo-update/denodo-update.jar && \
    chmod 755 /tmp/denodo-install-7.0/*.sh && \
    /tmp/denodo-install-7.0/installer_cli.sh install --autoinstaller /tmp/response_file_7_0.xml

COPY [ "entrypoint.sh", "configure.sh", "${DENODO_HOME}/" ]

# Custom Version of server.xml to support SSL Enablement at runtime.
COPY [ "tomcat-server.xml", "${DENODO_HOME}/resources/apache-tomcat/conf/server.xml" ]

RUN chmod 755 ${DENODO_HOME}/*.sh

CMD [ "/bin/bash" ]

FROM openjdk:8-jdk-slim-buster

ENV DENODO_HOME /opt/denodo

RUN groupadd -r -g 1001 denodo && \
    useradd -r -u 1001 -g denodo -d ${DENODO_HOME} denodo

COPY --from=stage --chown=denodo:denodo ${DENODO_HOME} ${DENODO_HOME}

USER denodo
WORKDIR ${DENODO_HOME}

# Denodo VQL Server Derby Database
VOLUME ${DENODO_HOME}/metadata/db

# TODO Add Volume for Denodo JDBC Drivers

# The following ports are used by Denodo:
# Server                    Port

# Virtual DataPort Server
# Admin Server/JDBC port    9999
# ODBC port                 9996
# Auxiliary port            9997
# Shutdown port             9998

# Web Container
# HTTP Web container port   9090
# HTTPS Web container port  9443
# Shutdown port             9099
# JMX port                  9098
# Auxiliary JMX port        9097

# Scheduler
# Server Ports              8998,9000
# Shutdown Port             8999
EXPOSE 9999 9996 9997 9998 9090 9443 9099 9098 9097 8998 9000 8999

CMD [ "./entrypoint.sh" ]