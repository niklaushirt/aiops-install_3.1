#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Webhooks for Event injection
export NETCOOL_WEBHOOK_HUMIO=not_configured

export NETCOOL_WEBHOOK_GIT=not_configured

export NETCOOL_WEBHOOK_METRICS=not_configured

export NETCOOL_WEBHOOK_FALCO=not_configured

export NETCOOL_WEBHOOK_INSTANA=not_configured


# Bookinfo
export appgroupid_bookinfo=not_configured
export appid_bookinfo=not_configured

# Robotshop
export appgroupid_robotshop=not_configured
export appid_robotshop=not_configured

# Kubetoy
export appgroupid_sockshop=not_configured
export appid_sockshop=not_configured

# Sockshop
export appgroupid_kubetoy=not_configured
export appid_kubetoy=not_configured



# WAIOPS AI Manager install namespace (default is aiops)
export WAIOPS_NAMESPACE=aiops

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


















































createTopics() {
cat <<EOF | oc apply -f -
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
cat <<EOF | oc apply -f -
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
  CLUSTER_ROUTE=$(oc get routes console -n openshift-console | tail -n 1 2>&1 ) 

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
