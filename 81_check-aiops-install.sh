source ./tools/0_global/99_config-global.sh
source ./00_config-secrets.sh

export SCRIPT_PATH=$(pwd)
export LOG_PATH=""
__getClusterFQDN
__getInstallPath

clear

banner 
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 CloudPak for Watson AI OPS 3.1"
echo "  "
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"

echo "  Initializing......"



export LOGS_TOPIC=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE | grep logs-$LOG_TYPE| awk '{print $1;}')


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "🔎 Check Patches"
echo "--------------------------------------------------------------------------------------------"


INGRESS_OK=$(oc get namespace default -oyaml | grep ingress || true) 
if  ([[ ! $INGRESS_OK =~ "ingress" ]]); 
then 
    echo "      ⭕ Ingress Not Patched (launch 20_debug_install.sh and select option 6)"; 
else
    echo "      ✅ OK: Ingress Patched"; 

fi



PATCH_OK=$(oc get deployment evtmanager-ibm-hdm-analytics-dev-inferenceservice -n $WAIOPS_NAMESPACE -oyaml | grep "failureThreshold: 30" || true) 
if  ([[ ! $PATCH_OK =~ "failureThreshold: 30" ]]); 
then 
    echo "      ⭕ evtmanager-ibm-hdm-analytics-dev-inferenceservice Not Patched"; 
else
    echo "      ✅ OK: evtmanager-ibm-hdm-analytics-dev-inferenceservice Patched"; 

fi

PATCH_OK=$(oc get deployment evtmanager-topology-merge -n $WAIOPS_NAMESPACE -oyaml | grep "failureThreshold: 61" || true) 
if  ([[ ! $PATCH_OK =~ "failureThreshold: 61" ]]); 
then 
    echo "      ⭕ evtmanager-topology-merge Not Patched"; 
else
    echo "      ✅ OK: evtmanager-topology-merge Patched"; 

fi



echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "🔎 Check Routes"
echo "--------------------------------------------------------------------------------------------"

ROUTE_OK=$(oc get route topology-merge -n $WAIOPS_NAMESPACE || true) 
if  ([[ ! $ROUTE_OK =~ "topology-merge" ]]); 
then 
    echo "      ⭕ topology-merge Route does not exist"; 
else
    echo "      ✅ OK: topology-merge Route exists"; 

fi

ROUTE_OK=$(oc get route topology-rest -n $WAIOPS_NAMESPACE || true) 
if  ([[ ! $ROUTE_OK =~ "topology-rest" ]]); 
then 
    echo "      ⭕ topology-rest Route does not exist"; 
else
    echo "      ✅ OK: topology-rest Route exists"; 

fi

ROUTE_OK=$(oc get route topology-manage -n $WAIOPS_NAMESPACE || true) 
if  ([[ ! $ROUTE_OK =~ "topology-manage" ]]); 
then 
    echo "      ⭕ topology-manage Route does not exist"; 
else
    echo "      ✅ OK: topology-manage Route exists"; 

fi

ROUTE_OK=$(oc get route job-manager -n $WAIOPS_NAMESPACE || true) 
if  ([[ ! $ROUTE_OK =~ "job-manager" ]]); 
then 
    echo "      ⭕ job-manager Route does not exist"; 
else
    echo "      ✅ OK: job-manager Route exists"; 

fi
ROUTE_OK=$(oc get route strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE || true) 
if  ([[ ! $ROUTE_OK =~ "strimzi-cluster-kafka-bootstrap" ]]); 
then 
    echo "      ⭕ strimzi-cluster-kafka-bootstrap Route does not exist"; 
else
    echo "      ✅ OK: strimzi-cluster-kafka-bootstrap Route exists"; 

fi

INGRESS_OK=$(oc get namespace default -oyaml | grep ingress || true) 
if  ([[ ! $INGRESS_OK =~ "ingress" ]]); 
then 
    echo "      ⭕ Ingress Not Patched (launch 20_debug_install.sh and select option 6)"; 
else
    echo "      ✅ OK: Ingress Patched"; 

fi






echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "🔎 Check Kafka Instance"
echo "--------------------------------------------------------------------------------------------"



echo "    🔬 Check for Kafka Broker" 

export KAFKA_PASSWORD=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
export KAFKA_BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

if [[ ! $KAFKA_BROKER =~ "strimzi-cluster-kafka-bootstrap-$WAIOPS_NAMESPACE" ]] ;
then
      echo "      ❗ Strimzi Kafka Broker not found..."
      echo "      ❗    Make sure that the 11_postinstall_aiops.sh script has run to completion."
      echo "      ❗    This should create the Strimzi Route automatically."
else
      echo "       ✅ OK - Kafka Broker"
fi

echo "    🔬 Check for Kafka Password"

if [[ $KAFKA_PASSWORD == "" ]] ;
then
      echo "      ❗ Strimzi Kafka Password not found..."
      echo "      ❗    Make sure that the 11_postinstall_aiops.sh script has run to completion."
else
      echo "       ✅ OK - Kafka Password"
fi





#oc delete pod $(oc get pods | grep event-gateway-generic-evtmgrgw | awk '{print $1;}')
echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "🔎 Check CP4WAIOPS Installation"
echo "--------------------------------------------------------------------------------------------"


checkCSDone
checkInstallDone




echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "🔎 Check Pods"
echo "--------------------------------------------------------------------------------------------"



echo "    🔬 Check for Anomaly Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep log-anomaly-detector | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep log-anomaly-detector | grep 0/1 || true)
    echo "      🕦 wait for Anomaly Pod" 
    sleep 10
done
echo "       ✅ OK"

echo "    🔬 Check for Event Grouping Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep aimanager-aio-event-grouping | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep aimanager-aio-event-grouping | grep 0/1 || true)
    echo "      🕦 wait for Event Grouping Pod" 
    sleep 10
done
echo "       ✅ OK"


echo "    🔬 Check for Task Manager Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep flink-task-manager-0 | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep flink-task-manager-0 | grep 0/1 || true)
    echo "      🕦 wait for Flink Task Manager Pod" 
    sleep 10
done
echo "       ✅ OK"

echo "    🔬 Check for Gateway Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep event-gateway-generic | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep event-gateway-generic | grep 0/1 || true)
    echo "      🕦 wait for Gateway Pod" 
    sleep 10
done
echo "       ✅ OK"





echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "🔎 Check RobotShop Demo (must all be Running 1/1)"
echo "--------------------------------------------------------------------------------------------"


oc get -n robot-shop pods | grep -v shipping







echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "🔎 Check Kafka Topics"
echo "--------------------------------------------------------------------------------------------"




export LOGS_TOPIC=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE | grep logs-humio| awk '{print $1;}')


echo "    🔬 Check derived-stories KafkaTopic" 

TOPIC_READY=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE derived-stories -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE derived-stories -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for derived-stories KafkaTopic" 
    sleep 3
done
echo "       ✅ OK"



echo "    🔬 Check windowed-logs KafkaTopic" 

TOPIC_READY=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE windowed-logs-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE windowed-logs-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for windowed-logs KafkaTopic" 
    sleep 3
done
echo "       ✅ OK"


echo "    🔬 Check normalized-alerts KafkaTopic" 

TOPIC_READY=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE normalized-alerts-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE normalized-alerts-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for normalized-alerts KafkaTopic" 
    sleep 3
done
echo "       ✅ OK"





echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀 DONE - You're good to go!!!!!"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
