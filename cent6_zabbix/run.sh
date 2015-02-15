#!/bin/bash

docker run -p 10022:22 -p 10080:80 -p 10051:10051 -p 12812:2812 --volumes-from vol_zabbix \
-d atsushi/cent6_zabbix
