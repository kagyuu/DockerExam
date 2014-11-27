#!/bin/bash

docker run -p 10022:22 -p 12812:2812 -p 5432:5432 -p 10080:80 \
-v /home/core/git/DockerExam/ubuntu_mapserver/maps:/opt/maps:rw \
-d atsushi/ubuntu_mapserver
