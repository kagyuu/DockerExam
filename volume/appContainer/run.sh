#!/bin/bash

docker run --volumes-from test1 -p 12812:2812 -p 10022:22 -p 10080:80 -d atsushi/httpd
