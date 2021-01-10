#! /usr/bin/env bash

# install useful packages
yum install net-tools vim sshpass wget -y

# get jq parser
wget http://stedolan.github.io/jq/download/linux64/jq
chmod +x ./jq
cp jq /usr/bin/
rm -rf jq

# edit hosts
jq -r '.master | "\(.ip) \(.hostname)"' properties.json > /etc/hosts
jq -r '.nodes[] | "\(.ip) \(.hostname)"' properties.json >> /etc/hosts

# ssh password Authentication no to yes
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

ROOT_HOME=/root

# create .ssh for root
mkdir -p $ROOT_HOME/.ssh
chmod 700 $ROOT_HOME/.ssh
touch $ROOT_HOME/.ssh/authorized_keys
chmod 644 $ROOT_HOME/.ssh/authorized_keys

# set timezone
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
