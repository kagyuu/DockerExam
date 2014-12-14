#!/bin/bash

docker run -p 10022:22 -p 12812:2812 -p 14343:4343 -p 18080:8080 -d atsushi/ubuntu_glassfish41
