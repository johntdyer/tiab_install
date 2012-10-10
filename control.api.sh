#!/usr/bin/env bash
set -e
set -u

cd /opt/voxeo/prism/apps
curl http://ci-voxeolabs-net.s3.amazonaws.com/tropo-control-api/tropo-control-api-11.6.b19.c839b63.war  -o api.war
unzip api.war -d api
echo -e 'com.tropo.routing.dns.hostname=127.0.0.1\ncom.tropo.routing.dns.ppidLookupPattern=_sip._udp.ppid${ppid}.routing.tropo.local\ncom.tropo.routing.dns.addressDetailsLookupPattern=${address}.apps.tropo.local\n' > /opt/voxeo/prism/apps/api/WEB-INF/classes/tropo.properties

cd $HOME/tiab_manual_installation
