#!/bin/bash

docker run -p 10022:22 -p 12812:2812 -p 5432:5432 -d atsushi/ubuntu_postgresql
