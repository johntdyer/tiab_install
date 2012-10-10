#!/usr/bin/env bash
set -e
set -u

## Install Prism
PRISM_INSTALLER=prism-11_5_3_C201207041614_0-x64.bin

cd /opt
wget https://prism-app-server.s3.amazonaws.com/daily/$PRISM_INSTALLER
chmod +x $PRISM_INSTALLER
./$PRISM_INSTALLER -i silent -DSTART_SERVICES=0 -DCONSOLE_PRISM_MODULES_BOOLEAN_1=0 -DCONSOLE_PRISM_MODULES_BOOLEAN_2=0

# Setup Webhosting
mkdir -p /webhosting/WEB-INF
sed -i -e's/<SIPMethod version=\"4.0\">/<SIPMethod version=\"4.0\">\n<Container reloadInterval=\"30\" applicationRoot=\"apps\" workRoot=\"work\" osgi=\"false\">\n<Application docBase="\/webhosting"\/>\n<\/Container>\n/' /opt/voxeo/prism/conf/sipmethod.xml
echo -e '<?xml version="1.0" encoding="utf-8"?>\n<web-app version="2.4" xmlns="http://java.sun.com/xml/ns/j2ee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">\n<display-name>tropoScriptDir</display-name>\n<description>tropoScriptDir</description>\n<servlet>\n<servlet-name>default</servlet-name>\n<servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>\n<init-param>\n<param-name>debug</param-name>\n<param-value>0</param-value>\n</init-param>\n<init-param>\n<param-name>listings</param-name>\n<param-value>true</param-value>\n</init-param>\n<load-on-startup>1</load-on-startup>\n</servlet>\n<servlet-mapping>\n<servlet-name>default</servlet-name>\n<url-pattern>/</url-pattern>\n</servlet-mapping>\n</web-app>' > /webhosting/WEB-INF/web.xml

# Configure Prism
sed -i -e's/6061/5060/' /opt/voxeo/prism/conf/portappmapping.properties
# Move SNMP Port

sed -i -e's/8161/8162/g' /opt/voxeo/prism/conf/sipmethod.xml

cd $HOME/tiab_manual_installation
