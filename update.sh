#! /bin/sh
TINYPMVERSION=2.5

# from /etc/init.d/tomcat6
NAME=tomcat6
# Directory where the Tomcat 6 binary distribution resides
CATALINA_HOME=/usr/share/$NAME
# Directory for per-instance configuration files and webapps
CATALINA_BASE=/var/lib/$NAME

TINYPMFILE=tinypm-$TINYPMVERSION-tomcat6.0.zip

if [ ! -e $TINYPMFILE ]; then
	wget http://www.tinypm.com/downloads/$TINYPMFILE
fi

unzip -o tinypm-$TINYPMVERSION-tomcat6.0.zip

#backup settings
cp $CATALINA_BASE/webapps/tinypm/WEB-INF/classes/hibernate.properties .

/etc/init.d/tomcat6 stop

cp dependencies/* $CATALINA_HOME/lib/
rm -rf $CATALINA_BASE/webapps/tinypm
unzip tinypm.war -d $CATALINA_BASE/webapps/tinypm/

cp hibernate.properties $CATALINA_BASE/webapps/tinypm/WEB-INF/classes/

/etc/init.d/tomcat6 start
