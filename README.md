foldersigner-ais docker image
================================

Docker Image to digitally sign or timestamp PDF's in a specific folder over Swisscom All-in Signing Service.

It will monitor a folder for new PDF's older than one 1 minute to ensure proper upload/copying. The digitally signed PDF will be put in an output folder with the same name as well as a <<file>.result.txt containting the result of the operation. On success the original file will be removed from the monitored folder.

The source and destination folder can be specified with the Docker Volume parameter -v:

* Source: /opt/work/in
* Destination: /opt/work/in


## Run

To start: 
```
 $ docker run --name foldersigner-ais -it -d \
   -e CUSTOMER_ID="IAM-Test" \
   -e CUSTOMER_KEY=kp1-iam-signer \
   -v "/home/user/mycert.crt":/opt/work/mycert.crt \
   -v "/home/user/mycert.key":/opt/work/mycert.key \
   -v "/home/user/_in_":/opt/work/in \
   -v "home/user/_out_":/opt/work/out \
   swisscomtds/foldersigner-ais:latest
```
optional environment settings:
```
   -e DIGEST_METHOD=SHA256 \
   -e SIGNATURE_TYPE=sign \
   -e TZ=Europe/Paris \
```

Infos about the `-e` settings:

* CUSTOMER_ID: Customer identification towards All-in Signing service (provided by Swisscom)
* CUSTOMER_KEY: Customer signing key (provided by Swisscom)
* DIGEST_METHOD: Digest Method [SHA256 (default), SHA384, SHA512]
* SIGNATURE_TYPE: Signature Type [sign (default), timestamp]
* TZ: Timezone of the docker image [Europe/Paris, ...]


## Show logs
```
 $ docker logs foldersigner-ais
```

