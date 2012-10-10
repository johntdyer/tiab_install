#!/usr/bin/env bash
set -e
set -u

yum install bind -y
cp $HOME/tiab_manual_installation/files/named.conf /etc/named.conf
cp $HOME/tiab_manual_installation/files/rndc.key /etc/rndc.key
cp $HOME/tiab_manual_installation/files/tsig.keys /etc/tsig.keys

cp $HOME/tiab_manual_installation/files/routing.tropo.local.db /var/named/routing.tropo.local.db
cp $HOME/tiab_manual_installation/files/apps.tropo.local.db /var/named/apps.tropo.local.db

echo "ENABLE_ZONE_WRITE=yes" >> /etc/sysconfig/named

touch /var/log/bind.log

chown named.named -R /var/named
chown named.named /etc/rndc.key
chown named.named /etc/named.conf
chown named.named /etc/tsig.keys
chown named.named /var/log/bind.log

/sbin/chkconfig named on

/etc/init.d/named start

cd $HOME/tiab_manual_installation
