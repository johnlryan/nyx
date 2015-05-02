#!/bin/sh
#
# Docker does not support the passing of environment variables at build time so we have to adjust
# our build for those people that live behind a proxy server.  We have two cases:
#
# Case 1 you need to build the docker container behind a firewall for what ever reason
# Case 2 you can download teh generic image but need to run your container behind a proxy
# Case 3 your devops team can add files to your container as needed for its environmentc
#
# Case 1:
docker build -t nyx .

