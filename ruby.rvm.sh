#!/usr/bin/env bash

# Install some deps 
yum install -y patch gcc-c++ readline openssl-devel libxslt-devel libxml2-devel pkgconfig readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel

yum groupinstall "Development Tools" -y

# Install RVM
curl -L get.rvm.io | sudo bash -s stable

# Install some Rubies
source "/etc/profile.d/rvm.sh"
rvm reload


rvm install 1.9.3
rvm use 1.9.3 --default
gem install json_pure httparty rest-client --no-ri --no-rdoc

cd $HOME/tiab_manual_installation
