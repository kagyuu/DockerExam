#!/bin/bash

docker rm `docker ps -a | grep Exited | grep -v vol | awk '{print $1}'`
