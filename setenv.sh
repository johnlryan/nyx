#!/bin/sh
# Add Proxyhost info to various files
#


# Set proxy variables here by uncommenting the line and adding your proxy setings
#
# MY_CORP_NETWORK=hp.com
# PROXY_PORT=8080
# PROXYHOST=proxy.$MY_CORP_NETWORK:$PROXY_PORT
ETC=/tmp


if [ "$PROXYHOST" ]; then

	echo "Acquire::http::Proxy \"http"$PROXYHOST"/\";" >> $ETC/apt.conf
	echo "Acquire::https::Proxy \"https:"$PROXYHOST"/\";" >> $ETC/apt.conf
	echo "Acquire::ftp::Proxy \"ftp://"$PROXYHOST"/\";" >> $ETC/apt.conf
	
	echo "http_proxy=http://"$PROXYHOST >>$ETC/environment
	echo "https_proxy=https://"$PROXYHOST >>$ETC/environment
	echo "ftp_proxy=ftp://"$PROXYHOST >>$ETC/environment
	echo "HTTP_PROXY=http://"$PROXYHOST >>$ETC/environment
	echo "HTTPS_PROXY=https://"$PROXYHOST >>$ETC/environment
	echo "FTP_PROXY=ftp://"$PROXYHOST >>$ETC/environment
	echo "http-proxy=http://"$PROXYHOST >>$ETC/environment
	echo "https-proxy=https://"$PROXYHOST >>$ETC/environment
	echo "ftp-proxy=ftp://"$PROXYHOST >>$ETC/environment
	echo "no_proxy=.sock,localhost,127.0.0.1,::1,192.168.59.103,"$MY_CORP_NETWORK
	echo "!/bin/bash" >> /bin/gitproxy
	echo "# $1 = hostname, $2 = port" >> /bin/getproxy
	echo "PROXY=myproxy.example.com" >> /bin/getproxy
	echo "exec socat STDIO SOCKS4:$PROXY:$1:$2 " >> /bin/getproxy
	sudo -E apt-get socat git
	sudo -E git config --global core.gitProxy gitproxy
	echo "GIT_PROXY_COMMAND=/usr/local/bin/git-proxy" >>$ETC/environment
	echo "export GIT_PROXY_IGNORE="example.com"" >>$ETC/environment

	# Subversion Setup
	# 
	# You'll need to have the following in your ~/.subversion/servers file:
	# [global]
	# http-proxy-exceptions = *.exception.com, www.internal-site.org
	# http-proxy-host = myproxy.example.com
	# http-proxy-port = 1080
	# You can also set http-proxy-username and http-proxy-password if your proxy requires authentication.
	# CVS Setup (this seems useless since we don't have any recipe requiring cvs now)
	# 
	# For CVS checkouts to work correctly, you need to add some options in your Poky local.conf file.
	# CVS_PROXY_HOST = "myproxy.example.com"
	# CVS_PROXY_PORT = "1080"
fi

# Set other system wide  environment variables here (ubuntu)
# 
	echo "ENV DEBIAN_FRONTEND=noninteractive" >> $ETC/environment
