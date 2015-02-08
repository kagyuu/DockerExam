#!/bin/bash

ID=`docker run -p 10022:22 -p 12812:2812 -d atsushi/cent6_monit_ssh`
echo $ID
