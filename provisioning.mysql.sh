#!/usr/bin/env bash
set -e
set -u

SEED="mysql.provisioning.sql-v11.7.b10.tar.gz"
cd /tmp
curl https://ci-voxeolabs-net.s3.amazonaws.com/provisioning/$SEED -o $SEED
tar zxf $SEED
mysql -u root < mysql.provisioning.sql

echo "GRANT CREATE,INSERT,DELETE,UPDATE,SELECT on provisioning.* TO 'provisioning'@'localhost' IDENTIFIED BY 'provisioning';" | mysql -u root

curl https://ci-voxeolabs-net.s3.amazonaws.com/provisioning/rest-api-mysql-v11.7.b10.war -o /opt/voxeo/prism/apps/rest.war
unzip /opt/voxeo/prism/apps/rest.war -d /opt/voxeo/prism/apps/rest/

sed -i -e"s/com.tropo.provisioning.sip.domain=.*/com.tropo.provisioning.sip.domain=`/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1`/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties

sed -i -e"s/com.tropo.provisioning.security.realm=.*/com.tropo.provisioning.security.realm=`/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1`/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties

sed -i -e"s/com.tropo.provisioning.jms.username=.*/com.tropo.provisioning.jms.username=admin/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties
sed -i -e"s/com.tropo.provisioning.jms.password=.*/com.tropo.provisioning.jms.password=admin/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties
sed -i -e"s/com.tropo.provisioning.jms.notifications.topic=.*/com.tropo.provisioning.jms.notifications.topic=VirtualTopic.Provisioning/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties

## This should be fixed in REST 11.8 but for now we have to fix it here
sed -i -e"s/com.tropo.provisioning.default.brand:null/com.tropo.provisioning.default.brand:9/" /opt/voxeo/prism/apps/rest/WEB-INF/rest-context.xml

cd $HOME/tiab_manual_installation

