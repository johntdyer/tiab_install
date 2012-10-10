#!/usr/bin/env bash
set -e
set -u

cd /opt/voxeo/prism/server/apps
curl http://ci-voxeolabs-net.s3.amazonaws.com/tropo-servlet/tropo-servlet-11.6.b19.c839b63.war -o /opt/voxeo/prism/server/apps/tropo.war

unzip /opt/voxeo/prism/server/apps/tropo.war -d /opt/voxeo/prism/server/apps/tropo

touch /opt/voxeo/prism/conf/verboten.sip
touch /opt/voxeo/prism/conf/verboten.tel

sed -i 's|MockAppMgr">|CloudDnsAppMgr"><transformations><incoming><regex><match>^\+(\d*)</match><replace>{1}</replace></regex></incoming></transformations>|g' /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml

sed -i "s/<tropo enableSecurityManager=\"true\" threadSize=\"80\" allowOutboundByDefault=\"true\">/<tropo enableSecurityManager=\"true\" threadSuze=\"80\" allowOutboundByDefault=\"true\" addHuaWeiHeader=\"true\">/" /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml

sed -i "s/<bindAddress>127\.0\.0\.1<\/bindAddress>/<bindAddress>`/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1`<\/bindAddress>/" /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml

sed -i 's/172\.21\.99\.133:6062/127.0.0.1/' /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml 
sed -i -e 's|<!--routing|<routing|' -e 's|local"-->|local">|' /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml
sed -i '/<routing communitySettings="route">/d' /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml

sed -i "s/<vcmServer host=\"127.0.0.1\" port=\"8080\" mport=\"10074\" virtualPlatformId=\"staging\"\/>/<vcmServer host=\"127\.0\.0\.1\" port=\"8080\" mhost=\"`/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1`\" mport=\"10074\" virtualPlatformId=\"development\"\/>/" /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml 

sed -i "s|/opt/voxeo/prism/server/apps/tropo/tropo_app_home|/tmp|" /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml 

cd $HOME/tiab_manual_installation
