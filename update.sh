#! /bin/sh
TINYPMVERSION=2.5.1

# from /etc/init.d/tomcat6
NAME=tomcat6
# Directory where the Tomcat 6 binary distribution resides
CATALINA_HOME=/usr/share/$NAME
# Directory for per-instance configuration files and webapps
CATALINA_BASE=/var/lib/$NAME

TINYPMFILE=tinypm-$TINYPMVERSION-tomcat6.0.zip

TEMPDIR=`cd $(mktemp -d tinypm-$TINYPMVERSION-UPDATE-XXXXX) && pwd`
chmod 775 -R $TEMPDIR
cd $TEMPDIR

function download {
	if [ ! -e $TINYPMFILE ]; then
		wget http://www.tinypm.com/downloads/$TINYPMFILE
	fi
	unzip -o tinypm-$TINYPMVERSION-tomcat6.0.zip
}

function backup {
	cp $CATALINA_BASE/webapps/tinypm/WEB-INF/classes/hibernate.properties .
	../backup.sh
}

function stop_tomcat {
	/etc/init.d/tomcat6 stop
}

function start_tomcat {
	/etc/init.d/tomcat6 start
}


function copy_files {
cp dependencies/* $CATALINA_HOME/lib/
rm -rf $CATALINA_BASE/webapps/tinypm
unzip tinypm.war -d $CATALINA_BASE/webapps/tinypm/
cp hibernate.properties $CATALINA_BASE/webapps/tinypm/WEB-INF/classes/
cd ..
}

function post_update {
	echo "Update complete, please run sql updates manually, from $TEMPDIR/sql/mysql,  e.g."
	echo "$ mysql -u root -p --database tinypmdb < update_from_2.5_to_$TINYPMVERSION.sql"
	echo "Update files are in $TEMPDIR"
}

function run {
download &&
stop_tomcat &&
backup &&
copy_files &&
start_tomcat &&
post_update
}
