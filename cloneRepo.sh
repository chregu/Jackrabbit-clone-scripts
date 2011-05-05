#!/bin/bash

SCRIPTPATH=`dirname $0`;

. $SCRIPTPATH/config.sh

#wait until it's down
echo "Waiting for jackrabbit with PID $JRPID to shut down";
kill $JRPID
while kill -0 $JRPID 2> /dev/null
do
echo -n "."
sleep 1
done
echo ".";
echo "Jackrabbit is down"
echo "Copy the whole repository location with rsync";
rsync -avr $REPOLOCATION/ $REPOLOCATION.bkup
echo "Get LOCAL_REVISION ID from mysql"
ID=`mysql -u $MYSQLUSER -h $MYSQLHOST -p$MYSQLPASS $MYSQLDB --silent -N -e "select REVISION_ID from JOURNAL_LOCAL_REVISIONS where JOURNAL_ID = '$JRCLUSTERID'"`
echo "It's $ID, write this to $REPOLOCATION.bkup/current_revision_id.dat"
echo $ID > $REPOLOCATION.bkup/current_revision_id.dat
echo "Adjust clusterconfig of $REPOLOCATION.bkup/repository.xml"
xsltproc --nonet --param cluster_id "'$JRCLUSTERID_NEW'" $SCRIPTPATH/changeClusterId.xsl $REPOLOCATION.bkup/repository.xml > $REPOLOCATION.bkup/repository.xml.new 2> /dev/null
mv $REPOLOCATION.bkup/repository.xml.new $REPOLOCATION.bkup/repository.xml
echo "Start Jackrabbit again"
$JRSTART &
echo "***"
echo "Now move $REPOLOCATION.bkup to your new location"
echo "***
