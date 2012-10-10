#!/usr/bin/env bash
set -e
set -u 

cd /opt/voxeo/prism/server/lib
curl http://files.voxeolabs.net/tropo-logger/tropo-logger-realm.b18.39ecb60.jar -o tropo-logger.jar
cd /opt/voxeo/prism/apps
curl http://files.voxeolabs.net/tropo-logger/tropo-logger.b18.39ecb60.war -o tropo-logger.war
unzip -o tropo-logger.war -d tropo-logger
cp $HOME/tiab_manual_installation/files/tropoLoggingServer.properties tropo-logger/WEB-INF/classes/tropoLoggingServer.properties

sed -i 's|log4j.rootLogger=DEBUG, FILE, SYSLOG|log4j.rootLogger=DEBUG, FILE, SYSLOG, TROPOLOGGER|' /opt/voxeo/prism/conf/log4j.properties

cat >> /opt/voxeo/prism/conf/log4j.properties << "EOF"

log4j.appender.TROPOLOGGER=com.voxeo.logging.LogViewerAppender
log4j.appender.TROPOLOGGER.SyslogHost=127.0.0.1:1500
log4j.appender.TROPOLOGGER.UseTCP=true
log4j.appender.TROPOLOGGER.layout=org.apache.log4j.PatternLayout
log4j.appender.TROPOLOGGER.layout.ConversionPattern=%d{MMM dd HH:mm:ss} %X{HostName} TROPO %X{AccountID}/%X{ApplicationID}/%X{SessionGUID}/%X{SessionNumber}/1/%X{CallID}/%m%n
EOF

cd $HOME/tiab_manual_installation
