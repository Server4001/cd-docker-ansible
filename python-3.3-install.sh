#!/usr/bin/env bash

# Python 3.3 install.
sudo yum groupinstall -y 'development tools'
sudo yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel
wget http://www.python.org/ftp/python/3.3.3/Python-3.3.3.tar.xz
xz -d Python-3.3.3.tar.xz
tar -xvf Python-3.3.3.tar
rm Python-3.3.3.tar
cd Python-3.3.3/
./configure
make
sudo make altinstall
cd /home/vagrant
sudo rm -rf Python-3.3.3/
sudo ln -s /usr/local/bin/python3.3 /bin/python3.3

# Install Setup tools and PIP for Python 3.
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
tar -xvf setuptools-1.4.2.tar.gz
rm setuptools-1.4.2.tar.gz
cd setuptools-1.4.2/
sudo python3.3 setup.py install
sudo ln -s /usr/local/bin/easy_install /usr/bin/easy_install
cd /home/vagrant
sudo rm -rf setuptools-1.4.2/
sudo easy_install pip
sudo ln -s /usr/local/bin/pip /usr/bin/pip

sudo pip install virtualenv boto boto3 awscli django djangorestframework django-cors-headers
