#!/bin/bash

docker run -p 443:443 -v /var/log/nginx:/home/atsushi/git/DockerExam/ubuntu_registry_proxy/log:rw -d atsushi/registry_proxy
