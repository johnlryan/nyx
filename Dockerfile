# Dockerfile
# Author John Ryan
# Copyright = MIT Lisc
# Date: 4/15/2015
# Comment lines start with #
#
# Start with a minimal (current) ubuntu image maintained by  Docker inc.
FROM ubuntu
EXPOSE 8888
 
# You can mount your own SSL certs as necessary here
ENV PEM_FILE /key.pem
# $PASSWORD will get `unset` within notebook.sh, turned into an IPython style hash
ENV PASSWORD Dont make this your default
ENV USE_HTTP 0

# Create a mount point for our notebooks
VOLUME /notebooks
# Make our home directory /notebooks
WORKDIR /notebooks
 
# Create a default password – we will change this on the commandline but incase we forget!
ENV PASSWORD datascience!
 
# Add proxy settings
ADD  ./setenv.sh /tmp/
RUN sudo -E /tmp/setenv.sh
 
# make sure our software packages are patched and up to date
RUN sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
RUN sudo apt-get update
RUN sudo apt-get upgrade -y
 
# Add Python
RUN sudo apt-get -y install python3
RUN sudo apt-get -y install python3-pip
RUN sudo sudo ln -s /usr/bin/pip3 /usr/bin/pip
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y socat
# These lines don't need to be run because of the $GIT_PROXY_COMMAND variable set in setenv.sh
# RUN sudo -E git config --global http.proxy $http_proxy
# RUN sudo -E git config --global https.proxy $https_proxy
 
# for consistencey and security we should compile it ourselves but this doesn't work
# because compiling from sources doesn't work during the "Big Split"
# RUN git clone https://github.com/ipython/ipython/releases
#
# Instead we have to "temprarily" tust the current builds
RUN sudo -E pip install "ipython[all]"
RUN sudo -E apt-get -y build-dep python3-matplotlib
RUN sudo -E pip install numpy
RUN sudo -E pip install python-dateutil
RUN sudo -E pip install pytz
RUN sudo -E pip install numexpr
RUN sudo -E pip install bottleneck
RUN sudo -E pip install cython
RUN sudo -E apt-get -y install gfortran
RUN sudo -E apt-get -y install libopenblas-dev
RUN sudo -E apt-get -y install liblapack-dev
RUN sudo -E pip install scipy
RUN sudo -E pip install sqlalchemy
RUN sudo apt-get -y install git
RUN mkdir /usr/src/matplotlib
RUN sudo -E git clone https://github.com/matplotlib/matplotlib /usr/src/matplotlib
RUN cd /usr/src/matplotlib; sudo python ./setup.py install
RUN sudo -E pip install statsmodels
RUN sudo -E pip install openpyxl
RUN sudo -E pip install boto
RUN sudo -E pip install python-gflags
RUN sudo -E pip install google-api-python-client
RUN sudo -E pip install setuptools
RUN sudo -E apt-get -y build-dep python-lxml
RUN sudo -E pip install lxml
RUN sudo -E pip install beautifulsoup4
RUN sudo -E pip install blaze
#  There is a bug in the vertica-sqlalchemy package so install from source and patch
# RUN sudo -E pip install vertica-sqlalchemy
RUN sudo -E sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"
RUN mkdir /usr/src/vertica-sqlalchemy
RUN sudo -E git clone git://github.com/jamescasbon/vertica-sqlalchemy /usr/src/vertica-sqlalchemy
RUN sudo -E apt-get install -y unixODBC unixODBC-dev
RUN cd  /usr/src/vertica-sqlalchemy; sudo python ./setup.py install
RUN sudo -E apt-get install -y libmysql-java
RUN sudo -E pip install pandas
RUN sudo -E apt-get install -y unixODBC unixODBC-dev
RUN cd  /usr/src/vertica-sqlalchemy; sudo python ./setup.py install
RUN sudo -E apt-get install -y libmysql-java
RUN sudo -E apt-get install -y python-mysqldb
RUN sudo -E apt-get install -y unixodbc-dev
RUN sudo -E apt-get install -y python-dev
RUN sudo -E apt-get install -y libpq-dev
RUN sudo -E apt-get install -y unixodbc
RUN sudo -E apt-get install -y freetds-dev
RUN sudo -E apt-get install -y tdsodbc
RUN sudo -E pip install https://pyodbc.googlecode.com/files/pyodbc-3.0.7.zip
RUN sudo -E apt-get install -y mysql-server
RUN sudo -E pip install https://github.com/PyMySQL/PyMySQL/archive/master.zip
# sudo -E apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN sudo -E apt-get install -y software-properties-common
RUN sudo -E apt-get install -y python-software-properties
# RUN sudo -E add-apt-repository -y ppa:marutter/rrutter
RUN sudo -E echo "deb http://cran.r-project.org/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
RUN sudo -E apt-get update
RUN sudo -E apt-get install -y --force-yes r-base
RUN sudo -E apt-get install -y --force-yes r-base-dev
RUN sudo -E pip install rpy2
RUN sudo -E apt-get install -y wget
RUN sudo -E apt-get install -y default-jre
RUN sudo -E apt-get install -y default-jdk
# RUN sudo -E pip install mysql-connector-python
ENV DEBIAN_FRONTEND=noninteractive
RUN sudo echo mysql-apt-config mysql-apt-config/enable-repo select mysql-5.5-dmr | sudo debconf-set-selections
RUN wget http://dev.mysql.com/get/mysql-apt-config_0.3.3-2ubuntu14.04_all.deb ; sudo dpkg --install mysql-apt-config_0.3.3-2ubuntu14.04_all.deb
RUN sudo git clone https://github.com/mysql/mysql-connector-python.git /usr/src/mysql-connector-python
RUN cd  /usr/src/mysql-connector-python; sudo python ./setup.py install
RUN sudo git clone https://github.com/farcepest/moist.git /usr/src/moist
RUN sudo apt-get install -y libmysqlclient-dev
RUN cd  /usr/src/moist; sudo python ./setup.py install
RUN cd  /usr/src/vertica-sqlalchemy; sudo python ./setup.py install
RUN sudo -E pip3 install mysql-connector-python --allow-external mysql-connector-python
# Uncomment this if you have the Vertica connector
# ADD  ./vertica-client-7.1.1-0.linux.x86_64.tar.gz /
ADD ./odbc.ini /etc/
# These files have to be on your Docker host or you have to install them in the container
ADD ./odbcinst.ini /etc/
ADD ./vertica.ini /etc/
# Maybe we don't need this --> RUN sudo -E pip install MySQL-python
# RUN wget http://cran.csiro.au/src/contrib/likelihood_1.5.tar.gz /usr/src
# https://github.com/hadley/ggplot2/archive/master.zip
# RUN sudo R CMD INSTALL /usr/src/likelihood_1.5.tar.gz
 
# ---------------- Doesn't work yet ------------------------
# RUN sudo -E pip install hpy5
# RUN sudo -E pip install jasonschema
# RUN sudo -E pip install pytables
# RUN sudo -E pip install bcols
 
# CMD ipython notebook --ip=* --no-browser --port=8888
ADD runcmd.sh /
RUN chmod u+x /runcmd.sh
CMD ["/runcmd.sh"]
