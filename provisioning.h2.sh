#!/usr/bin/env bash
set -e
set -u

SEED=h2db-v11.7.b10.tar.gz
curl http://ec2-chef-deployment-assets.s3.amazonaws.com/h2/h2-1.3.164.jar -o /opt/voxeo/prism/shared/lib/h2-1.3.164.jar
mkdir /opt/voxeo/prism/h2; cd /opt/voxeo/prism
curl https://ci-voxeolabs-net.s3.amazonaws.com/provisioning/$SEED -o $SEED
tar zxvf /opt/voxeo/prism/$SEED
curl https://ci-voxeolabs-net.s3.amazonaws.com/provisioning/rest-api-h2-v11.7.b10.war -o /opt/voxeo/prism/apps/rest.war
unzip /opt/voxeo/prism/apps/rest.war -d /opt/voxeo/prism/apps/rest/

sed -i -e"s/com.tropo.provisioning.sip.domain=.*/com.tropo.provisioning.sip.domain=`/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1`/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties

sed -i -e"s/com.tropo.provisioning.security.realm=.*/com.tropo.provisioning.security.realm=`/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1`/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties

sed -i -e"s/com.tropo.provisioning.jms.username=.*/com.tropo.provisioning.jms.username=admin/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties
sed -i -e"s/com.tropo.provisioning.jms.password=.*/com.tropo.provisioning.jms.password=admin/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties
sed -i -e"s/com.tropo.provisioning.jms.notifications.topic=.*/com.tropo.provisioning.jms.notifications.topic=VirtualTopic.Provisioning/" /opt/voxeo/prism/apps/rest/WEB-INF/tropo.properties

cd $HOME/tiab_manual_installation
