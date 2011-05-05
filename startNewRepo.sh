#!/bin/bash

SCRIPTPATH=`dirname $0`;

. $SCRIPTPATH/config.sh


if [[ ! -f $REPOLOCATION/current_revision_id.dat ]]
then
echo "!!!!!!"
echo "$REPOLOCATION/current_revision_id.dat does not exist, can't proceed"
echo "!!!!!!"
exit 2
fi


ID=`cat $REPOLOCATION/current_revision_id.dat`


echo "Check if JOURNAL_ID $JRCLUSTERID_NEW already exists"
CLUSTERIDCHECK=`$MYSQLBIN -u $MYSQLUSER -h $MYSQLHOST -p$MYSQLPASS $MYSQLDB --silent -N -e "select REVISION_ID from JOURNAL_LOCAL_REVISIONS where JOURNAL_ID = '$JRCLUSTERID_NEW'"`
if [[ -z $CLUSTERIDCHECK ]]
then
echo "It does not exist, insert it and put REVISION_ID  to $ID"
$MYSQLBIN -u $MYSQLUSER -h $MYSQLHOST -p$MYSQLPASS $MYSQLDB --silent -N -e "INSERT INTO JOURNAL_LOCAL_REVISIONS (REVISION_ID, JOURNAL_ID) VALUES($ID, '$JRCLUSTERID_NEW');"
else
echo "It exists, update REVISION_ID to $ID"
$MYSQLBIN -u $MYSQLUSER -h $MYSQLHOST -p$MYSQLPASS $MYSQLDB --silent -N -e "UPDATE JOURNAL_LOCAL_REVISIONS SET REVISION_ID = $ID where  JOURNAL_ID = '$JRCLUSTERID_NEW';"
fi


echo "Adjust clusterconfig of $REPOLOCATION/repository.xml (again, just to be sure)"
xsltproc --nonet --param cluster_id "'$JRCLUSTERID_NEW'" $SCRIPTPATH/changeClusterId.xsl $REPOLOCATION/repository.xml > $REPOLOCATION/repository.xml.new 2> /dev/null
mv $REPOLOCATION/repository.xml.new $REPOLOCATION/repository.xml

echo "Move $REPOLOCATION/current_revision_id.dat away"
mv $REPOLOCATION/current_revision_id.dat  $REPOLOCATION/current_revision_id.dat.old
echo "Start Jackrabbit"

$JRSTART
