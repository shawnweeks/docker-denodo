# Docker Image for Denodo 7
To complete and run this build you will need the following files.
1. denodo-install-7.0.zip
2. denodo-v70-update.jar for the latest patch.
3. Valid Denodo License - Express Will Work

### Build Image
```shell
docker build -t denodo:7.0 .
```

### Without SSL
```shell
docker run -it \
    --name denodo \
    -p 9999:9999 \
    -p 9998:9998 \
    -p 9997:9997 \
    -p 9996:9996 \
    -p 9443:9443 \
    -v $(pwd)/denodo.lic:/opt/denodo/conf/denodo.lic \
    -v denodo_vdp_volume:/opt/denodo/metadata/db \
    denodo:7.0
```

### With SSL
```shell
docker run -it \
    --name denodo \
    -h localhost \
    -p 9999:9999 \
    -p 9998:9998 \
    -p 9997:9997 \
    -p 9996:9996 \
    -p 9443:9443 \
    -v $(pwd)/denodo.lic:/opt/denodo/conf/denodo.lic \
    -v denodo_vdp_volume:/opt/denodo/metadata/db \
    -v $(pwd)/keystore.jks:/opt/denodo/keystore.jks \
    -v $(pwd)/truststore.jks:/opt/denodo/truststore.jks \
    -e DENODO_SSL_ENABLED="true" \
    -e DENODO_SSL_KEYSTORE="/opt/denodo/keystore.jks" \
    -e DENODO_SSL_KEYSTORE_PASS="changeit" \
    -e DENODO_SSL_TRUSTSTORE="/opt/denodo/keystore.jks" \
    -e DENODO_SSL_TRUSTSTORE_PASS="changeit" \
    denodo:7.0
```

# TODO - Add Documentation for Web UI