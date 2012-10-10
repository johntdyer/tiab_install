#!/usr/bin/env bash
set -e
set -u

yum install httpd php53 php53-pdo php53-xml -y
sed -i -e"s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf

cd /tmp
curl -O https://ec2-chef-deployment-assets.s3.amazonaws.com/temp/tropo-site.tgz
tar xzf tropo-site.tgz

NEW=/tmp/var/www/html

chgrp -R apache $NEW/sites/default/files/
chmod -R g+w $NEW/sites/default/files/

rmdir /var/www/html
mv $NEW /var/www/html

chkconfig httpd on
service httpd start

cd $HOME/tiab_manual_installation
