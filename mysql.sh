#!/usr/bin/env bash
set -e
set -u

yum install -y mysql-server

cp $HOME/tiab_manual_installation/files/my.cnf /etc

chkconfig mysqld on
service mysqld start
