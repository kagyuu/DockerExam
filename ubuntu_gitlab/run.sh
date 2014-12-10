#!/bin/bash

# docker run -p 10022:22 -p 12812:2812 -p 10080:80 --volumes-from vol_gitlab01 -d atsushi/gitlab
docker run -p 11022:22 -p 11080:80 -d atsushi/gitlab
