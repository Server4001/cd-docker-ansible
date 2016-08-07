#!/usr/bin/env bash

# Install Yum utils.
sudo yum install -y yum-utils

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
cp /vagrant/config/bash/vagrant.bashrc $HOME/.bashrc

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
sudo pip3.4 install virtualenv boto boto3 awscli django djangorestframework django-cors-headers django-nose pinocchio coverage

# Install Node.js.
wget https://nodejs.org/dist/v4.4.7/node-v4.4.7-linux-x64.tar.gz --no-check-certificate
sudo tar --strip-components 1 -xzvf node-v4.4.7-linux-x64.tar.gz -C /usr/local
rm $HOME/node-v4.4.7-linux-x64.tar.gz

# Symlink Node.js for root.
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node /usr/bin/node

# Install global NPM packages.
sudo npm install -g mocha

# Create variables for MySQL 5.7 install.
MYSQL_LOG_FOLDER="/var/log/mysql"
MYSQL_LIB_FOLDER="/var/lib/mysql"
MYSQL_ROOT_USER_PASSWORD="password"
MYSQL_CONFIG_FILE="/etc/my.cnf"
ROOT_USER_MYSQL_CONFIG="/root/.my.cnf"
VAGRANT_USER_MYSQL_CONFIG="$HOME/.my.cnf"

# Install MySQL 5.7.
if [ ! -f /usr/bin/mysql ]; then
    wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
    sudo yum localinstall -y mysql-community-release-el7-5.noarch.rpm
    rm $HOME/mysql-community-release-el7-5.noarch.rpm
    sudo yum-config-manager --disable mysql56-community
    sudo yum-config-manager --enable mysql57-community-dmr
    sudo yum install -y mysql-community-server-5.7.14
fi

# Set up log folder for MySQL.
sudo mkdir ${MYSQL_LOG_FOLDER}
sudo chmod 0755 ${MYSQL_LOG_FOLDER}
sudo chown mysql:mysql ${MYSQL_LOG_FOLDER}

# Initialize MySQL insecurely, so that we can lock it down with a known password.
if [ ! -f ${MYSQL_LIB_FOLDER}/mysql ]; then
    cd ${MYSQL_LIB_FOLDER}
    sudo mysqld --initialize-insecure
    cd $HOME
fi

# Configure MySQL.
sudo chown -R mysql:mysql ${MYSQL_LIB_FOLDER}
sudo cp /vagrant/config/mysql/my.cnf ${MYSQL_CONFIG_FILE}
sudo chmod 0644 ${MYSQL_CONFIG_FILE}
sudo chown mysql:mysql ${MYSQL_CONFIG_FILE}

# Start the MySQL service.
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Create new password for root MySQL user.
if [ ! -f ${MYSQL_LIB_FOLDER}/.mysql-root-password-has-been-set-by-provisioner ]; then
    sudo mysqladmin -u root password ${MYSQL_ROOT_USER_PASSWORD}
    sudo touch ${MYSQL_LIB_FOLDER}/.mysql-root-password-has-been-set-by-provisioner
fi

# Configure MySQL for root and vagrant users.
sudo cp /vagrant/config/mysql/.my.cnf ${ROOT_USER_MYSQL_CONFIG}
sudo chmod 0600 ${ROOT_USER_MYSQL_CONFIG}
sudo chown root:root ${ROOT_USER_MYSQL_CONFIG}
cp /vagrant/config/mysql/.my.cnf ${VAGRANT_USER_MYSQL_CONFIG}
chmod 0600 ${VAGRANT_USER_MYSQL_CONFIG}
chown vagrant:vagrant ${VAGRANT_USER_MYSQL_CONFIG}

# Secure the MySQL install.
mysql -u root -p"$MYSQL_ROOT_USER_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$MYSQL_ROOT_USER_PASSWORD" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$MYSQL_ROOT_USER_PASSWORD" -e "FLUSH PRIVILEGES"

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
