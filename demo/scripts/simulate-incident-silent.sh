#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------------------------------------------------------
#  Check Defaults
#--------------------------------------------------------------------------------------------------------------------------------------------

if [[ $APP_NAME == "" ]] ;
then
      echo "⚠️ AppName not defined. Launching this script directly?"
      echo "   Falling back to $DEFAULT_APP_NAME"
      export APP_NAME=$DEFAULT_APP_NAME
fi

if [[ $LOG_TYPE == "" ]] ;
then
      echo "⚠️ Log Type not defined. Launching this script directly?"
      echo "   Falling back to $DEFAULT_LOG_TYPE"
      export LOG_TYPE=$DEFAULT_LOG_TYPE
fi

echo "."


#--------------------------------------------------------------------------------------------------------------------------------------------
#  Get Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------
oc project $WAIOPS_NAMESPACE >$log_output_path 2>&1  || true
export LOGS_TOPIC=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE | grep logs-$LOG_TYPE| awk '{print $1;}')
export KAFKA_PASSWORD=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
export KAFKA_BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
export NOI_PASSWORD=$(oc get secrets | grep omni-secret | awk '{print $1;}' | xargs oc get secret -o jsonpath --template '{.data.OMNIBUS_ROOT_PASSWORD}' | base64 --decode)

export WORKING_DIR_LOGS="./demo/INCIDENT_FILES/$APP_NAME/logs"
export WORKING_DIR_EVENTS="./demo/INCIDENT_FILES/$APP_NAME/events"

case $LOG_TYPE in
  elk) export DATE_FORMAT="+%Y-%m-%dT%H:%M:%S.000Z";;
  humio) export DATE_FORMAT="+%s000";;
  *) export DATE_FORMAT="+%s000";;
esac

echo ".."




#--------------------------------------------------------------------------------------------------------------------------------------------
#  Check Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------
if [[ $LOGS_TOPIC == "" ]] ;
then
      echo "❌ Please create the $LOG_TYPE Kafka Log Integration. Aborting..."
      exit 1
fi

if [[ $KAFKA_BROKER == "" ]] ;
then
      echo "❌ Make sure that the Strimzi Route got created at install time. Aborting..."
      exit 1
fi

if [[ $NETCOOL_WEBHOOK_GENERIC == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GENERIC == "" ]];
then
      echo "❌ Event Manager Webhook not configured. Aborting..."
      exit 1
fi

if [[ $NOI_PASSWORD == "" ]] ;
then
      echo "❌ Cannot contact Event Manager"
      echo "❌ Make sure that Event Manager is running. Aborting..."
      exit 1
fi

echo "..."



#--------------------------------------------------------------------------------------------------------------------------------------------
#  Launch Log Injection as a parallel thread
#--------------------------------------------------------------------------------------------------------------------------------------------
./demo/scripts/simulate-log-silent.sh


#--------------------------------------------------------------------------------------------------------------------------------------------
#  Deleting Event Manager Events
#--------------------------------------------------------------------------------------------------------------------------------------------
oc get pods | grep ncoprimary-0 | awk '{print $1;}' | xargs -I{} oc exec {} -- bash -c "/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P -user root -passwd ${NOI_PASSWORD} << EOF
delete from alerts.status where AlertGroup='$APP_NAME';
go
exit
EOF"


#--------------------------------------------------------------------------------------------------------------------------------------------
#  Start creating Events
#--------------------------------------------------------------------------------------------------------------------------------------------

for actFile in $(ls -1 $WORKING_DIR_EVENTS | grep "json"); 
do 

    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000

      echo "....."
      line=${line/MY_TIMESTAMP/$my_timestamp}

      curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GENERIC" \
        -H 'Content-Type: application/json; charset=utf-8' \
        -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
        -d $"${line}"
    done < "$WORKING_DIR_EVENTS/$actFile"


done

