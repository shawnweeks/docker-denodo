#!/bin/bash

replaceProperty() {
    local file=$1
    local key=$2
    local value=$3

    if ! grep -R "^[#]*\s*${key}=.*" ${file} > /dev/null; then
        echo "APPENDING because '${key}' not found"
        echo "${key}=${value}" >> ${file}
    else
        echo "SETTING because '${key}' found already"
        sed -ir "s~^[#]*\s*${key}=.*~${key}=${value}~" ${file}
    fi
}

# Enable Security Features
# DENODO_SSL_ENABLED
# DENODO_SSL_KEYSTORE
# DENODO_SSL_KEYSTORE_PASS
# DENODO_SSL_TRUSTSTORE
# DENODO_SSL_TRUSTSTORE_PASS
setupSecurity() {
    if [[ ${DENODO_SSL_ENABLED:=false} = true ]]
    then
        echo "INFO: Enabling SSL"
        if [[ -z $DENODO_SSL_KEYSTORE || -z  $DENODO_SSL_KEYSTORE_PASS || -z $DENODO_SSL_TRUSTSTORE || -z $DENODO_SSL_TRUSTSTORE_PASS ]]
        then
            echo "ERROR: Missing Required Denodo SSL Parameters"
            echo "ERROR: DENODO_SSL_KEYSTORE, DENODO_SSL_KEYSTORE_PASS, DENODO_SSL_TRUSTSTORE and DENODO_SSL_TRUSTSTORE_PASS are required."
            exit 1
        else
            FILE=${DENODO_HOME}/conf/vdp/VDBConfiguration.properties
            replaceProperty ${FILE} com.denodo.security.ssl.enabled ${DENODO_SSL_ENABLED}
            replaceProperty ${FILE} com.denodo.security.ssl.keyStore ${DENODO_SSL_KEYSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.keyStorePassword ${DENODO_SSL_KEYSTORE_PASS}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStore ${DENODO_SSL_TRUSTSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStorePassword ${DENODO_SSL_TRUSTSTORE_PASS}

            FILE=${DENODO_HOME}/conf/scheduler/ConfigurationParameters.properties
            replaceProperty ${FILE} com.denodo.security.ssl.enabled ${DENODO_SSL_ENABLED}
            replaceProperty ${FILE} com.denodo.security.ssl.keyStore ${DENODO_SSL_KEYSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.keyStorePassword ${DENODO_SSL_KEYSTORE_PASS}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStore ${DENODO_SSL_TRUSTSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStorePassword ${DENODO_SSL_TRUSTSTORE_PASS}

            FILE=${DENODO_HOME}/conf/arn-index/ConfigurationParameters.properties
            replaceProperty ${FILE} com.denodo.security.ssl.enabled ${DENODO_SSL_ENABLED}
            replaceProperty ${FILE} com.denodo.security.ssl.keyStore ${DENODO_SSL_KEYSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.keyStorePassword ${DENODO_SSL_KEYSTORE_PASS}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStore ${DENODO_SSL_TRUSTSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStorePassword ${DENODO_SSL_TRUSTSTORE_PASS}

            FILE=${DENODO_HOME}/resources/apache-tomcat/conf/tomcat.properties
            replaceProperty ${FILE} com.denodo.security.ssl.enabled ${DENODO_SSL_ENABLED}
            replaceProperty ${FILE} com.denodo.tomcat.http.port 0
            replaceProperty ${FILE} com.denodo.tomcat.https.port 9443
            replaceProperty ${FILE} com.denodo.security.ssl.keyStore ${DENODO_SSL_KEYSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.keyStorePassword ${DENODO_SSL_KEYSTORE_PASS}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStore ${DENODO_SSL_TRUSTSTORE}
            replaceProperty ${FILE} com.denodo.security.ssl.trustStorePassword ${DENODO_SSL_TRUSTSTORE_PASS}
        fi
    else
        return 0
    fi
}

setupSecurity