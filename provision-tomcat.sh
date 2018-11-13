#!/bin/bash
last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin)
now=$(date +%s)
if [ $((now - last_update)) -gt 3600 ]; then
	apt-get update -y
	apt-get upgrade -y
fi
apt-get install -y nano git openjdk-7-jdk openjdk-7-jre-headless

cd /usr/local
if [ ! -f /usr/local/apache-tomcat-8.5.35.tar.gz ]; then
	wget https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz
fi
if [ ! -d /usr/local/apache-tomcat-8.5.35 ]; then
	wget https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz
	tar -xzvf apache-tomcat-8.5.35.tar.gz
fi
	
rm -f tomcat
ln -s apache-tomcat-8.5.35 tomcat


update-rc.d -f tomcat8 remove
rm -f /etc/init.d/tomcat8
cp /vagrant/tomcat8 /etc/init.d/tomcat8
sed -i -e 's/\r//g' /etc/init.d/tomcat8
chmod 755 /etc/init.d/tomcat8
update-rc.d tomcat8 defaults
service tomcat8 start
