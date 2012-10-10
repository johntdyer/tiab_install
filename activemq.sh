#!/usr/bin/env bash
set -e
set -u

cd /opt
curl http://mirror.metrocast.net/apache/activemq/apache-activemq/5.5.1/apache-activemq-5.5.1-bin.tar.gz -o /opt/apache-activemq-5.5.1-bin.tar.gz
tar zxvf apache-activemq-5.5.1-bin.tar.gz
ln -s apache-activemq-5.5.1 activemq
/opt/apache-activemq-5.5.1/bin/activemq setup /etc/default/activemq
ln -s /opt/apache-activemq-5.5.1/bin/linux-x86-64/activemq /etc/init.d/activemq 
sed -i 's|linux/|linux-x86-64|' /opt/apache-activemq-5.5.1/bin/linux-x86-64/wrapper.conf
/sbin/chkconfig activemq on
/etc/init.d/activemq start

cd $HOME/tiab_manual_installation
