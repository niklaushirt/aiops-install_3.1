#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Webhooks for Event injection
export NETCOOL_WEBHOOK_HUMIO=https://netcool.demo-noi.aiopsch-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/humio/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/e9fd3a7e-5632-4c96-a30f-43f5e0ce2b16/u5O06fLmVrCca1wZbPkakc1h9B09RTBz97CQS-pF76g

export NETCOOL_WEBHOOK_GIT=https://netcool.demo-noi.aiopsch-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/61401236-15f3-4d23-9c21-bd49979d9465/uYgsIosAStCXKjpaTiCiaAVDfr2npH1i2SnxoYo0KlE

export NETCOOL_WEBHOOK_METRICS=not_configured

export NETCOOL_WEBHOOK_FALCO=https://netcool.demo-noi.aiopsch-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/c8a9af32-222d-42e2-84ec-131d65b37b26/i5R11IWRUS2eien6W8HdpegitCwdgNtr2vzeg6IPWeg

export NETCOOL_WEBHOOK_INSTANA=https://netcool.demo-noi.aiopsch-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/3a00ec2e-df2f-4b9c-a90d-6226eb63a625/m2RJJ0dEBZHQByN9-ArjreA9lTvSTJZaS-ONzJYpPAY


# Bookinfo
export appgroupid_bookinfo=cyyejiie
export appid_bookinfo=iehl4yav

# Robotshop
export appgroupid_robotshop=j9aw0vxl
export appid_robotshop=flotlnkf

# Kubetoy
export appgroupid_sockshop=not_configured
export appid_sockshop=not_configured

# Sockshop
export appgroupid_kubetoy=not_configured
export appid_kubetoy=not_configured




# Only for Topology Load
export NOI_REST_USR=demo-noi-topology-noi-user
export NOI_REST_PWD=j4k/7LVBUCuaqgXiqcZDHftuJ5bVD6tJJuclOHJPGkY=

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


















































createTopics() {
cat <<EOF | kubectl apply -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: normalized-alerts-demoapps-$appid 
  namespace: zen
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: normalized-alerts-demoapps-$appid 
---
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: windowed-logs-demoapps-$appid 
  namespace: zen
  labels:
    strimzi.io/cluster: strimzi-cluster
spec:
  config:
    max.message.bytes: '1048588'
    retention.ms: '1800000'
    segment.bytes: '1073741824'
  partitions: 1
  replicas: 1
  topicName: windowed-logs-demoapps-$appid 
EOF
}


createDerivedStoriesTopics() {
cat <<EOF | kubectl apply -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: derived-stories
  namespace: zen
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
}


press_enter() {
  echo ""
  echo "	Press Enter to continue "
  read
  clear
}


checkK8sConnection () {
  CLUSTER_ROUTE=$(kubectl get routes console -n openshift-console | tail -n 1 2>&1 ) 

  if [[ $CLUSTER_ROUTE =~ "reencrypt/Redirect" ]];
  then
      CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
      export OCP_CONSOLE_PREFIX=console-openshift-console
      export CLUSTER_NAME=$(echo $CLUSTER_FQDN | ${SED} "s/$OCP_CONSOLE_PREFIX.//")
      echo "      ✅ OK"
      echo "  🔭  Cluster URL: $CLUSTER_NAME"
  else 
      echo "      ❗ ERROR: Please log in via the OpenShift web console"
      echo "           ❌ Aborting."
      exit 1
  fi
}

incorrect_selection() {
  echo "Incorrect selection! Try again."
}

get_sed(){
  # fix sed issue on mac
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  SED="sed"
  if [ "${OS}" == "darwin" ]; then
      SED="gsed"
      if [ ! -x "$(command -v ${SED})"  ]; then
      __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
      exit
      fi
  fi
}



function banner() {


echo "   __________  __ ___       _____    ________            "
echo "  / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____"
echo " / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/"
echo "/ /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) "
echo "\____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  "
echo "                                          /_/            "
echo ""

}                               
