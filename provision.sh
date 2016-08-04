#!/usr/bin/env bash

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

# Install PIP.
sudo yum -y install python-pip
sudo pip install --upgrade pip

# Install Boto and AWS CLI.
sudo pip install boto boto3
sudo pip install awscli
