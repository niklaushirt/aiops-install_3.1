#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "   __________  __ ___       _____    ________            "
echo "  / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____"
echo " / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/"
echo "/ /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) "
echo "\____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  "
echo "                                          /_/            "
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Train Logs for $APP_NAME"
echo ""
echo "***************************************************************************************************************************************************"

source ./tools/0_global/99_config-global.sh
get_kafkacat

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Check Defaults
#--------------------------------------------------------------------------------------------------------------------------------------------

if [ -x "$(command -v kafkacat)" ]; then
      export KAFKACAT_EXE=kafkacat
      echo "  ✅  OK - kafkacat installed"
else
      if [ -x "$(command -v kcat)" ]; then
      export KAFKACAT_EXE=kcat
            echo "  ✅  OK - kcat installed"
      else
            echo "  ❗ ERROR: kafkacat is not installed."
            echo "  ❌ Aborting..."
            exit 1
      fi
fi

if [[ $APP_NAME == "" ]] ;
then
      echo "⚠️ AppName not defined. Launching this script directly?"
      echo "❌ Aborting..."
      exit 1
fi

if [[ $LOG_TYPE == "" ]] ;
then
      echo "⚠️ Log Type not defined. Launching this script directly?"
      echo "❌ Aborting..."
      exit 1
fi


#--------------------------------------------------------------------------------------------------------------------------------------------
#  Get Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------

echo "***************************************************************************************************************************************************"
echo "  🔐  Getting credentials"
echo "***************************************************************************************************************************************************"
oc project $WAIOPS_NAMESPACE >$log_output_path 2>&1  || true

if [[ $LOGS_TOPIC == "" ]] ;
then
      echo "      🔎 Getting Kafka Log Integration"
      export LOGS_TOPIC=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE | grep logs-$LOG_TYPE| awk '{print $1;}')
      export LOGS_TOPIC_COUNT=$(echo $LOGS_TOPIC | wc -w)

      if [[ $LOGS_TOPIC_COUNT -gt 1 ]] ;
      then
            echo "⚠️  There are several integrations for log type $LOG_TYPE:"
            echo "$LOGS_TOPIC"
            echo "⚠️  Please get the topic name from AI Hub and override LOGS_TOPIC in the calling script."
            echo "❌ Aborting..."
            exit 1
      fi

else
      echo "      ✅ OK - Logs Topic defined in calling script: $LOGS_TOPIC"
fi
export KAFKA_PASSWORD=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
export KAFKA_BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443


export WORKING_DIR_LOGS="./training/TRAINING_FILES/KAFKA/$APP_NAME/logs"
export WORKING_DIR_EVENTS="./training/TRAINING_FILES/KAFKA/$APP_NAME/events"

case $LOG_TYPE in
  elk) export DATE_FORMAT="+%Y-%m-%dT%H:%M:%S.000Z";;
  humio) export DATE_FORMAT="+%s000";;
  *) export DATE_FORMAT="+%s000";;
esac

echo "      ✅ OK"
echo ""
echo ""



#--------------------------------------------------------------------------------------------------------------------------------------------
#  Check Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------

echo "***************************************************************************************************************************************************"
echo "  🔗  Checking credentials"
echo "***************************************************************************************************************************************************"

if [[ $LOGS_TOPIC == "" ]] ;
then
      echo "      ❌ Please create the $LOG_TYPE Kafka Log Integration. Aborting..."
      exit 1
else
      echo "      ✅ OK - Logs Topic"
fi

if [[ ! $KAFKA_BROKER =~ "strimzi-cluster-kafka-bootstrap-$WAIOPS_NAMESPACE" ]] ;
then
      echo "      ❗ Strimzi Kafka Broker not found..."
      echo "      ❗    Make sure that the 11_postinstall_aiops.sh script has run to completion."
      echo "      ❗    This should create the Strimzi Route automatically."
      echo "      ❌ Aborting..."
      exit 1
else
      echo "      ✅ OK - Kafka Broker"
fi

export LOG_FILES=$(ls -1 $WORKING_DIR_LOGS | grep "json")
if [[ $LOG_FILES == "" ]] ;
then
      echo "      ❗ No logfiles found"
      echo "      ❗    No logfiles found to ingest in path $WORKING_DIR_LOGS"
      echo "      ❗    Please unzip the demo logs as described in the documentation of place your own in the directory."
      echo "      ❌ Aborting..."
      exit 1
else
      echo "      ✅ OK - Log Files"
fi



echo ""
echo ""
echo ""
echo ""


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🔎  Parameter for Incident Simulation for $APP_NAME"
echo "  "
echo "           🗂  Topic                       : $LOGS_TOPIC"
echo "           🌏 Kafka Broker URL            : $KAFKA_BROKER"
echo "           🔐 Kafka Password              : $KAFKA_PASSWORD"
echo "  "
echo "           📝 Log Type                    : $LOG_TYPE"
echo "           📅 Log Date Format             : $(date $DATE_FORMAT) ($DATE_FORMAT)"
echo "  "
echo "  "
echo "           📂 Directory for Logs          : $WORKING_DIR_LOGS"
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  🗄️  Files to be loaded for Log Anomalies"
echo "***************************************************************************************************************************************************"
ls -1 $WORKING_DIR_LOGS | grep "json"
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

echo ""
echo ""



echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
  read -p " ❗❓ Start Training? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      echo "   ✅ Ok, continuing..."
      echo ""
      echo ""
      echo ""
      echo ""

  else
    echo "❌ Aborted"
    exit 1
  fi
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo ""
echo ""

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Launch Log Injection as a parallel thread
#--------------------------------------------------------------------------------------------------------------------------------------------
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀  Launching Log Anomaly Training" 
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo ""
echo ""

for actFile in $(ls -1 $WORKING_DIR_LOGS | grep "json"); 
do 

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Prepare the Log Data
#--------------------------------------------------------------------------------------------------------------------------------------------

      echo "***************************************************************************************************************************************************"
      echo "  🛠️  Preparing Data for file $actFile"
      echo "***************************************************************************************************************************************************"


      #--------------------------------------------------------------------------------------------------------------------------------------------
      #  Create file and structure in /tmp
      #--------------------------------------------------------------------------------------------------------------------------------------------
      mkdir /tmp/training-logs/  >$log_output_path 2>&1  || true
      rm /tmp/training-logs/x* >$log_output_path 2>&1  || true
      cp $WORKING_DIR_LOGS/$actFile /tmp/training-logs/
      cd /tmp/training-logs/

  
      #--------------------------------------------------------------------------------------------------------------------------------------------
      #  Split the files in 1500 line chunks for kafkacat
      #--------------------------------------------------------------------------------------------------------------------------------------------
      echo "    🔨 Splitting"
      split -l 1500 $actFile
      export NUM_FILES=$(ls | wc -l)
      rm $actFile
      cd -  >$log_output_path 2>&1  || true
      echo "      ✅ OK"



      #--------------------------------------------------------------------------------------------------------------------------------------------
      #  Get the cert for kafkacat
      #--------------------------------------------------------------------------------------------------------------------------------------------
      oc project $WAIOPS_NAMESPACE >$log_output_path 2>&1  || true

      echo "***************************************************************************************************************************************************"
      echo "🥇 Getting Certs"
      echo "***************************************************************************************************************************************************"
      oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt >$log_output_path 2>&1  || true
      echo "      ✅ OK"



      #--------------------------------------------------------------------------------------------------------------------------------------------
      #  Inject the logs
      #--------------------------------------------------------------------------------------------------------------------------------------------
      echo "***************************************************************************************************************************************************"
      echo "🌏  Injecting Logs from File: ${actFile}" 
      echo "     Quit with Ctrl-Z"
      echo "***************************************************************************************************************************************************"
      ACT_COUNT=0
      for FILE in /tmp/training-logs/*; do 
          if [[ $FILE =~ "x"  ]]; then
              ACT_COUNT=`expr $ACT_COUNT + 1`
              echo "Injecting file ($ACT_COUNT/$(($NUM_FILES-1))) - $FILE"
              ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$KAFKA_PASSWORD -b $KAFKA_BROKER -P -t $LOGS_TOPIC -l $FILE   >$log_output_path 2>&1  || true
              #${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$KAFKA_PASSWORD -b $KAFKA_BROKER -P -t $LOGS_TOPIC -l $FILE   >$log_output_path 2>&1  || true
              echo "      ✅ OK"
          fi
      done
      rm /tmp/training-logs/x*
done

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Clean up
#--------------------------------------------------------------------------------------------------------------------------------------------

rm ./ca.crt

echo "***************************************************************************************************************************************************"
echo ""
echo " ✅  Log Injection Done..... "
echo "     Hit ENTER if the command prompt does not appear"
echo ""
echo "***************************************************************************************************************************************************"

echo ""
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Outage Simulation for $APP_NAME"
echo " ✅  Done..... "
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"







echo ""
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Train Logs for $APP_NAME"
echo " ✅  Done..... "
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"


