#!/bin/bash
#To accept self-signed CA, run following command on the docker host computer.

cat server-key.pem >> /etc/ssl/certs/ca-certificates.crt

