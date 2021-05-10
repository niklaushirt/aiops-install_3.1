#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export WAIOPS_NAMESPACE=aiops


# Webhooks for Event injection
#export NETCOOL_WEBHOOK_GENERIC=https://netcool-evtmanager.dteroks-270003bu3k-iztoq-4b4a324f027aea19c5cbc0c3275c4656-0000.eu-gb.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/c26ee408-bf04-450a-be9e-a5ba21756a2b/bAF1c85UTUqG8N4CqA0aGfYrmMoBkhNl0AqNPe41JVM
#export NETCOOL_WEBHOOK_GENERIC=https://netcool-evtmanager.dteroks-270003bu3k-l3al9-4b4a324f027aea19c5cbc0c3275c4656-0000.eu-gb.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/64fdc14e-1004-4662-862b-8c9f2954935a/IRgqDjqgyhWc7enjCl415hg3JhSqJzl0HLWMnPQPDac
#export NETCOOL_WEBHOOK_GENERIC=https://netcool-evtmanager.cp4waiops31-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/fd34f1ad-f11a-4505-88f7-351c992bcf7e/fTWyWARpRMKrT6tvrnYiHvFdVbH5QlJb91NKcAoMAPs
#export NETCOOL_WEBHOOK_GENERIC=https://netcool-evtmanager.dteroks-270003bu3k-iztoq-4b4a324f027aea19c5cbc0c3275c4656-0000.eu-gb.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/c26ee408-bf04-450a-be9e-a5ba21756a2b/XVlHGXG3l1FhgUtP8nG-Bk8DJqsMIQLlPrW86Zmgtk4
#export NETCOOL_WEBHOOK_GENERIC=https://netcool-evtmanager.dteroks-270003bu3k-ussls-4b4a324f027aea19c5cbc0c3275c4656-0000.eu-gb.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/85afd6bf-80ef-45cc-ac9a-d83a46363f30/X6NUGNb0sHTRXw03eZvVxRVtytgjVYGrUA21vJ6EsVs
export NETCOOL_WEBHOOK_GENERIC=https://netcool-evtmanager.cp4waiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/a0ebac2c-1e48-434e-94b3-4321010b994f/r5u0owukG9rZbxcWbBd2VNNNqDd8nzSsjGpMExZ1r0M
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
































































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
