!#/bin/sh
DataSleuth
sudo docker run -dt -v $(pwd)/notebooks:/notebooks -p 80:8888 -e $PROXYHOST -e $PASSWORD -dt nyx
