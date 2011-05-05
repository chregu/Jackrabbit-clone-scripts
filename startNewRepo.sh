#!/bin/bash

SCRIPTPATH=`dirname $0`;

. $SCRIPTPATH/config.sh

ID=`cat $REPOLOCATION/current_revision_id.dat`


echo $ID;
echo "Put LOCAL_REVISION $ID into mysql"
mysql -u $MYSQLUSER -h $MYSQLHOST -p$MYSQLPASS $MYSQLDB --silent -N -e "INSERT INTO JOURNAL_LOCAL_REVISIONS (REVISION_ID, JOURNAL_ID) VALUES($ID, '$JRCLUSTERID_NEW');"

echo "Adjust clusterconfig of $REPOLOCATION.bkup/repository.xml (again, just to be sure)"
xsltproc --nonet --param cluster_id "'$JRCLUSTERID_NEW'" $SCRIPTPATH/changeClusterId.xsl $REPOLOCATION/repository.xml > $REPOLOCATION/repository.xml.new 2> /dev/null
mv $REPOLOCATION/repository.xml.new $REPOLOCATION/repository.xml
echo "Start Jackrabbit"
$JRSTART
