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
echo " 🚀  CP4WAIOPS Similar Incidents Training"
echo ""
echo "***************************************************************************************************************************************************"

export DATA_FILE="./tools/8_training/3_incidents/test-incidents.json"


export sasl_password=$(oc get secret token -n aiops --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n aiops -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      

echo "***************************************************************************************************************************************************"
echo "  "
echo "   🔎  Training for Log Anomaly"
echo "  "
echo "           Data File    : $DATA_FILE"
echo "  "
echo "           Topic        : watsonaiops.incident"
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



oc project $WAIOPS_NAMESPACE >/dev/null 2>&1  || true


echo "***************************************************************************************************************************************************"
echo "🥇 Getting Certs"
  #mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt



echo "***************************************************************************************************************************************************"
echo "🚀 Starting Injection"
echo "   Quit with Ctrl-Z"


kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t watsonaiops.incident -l $DATA_FILE 


echo "Done"
echo ""
echo ""
echo ""
echo ""
echo ""

