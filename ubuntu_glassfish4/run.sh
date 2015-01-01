#!/bin/bash

docker run -p 10022:22 -p 12812:2812 -p 14848:4848 -p 18080:8080 \
--link testdb:PGSQL \
-d atsushi/ubuntu_glassfish41
