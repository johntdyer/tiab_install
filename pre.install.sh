#!/usr/bin/env bash
set -e
set -u

adduser -r voxeo

yum groupinstall "Development Tools" -y

rpm -Uvh http://mirror.us.leaseweb.net/epel/5/x86_64/epel-release-5-4.noarch.rpm

cd /usr/local/src/
curl http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz -o yaml-0.1.4.tar.gz
tar xzvf yaml-0.1.4.tar.gz
cd yaml-0.1.4
./configure --prefix=/usr/local
make -j4
make install

yum install java-1.6.0-openjdk -y

cd $HOME/tiab_manual_installation
