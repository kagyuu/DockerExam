#!/bin/bash

docker run -p 10022:22 -p 10080:80 -p 12812:2812 \
-d atsushi/cent6_zabbix
