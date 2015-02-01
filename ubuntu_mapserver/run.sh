#!/bin/bash

docker run -p 10022:22 -p 12812:2812 -p 5432:5432 -p 10080:80 \
-v /home/atsushi/git/DockerExam/ubuntu_mapserver/maps:/opt/maps:rw \
-v /home/atsushi/git/DockerExam/ubuntu_mapserver/mapcache:/opt/mapcache:rw \
-v /home/atsushi/git/DockerExam/ubuntu_mapserver/html:/var/www/html:rw \
-d atsushi/ubuntu_mapserver
