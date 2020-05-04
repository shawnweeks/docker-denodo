FROM openjdk:8-jdk-slim-buster as stage

ENV DENODO_HOME /opt/denodo

COPY denodo-express-install-7_0.zip /tmp/denodo-express-install.zip
COPY denodo-express-lic-7_0-201906.lic /tmp/denodo.lic
COPY denodo-response.xml /tmp/

RUN apt-get update && \
    apt-get install -y unzip && \
    mkdir -p /opt/denodo && \
    unzip /tmp/denodo-express-install.zip -d ${DENODO_HOME} && \
    cp /tmp/denodo.lic ${DENODO_HOME} && \
    chmod 755 ${DENODO_HOME}/denodo-install-7.0/installer_cli.sh && \
    ${DENODO_HOME}/denodo-install-7.0/installer_cli.sh install --autoinstaller /tmp/denodo-response.xml && \
    groupadd -r -g 1001 denodo && \
    useradd -r -u 1001 -g denodo denodo
    

# Speeding Up Build
COPY --chown=denodo:denodo [ "startup.sh", "configure.sh", "${DENODO_HOME}/" ]
RUN  chmod 755 ${DENODO_HOME}/*.sh

# Multi-Part Build to Reduce Final Image Size
FROM openjdk:8-jdk-slim-buster

ENV DENODO_HOME /opt/denodo

COPY --from=stage /etc/passwd /etc/passwd
COPY --from=stage /etc/group /etc/group
COPY --from=stage --chown=denodo:denodo ${DENODO_HOME} ${DENODO_HOME}

USER denodo
WORKDIR ${DENODO_HOME}

# The following ports used by VDP are exposed:
# 9999,9997 - RMI (JDBC, AdminTool, ...)
# 9996 - ODBC
# 9090 - Web Services
EXPOSE 9999 9997 9996 9090

CMD [ "sh", "-c", "/opt/denodo/startup.sh" ]