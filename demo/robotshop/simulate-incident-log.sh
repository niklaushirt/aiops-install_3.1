export WAIOPS_NAMESPACE=aiops

source ./01_config.sh

banner 

echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Simulate Log Anomaly for Robotshop"
echo ""
echo "***************************************************************************************************************************************************"

export DATA_FILE="robotError.json"
#export DATA_FILE="test.json"


export LOGS_TOPIC=$(oc get KafkaTopic -n aiops | grep logs-humio| awk '{print $1;}')
export sasl_password=$(oc get secret token -n aiops --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n aiops -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      

echo "***************************************************************************************************************************************************"
echo "  "
echo "   🔎  Training for Log Anomaly"
echo "  "
echo "           Data File    : $DATA_FILE"
echo "  "
echo "           Topic        : $LOGS_TOPIC"
echo "           Broker URL   : $BROKER"
echo "           SASL Password: $sasl_password"
echo "  "
echo "***************************************************************************************************************************************************"
  
while true; do

    echo ""
    echo ""
    echo ""
    echo "***************************************************************************************************************************************************"
    echo "🛠️ Preparing Data"

    echo "" > /tmp/training/full.json

    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      #echo "Injecting Event at: $my_timestamp"
      line=${line/@TIMESTAMP@/$my_timestamp}
      #$(echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/")
      echo $line >> /tmp/training/full.json
    done < "./robotshop/$DATA_FILE"



    mkdir /tmp/training/  >/dev/null 2>&1  || true
    rm /tmp/training/x*
    cd /tmp/training/
    split -l 500 /tmp/training/full.json
    export NUM_FILES=$(ls | wc -l)
    rm /tmp/training/full.json
    cd -  >/dev/null 2>&1  || true



    oc project $WAIOPS_NAMESPACE >/dev/null 2>&1  || true

    echo ""
    echo ""
    echo ""
    echo "***************************************************************************************************************************************************"
    echo "🥇 Getting Certs"
      #mv ca.crt ca.crt.old
      oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt --confirm


    echo ""
    echo ""
    echo ""
    echo "***************************************************************************************************************************************************"
    echo "🚀 Starting Injection"
    echo "   Quit with Ctrl-Z"



    ACT_COUNT=0
    for FILE in /tmp/training/*; do 
        if [[ $FILE =~ "x"  ]]; then
            ACT_COUNT=`expr $ACT_COUNT + 1`
            echo "Injecting file ($ACT_COUNT/$(($NUM_FILES))) - $FILE"
            kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t $LOGS_TOPIC -l $FILE >/dev/null 2>&1  || true
        fi
    done
done

rm ./ca.crt

echo "Done"
echo ""
echo ""
echo ""
echo ""
echo ""

