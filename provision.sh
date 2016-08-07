#!/usr/bin/env bash

# Bashrc.
sudo cp /vagrant/config/bash/root.bashrc /root/.bashrc
cp /vagrant/config/bash/vagrant.bashrc $HOME/.bashrc

# Install EPEL repo.
sudo yum install -y epel-release

# Install pip.
sudo yum install -y python-pip
sudo pip install --upgrade pip

# Install Python packages.
sudo pip install virtualenv boto boto3 awscli django djangorestframework django-cors-headers django-nose pinocchio coverage

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

# Install Node.js.
wget https://nodejs.org/dist/v4.4.7/node-v4.4.7-linux-x64.tar.gz --no-check-certificate
sudo tar --strip-components 1 -xzvf node-v4.4.7-linux-x64.tar.gz -C /usr/local
rm $HOME/node-v4.4.7-linux-x64.tar.gz

# Symlink Node.js for root.
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node /usr/bin/node

# Install global NPM packages.
sudo npm install -g mocha grunt-cli bower

# Install MySQL.
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo yum localinstall -y mysql-community-release-el7-5.noarch.rpm
sudo yum install -y mysql-community-server
rm mysql-community-release-el7-5.noarch.rpm

# Start MySQL.
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Secure the MySQL install.
export DATABASE_PASS=password
mysqladmin -u root password "$DATABASE_PASS"
mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root'"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Install the MySQL libs for Python.
sudo yum groupinstall -y 'development tools'
sudo yum install -y mysql-community-devel python-devel
sudo pip install mysql-python

# Install nginx.
sudo yum install -y nginx
sudo cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp /vagrant/config/nginx/todobackend.conf /etc/nginx/conf.d/todobackend.conf
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
