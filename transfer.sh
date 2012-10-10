#!/usr/bin/env bash
set -e
set -u

cd /opt
curl http://ci-voxeolabs-net.s3.amazonaws.com/transfer-dns/transfer-dns-v11.7.b10.tar.gz -o transfer-dns.tgz
tar zxvf transfer-dns.tgz

cp -a $HOME/tiab_manual_installation/files/transfer-dns/config/ /opt/transfer-dns
cp -a $HOME/tiab_manual_installation/files/transfer-dns/logs/ /opt/transfer-dns
cp -a $HOME/tiab_manual_installation/files/transfer-dns/bin/ /opt/transfer-dns

ln -s /opt/transfer-dns/bin/transfer-dns /etc/init.d/transfer-dns

chkconfig --add transfer-dns
/etc/init.d/transfer-dns start

cd $HOME/tiab_manual_installation
