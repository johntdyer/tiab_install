#!/usr/bin/env bash
set -e
set -u

adduser -r pureftpd
curl http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.35.tar.gz -o /opt/pure-ftpd-1.0.35.tar.gz
cd /opt
tar zxvf pure-ftpd-1.0.35.tar.gz
cd pure-ftpd-1.0.35
./configure --prefix=/opt/pureftpd --with-altlog --with-extauth
make; make install

cp $HOME/tiab_manual_installation/files/pureftpd /etc/init.d/pureftpd
chmod +x /etc/init.d/pureftpd
IP=$(/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1)
sed "s|XXX.XXX.XXX.XXX|$IP|" /etc/init.d/pureftpd

cp $HOME/tiab_manual_installation/files/pureftpd-auth.rb /opt/pureftpd/bin/pureftpd-auth.rb
chmod +x /opt/pureftpd/bin/pureftpd-auth.rb

rvm wrapper 1.9.3 ruby /opt/pureftpd/bin/pureftpd-auth.rb
sed -i -e"s/\/opt\/pureftpd\/bin\/pureftpd-auth\.rb/\/usr\/local\/rvm\/bin\/ruby_pureftpd-auth\.rb/" /etc/init.d/pureftpd
/sbin/chkconfig pureftpd on

/etc/init.d/pureftpd start

cd $HOME/tiab_manual_installation
