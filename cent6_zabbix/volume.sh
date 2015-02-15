#!/bin/bash
VOLUME_NAME="vol_zabbix"

docker run --name $VOLUME_NAME -i atsushi/cent6_zabbix \
echo $VOLUME_NAME created

