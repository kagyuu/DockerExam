#!/bin/bash

docker run -p 8080:8080 -v /var/jenkins_home:/var/jenkins_home atsushi/jenkins

