#!/bin/sh
# notebook.sh script to run our dockerized ipython notebook
NOTEBOOKDIR=$HOME/notebooks
# DOCKER='boot2docker ssh sudo -E docker'
DOCKER='docker'
CONTAINERPORT=8888
LOCALPORT=8443
IP=`boot2docker ip`
CONTAINERTAG=nyx
URL=https://$IP:$LOCALPORT

echo running command:
echo $DOCKER run -v $NOTEBOOKDIR:/notebooks -p $LOCALPORT:$CONTAINERPORT -dt $CONTAINERTAG
$DOCKER  run -v $NOTEBOOKDIR:/notebooks -p $LOCALPORT:$CONTAINERPORT -dt $CONTAINERTAG
docker ps
echo open -a firefox -g https://$URL
echo sleeping five seconds to boot container
sleep 5
open -a firefox -g $URL
