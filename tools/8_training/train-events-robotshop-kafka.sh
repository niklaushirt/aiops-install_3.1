#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
source ./99_config-global.sh

export SCRIPT_PATH=$(pwd)
export LOG_PATH=""
__getClusterFQDN
__getInstallPath


banner
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Event Grouping Training for Robotshop"
echo ""
echo "***************************************************************************************************************************************************"

export DATA_FILE="events-robotshop-kafka.json"


export EVENTS_TOPIC="alerts-noi-1000-1000"
export sasl_password=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      

echo "***************************************************************************************************************************************************"
echo "  "
echo "   🔎  Training for Event Grouping"
echo "  "
echo "           Data File    : $DATA_FILE"
echo "  "
echo "           Topic        : $EVENTS_TOPIC"
echo "           Broker URL   : $BROKER"
echo "           SASL Password: $sasl_password"
echo "  "
echo "***************************************************************************************************************************************************"
  
  read -p "Start Training? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      echo "✅ Ok, continuing..."
  else
    echo "❌ Aborted"
    exit 1
  fi

echo "***************************************************************************************************************************************************"
echo "🛠️ Preparing Data"
mkdir /tmp/training-events/  >/dev/null 2>&1  || true
rm /tmp/training-events/x*
cp ./tools/8_training/1_events/$DATA_FILE /tmp/training-events/
cd /tmp/training-events/
split -l 1500 $DATA_FILE
export NUM_FILES=$(ls | wc -l)
rm $DATA_FILE
cd -  >/dev/null 2>&1  || true



oc project $WAIOPS_NAMESPACE >/dev/null 2>&1  || true


echo "***************************************************************************************************************************************************"
echo "🥇 Getting Certs"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt



echo "***************************************************************************************************************************************************"
echo "🚀 Starting Injection"
echo "   Quit with Ctrl-Z"



ACT_COUNT=0
for FILE in /tmp/training-events/*; do 
    if [[ $FILE =~ "x"  ]]; then
        ACT_COUNT=`expr $ACT_COUNT + 1`
        echo "Injecting file ($ACT_COUNT/$(($NUM_FILES))) - $FILE"
        kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t $EVENTS_TOPIC -l $FILE 
    fi
done


echo "Done"
echo ""
echo ""
echo ""
echo ""
echo ""

