


echo "   __________  __ ___       _____    ________            "
echo "  / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____"
echo " / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/"
echo "/ /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) "
echo "\____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  "
echo "                                          /_/            "
echo ""

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 CP4WAIOPS RESET DEMO"
echo "***************************************************************************************************************************************************"


  read -p "❗ Are you really, really, REALLY sure you want to reset the demo? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
    echo "      🧞‍♂️ OK, as you wish...."
  else
    echo "      ❌ Aborted"
    exit 1
  fi
  
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# Reset Demo - Clean Up
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------------------
oc project aiops >/dev/null 2>&1

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Scale up Bookinfo"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc scale --replicas=1  deployment ratings-v1 -n bookinfo
echo " ✅ OK"


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Scale up RobotShop"
echo "--------------------------------------------------------------------------------------------------------------------------------"

robot_cat_running=$(oc get deployment catalogue -n robot-shop)
if [[ $robot_cat_running =~ "0/0" ]];
then
    oc scale --replicas=1  deployment catalogue -n robot-shop #>/dev/null 2>&1
    kubectl apply -f ./demo_install/robotshop/robot-all-in-one.yaml -n robot-shop
    oc delete pod -n robot-shop $(oc get po -n robot-shop|grep catalogue|awk '{print$1}') --force --grace-period=0 #>/dev/null 2>&1
    oc delete pod -n robot-shop $(oc get po -n robot-shop|grep user|awk '{print$1}') --force --grace-period=0 #>/dev/null 2>&1
    oc delete pod -n robot-shop $(oc get po -n robot-shop|grep shipping|awk '{print$1}') #--force --grace-period=0 #>/dev/null 2>&1
    echo " ✅ OK"
fi




echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Save existing kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl get kafkatopic -n aiops| awk '{print $1}' # > all_topics_$(date +%s).yaml
echo " ✅ OK"



echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Delete kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl get kafkatopic -n aiops| grep window | awk '{print $1}' | xargs kubectl delete kafkatopic -n aiops
echo " ✅ OK"

kubectl get kafkatopic -n aiops| grep normalized | awk '{print $1}'| xargs kubectl delete kafkatopic -n aiops
echo " ✅ OK"

kubectl get kafkatopic -n aiops| grep derived | awk '{print $1}'| xargs kubectl delete kafkatopic -n aiops
echo " ✅ OK"


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Recreate Topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"




echo "Creating topics windowed-logs-1000-1000 and normalized-alerts-1000-1000\n\n"
cat <<EOF | kubectl apply -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: normalized-alerts-1000-1000 
  namespace: aiops
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: normalized-alerts-1000-1000 
---
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: windowed-logs-1000-1000 
  namespace: aiops
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: windowed-logs-1000-1000 
EOF
echo " ✅ OK"




cat <<EOF | kubectl apply -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: derived-stories
  namespace: aiops
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: derived-stories 
EOF
echo " ✅ OK"







echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Kafka topics"
echo "--------------------------------------------------------------------------------------------------------------------------------"

kubectl get kafkatopic -n aiops
echo " ✅ OK"



echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Clear Stories DB"
echo "--------------------------------------------------------------------------------------------------------------------------------"

oc project aiops

echo "1/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/similar_incident_lists
echo ""
echo "2/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/alertgroups
echo ""
echo "3/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/app_states
echo ""
echo "4/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k -X DELETE https://localhost:8443/v2/stories
echo ""
echo "5/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/similar_incident_lists
echo ""
echo "6/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/alertgroups
echo ""
echo "7/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/application_groups/{application-group-id}/app_states
echo ""
echo "8/8"
kubectl exec -it $(kubectl get pods | grep persistence | awk '{print $1;}') -- curl -k https://localhost:8443/v2/stories
echo ""
echo " ✅ OK"


echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Refresh the Flink Jobs"
echo "--------------------------------------------------------------------------------------------------------------------------------"



echo "1/6:  Logs"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/1000/applications/1000/refresh?datasource_type=logs
echo " ✅ OK"
echo ""
echo "2/6:  Events"
kubectl exec -it $(kubectl get pods | grep aio-controller | awk '{print $1;}') -- curl -k -X PUT https://localhost:9443/v2/connections/application_groups/1000/applications/1000/refresh?datasource_type=alerts
echo " ✅ OK"





echo ""
echo ""
echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Restart Pods"
echo "--------------------------------------------------------------------------------------------------------------------------------"



#kubectl delete pod $(kubectl get pods | grep anomaly | awk '{print $1;}')
#kubectl delete pod $(kubectl get pods | grep event | awk '{print $1;}') 
#kubectl delete pod $(kubectl get pods | grep flink-task-manager-0 | awk '{print $1;}') 
echo " ✅ OK"

echo "      🔎 Check derived-stories KafkaTopic" 

TOPIC_READY=$(kubectl get KafkaTopics -n aiops derived-stories -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(kubectl get KafkaTopics -n aiops derived-stories -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for derived-stories KafkaTopic" 
    sleep 3
done
echo " ✅ OK"



echo "      🔎 Check windowed-logs KafkaTopic" 

TOPIC_READY=$(kubectl get KafkaTopics -n aiops windowed-logs-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(kubectl get KafkaTopics -n aiops windowed-logs-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for windowed-logs KafkaTopic" 
    sleep 3
done
echo " ✅ OK"


echo "      🔎 Check normalized-alerts KafkaTopic" 

TOPIC_READY=$(kubectl get KafkaTopics -n aiops normalized-alerts-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)

while  ([[ ! $TOPIC_READY =~ "True" ]] ); do 
    TOPIC_READY=$(kubectl get KafkaTopics -n aiops normalized-alerts-1000-1000 -o jsonpath='{.status.conditions[0].status}' || true)
    echo "      🕦 wait for normalized-alerts KafkaTopic" 
    sleep 3
done
echo " ✅ OK"

echo "      🔎 Check for Anomaly Pod" 

SUCCESFUL_RESTART=$(kubectl get pods | grep anomaly | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(kubectl get pods | grep anomaly | grep 0/1 || true)
    echo "      🕦 wait for Anomaly Pod" 
    sleep 10
done
echo " ✅ OK"

echo "      🔎 Check for Event Grouping Pod" 

SUCCESFUL_RESTART=$(kubectl get pods | grep event | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(kubectl get pods | grep event | grep 0/1 || true)
    echo "      🕦 wait for Event Grouping Pod" 
    sleep 10
done
echo " ✅ OK"


echo "      🔎 Check for Task Manager" 

SUCCESFUL_RESTART=$(kubectl get pods | grep flink-task-manager-0 | grep 0/1 || true)

while  ([[ $SUCCESFUL_RESTART =~ "0" ]] ); do 
    SUCCESFUL_RESTART=$(kubectl get pods | grep flink-task-manager-0 | grep 0/1 || true)
    echo "      🕦 wait for Flink Task Manager Pod" 
    sleep 10
done
echo " ✅ OK"


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "  ✅ DONE... You're good to go...."
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------------------------------"

