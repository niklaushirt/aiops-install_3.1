#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES in ./01_config.sh
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

source ./tools/0_global/99_config-global.sh
export LOG_TYPE=humio   # humio, elk, splunk, ...











































#!/bin/bash
menu_option_1 () {
  echo "Kafka Topics"
  oc get kafkatopic -n $WAIOPS_NAMESPACE

}

menu_option_2() {
  echo "Monitor Derived Stories"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt

  export sasl_password=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t derived-stories 

}


menu_option_3() {
  echo "Monitor Alerts NOI"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt

  export sasl_password=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t alerts-noi-1000-1000

}


menu_option_4() {
  echo "Monitor $LOGS_TOPIC"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt

  export sasl_password=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t $LOGS_TOPIC 

}

menu_option_9() {
  echo "Monitor Specific Topic"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt
  oc get kafkatopic -n $WAIOPS_NAMESPACE | awk '{print $1}'

  export sasl_password=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  read -p "Copy Paste Topic from above: " MY_TOPIC

  ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t $MY_TOPIC
}




clear



echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 AI OPS DEBUG - Kafka"
echo "***************************************************************************************************************************************************"

echo "  Initializing......"
get_kafkacat



echo "***************************************************************************************************************************************************"
echo "  "

export LOGS_TOPIC=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE | grep logs-$LOG_TYPE| awk '{print $1;}')


until [ "$selection" = "0" ]; do
  
  echo ""
  
  echo "  🔎 Observe Kafka Topics "
  echo "    	1  - Get Kafka Topics"
  echo "    	2  - Monitor Derived Stories"
  echo "    	3  - Monitor Alerts NOI"
  echo "    	4  - Monitor $LOGS_TOPIC"
  echo "    	9  - Monitor Specific Topic"
  echo "      "
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_1  ;;
    2 ) clear ; menu_option_2  ;;
    3 ) clear ; menu_option_3  ;;
    4 ) clear ; menu_option_4  ;;
    9 ) clear ; menu_option_9  ;;

    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection  ;;
  esac
done







