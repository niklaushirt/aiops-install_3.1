source ./01_config.sh

banner

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 CP4WAIOPS CHECK DEMO RESET"
echo "***************************************************************************************************************************************************"

echo ""
echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Check Pods"
echo "--------------------------------------------------------------------------------------------------------------------------------"

export LOGS_TOPIC=$(oc get KafkaTopic -n $WAIOPS_NAMESPACE | grep logs-humio| awk '{print $1;}')


#echo " ✅ OK"

echo "      🔎 Check derived-stories KafkaTopic" 

TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE derived-stories -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE derived-stories -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for derived-stories KafkaTopic" 
    sleep 3
done
echo " ✅ OK"



echo "      🔎 Check windowed-logs KafkaTopic" 

TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE windowed-logs-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE windowed-logs-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for windowed-logs KafkaTopic" 
    sleep 3
done
echo " ✅ OK"


echo "      🔎 Check normalized-alerts KafkaTopic" 

TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE normalized-alerts-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE normalized-alerts-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for normalized-alerts KafkaTopic" 
    sleep 3
done
echo " ✅ OK"

echo "      🔎 Check $LOGS_TOPIC KafkaTopic" 

TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE $LOGS_TOPIC -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(oc get KafkaTopics -n $WAIOPS_NAMESPACE $LOGS_TOPIC -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for $LOGS_TOPIC KafkaTopic" 
    sleep 3
done
echo " ✅ OK"


#oc delete pod $(oc get pods | grep event-gateway-generic-evtmgrgw | awk '{print $1;}')





echo "      🔎 Check for Anomaly Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep log-anomaly-detector | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep log-anomaly-detector | grep 0/1 || true)
    echo "      🕦 wait for Anomaly Pod" 
    sleep 10
done
echo " ✅ OK"

echo "      🔎 Check for Event Grouping Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep aimanager-aio-event-grouping | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep aimanager-aio-event-grouping | grep 0/1 || true)
    echo "      🕦 wait for Event Grouping Pod" 
    sleep 10
done
echo " ✅ OK"


echo "      🔎 Check for Task Manager Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep flink-task-manager-0 | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep flink-task-manager-0 | grep 0/1 || true)
    echo "      🕦 wait for Flink Task Manager Pod" 
    sleep 10
done
echo " ✅ OK"

echo "      🔎 Check for Gateway Pod" 

SUCCESFUL_RESTART=$(oc get pods | grep event-gateway-generic | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(oc get pods | grep event-gateway-generic | grep 0/1 || true)
    echo "      🕦 wait for Gateway Pod" 
    sleep 10
done
echo " ✅ OK"


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "  ✅ DONE... You're good to go...."
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"

