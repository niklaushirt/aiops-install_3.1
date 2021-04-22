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














































source ./01_config.sh

#!/bin/bash
menu_option_one () {
  echo "Kafka Topics"
  oc get kafkatopic -n zen

}

menu_option_two() {
  echo "Monitor Derived Stories"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

  export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  echo "	Press Enter to start, press CTRL-C to stop "
  read

  kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t derived-stories 

}

menu_option_three() {
  echo "Monitor Specific Topic"
  mv ca.crt ca.crt.old
  oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt
  oc get kafkatopic -n zen | awk '{print $1}'

  export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
  
  read -p "Copy Paste Topic from above: " MY_TOPIC

  kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o -10 -C -t $MY_TOPIC
}




clear
get_sed

banner
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 AI OPS DEBUG"
echo "***************************************************************************************************************************************************"

echo "  Initializing......"

echo "  Checking K8s connection......"
checkK8sConnection

echo "***************************************************************************************************************************************************"
echo "  "


until [ "$selection" = "0" ]; do
  
  echo ""
  
  echo "  🔎 Observe Kafka Topics "
  echo "    	1  - Get Kafka Topics"
  echo "    	2  - Monitor Derived Stories"
  echo "    	3  - Monitor Specific Topic"
  echo "      "
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_one ; press_enter ;;
    2 ) clear ; menu_option_two ; press_enter ;;
    3 ) clear ; menu_option_three ; press_enter ;;
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done







