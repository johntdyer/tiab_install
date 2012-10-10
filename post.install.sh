#!/usr/bin/env bash
set -e
set -u

/opt/voxeo/prism/bin/prism start 

# Set the hostname for the provisioning API, you can add multiple hostnames if you want. 
if [ -f '/opt/voxeo/prism/shared/lib/h2-1.3.164.jar' ] then;
    /opt/voxeo/prism/jre/bin/java -cp /opt/voxeo/prism/shared/lib/h2-1.3.164.jar org.h2.tools.Shell -user sa -password "" -url jdbc:h2:tcp://localhost:9092/provisioning -sql "insert into AuthorizedRemoteAddress(id,pattern,accountid) values(5, 'your.server.homename.com',1);"
fi

#please email us this file to license the server
cat /opt/voxeo/prism/conf/license.xml

cd $HOME/tiab_manual_installation
