#!/usr/bin/env bash

# Python 3.4 install.
if [ ! -f /usr/local/bin/python3.4 ]; then
    sudo yum groupinstall -y 'development tools'
    sudo yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel
    cd /usr/src
    sudo wget https://www.python.org/ftp/python/3.4.4/Python-3.4.4.tgz
    sudo tar xzf Python-3.4.4.tgz
    sudo rm Python-3.4.4.tgz
    cd Python-3.4.4/
    ./configure
    make
    sudo make altinstall
    sudo ln -s /usr/local/bin/python3.4 /usr/bin/python3.4
    sudo ln -s /usr/local/bin/pip3.4 /usr/bin/pip3.4
    sudo ln -s /usr/local/bin/easy_install-3.4 /usr/bin/easy_install-3.4
    cd /usr/src
    sudo rm -rf Python-3.4.4/
    sudo pip3.4 install --upgrade pip
    cd $HOME
fi

# Bashrc.
sudo cp /vagrant/config/bash/root.bashrc /root/.bashrc
cp /vagrant/config/bash/vagrant.bashrc /home/vagrant/.bashrc

# Install EPEL repo.
sudo yum install -y epel-release

# Install vim, tree, etc.
sudo yum install -y vim tree git man man-pages

# Install Docker Compose.
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo mv docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo chown root: /usr/bin/docker-compose

# Install ansible.
sudo yum install -y ansible libselinux-python

# Install NTP.
sudo yum install -y ntp
sudo cp /vagrant/config/ntp/ntp.conf /etc/ntp.conf
sudo systemctl start ntpd
sudo systemctl enable ntpd

# Install Python packages.
sudo pip3.4 install virtualenv boto boto3 awscli django djangorestframework django-cors-headers

# Install Node.js.
wget https://nodejs.org/dist/v4.4.7/node-v4.4.7-linux-x64.tar.gz --no-check-certificate
sudo tar --strip-components 1 -xzvf node-v4.4.7-linux-x64.tar.gz -C /usr/local
rm /home/vagrant/node-v4.4.7-linux-x64.tar.gz

# Symlink Node.js for root.
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node /usr/bin/node

# Install global NPM packages.
sudo npm install -g mocha

# Install nginx.
sudo yum install -y nginx
sudo cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp /vagrant/config/nginx/python.conf /etc/nginx/conf.d/python.conf
sudo rm -rf /etc/nginx/default.d

# Create folder for nodebackend pid file.
sudo mkdir /var/nodebackend
sudo chown vagrant: /var/nodebackend

# Create www log folder.
sudo mkdir /var/log/www
sudo chown nginx:nginx /var/log/www/

# Start nginx.
sudo systemctl start nginx
sudo systemctl enable nginx
