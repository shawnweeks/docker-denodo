1. Download the following two files from https://community.denodo.com/express/download/
    ```
    denodo-express-install-7_0.zip
    denodo-express-lic-7_0-201906.lic
    ```

2. Run the following command to build the image.
    ```shell
    docker build -t denodo:7.0-express .
    ```
3. Create Self Signed Keystore. To be able to use this you will need to set your program to trust it. For testing purposes I suggest you avoid it but removing the lines begining with "-e" from the step 4.
    ```shell
    keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass changeit -keypass changeit -validity 360 -keysize 2048
    ```
4. Run Container
    ```shell
    docker run -it --rm \
        --name denodo \
        -e DENODO_SSL_ENABLED="true" \
        -e DENODO_SSL_KEYSTORE="/tmp/keystore.jks" \
        -e DENODO_SSL_KEYSTORE_PASS="changeit" \
        -e DENODO_SSL_TRUSTSTORE="/tmp/truststore.jks" \
        -e DENODO_SSL_TRUSTSTORE_PASS="changeit" \
        -v $(pwd)/keystore.jks:/tmp/keystore.jks \
        -v $(pwd)/keystore.jks:/tmp/truststore.jks \
        -p 9999:9999 \
        -p 9997:9997 \
        -p 9996:9996 \
        -p 9090:9090 \
        -h localhost \
        denodo:7.0-express
    ```
