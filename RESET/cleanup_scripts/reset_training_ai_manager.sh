#!/bin/bash

set -e

# Variables
payload='{"query":{"match_all":{}}}'

# Get the api-server pod
platform_api_pod=$(oc get pods | grep ai-platform-api-server | head -1 | awk '{print $1;}')

# Get Elasticesearch access credentials
username=$(oc exec ${platform_api_pod} -- env | grep ES_USERNAME)
arrIN=(${username//=/ })
username=${arrIN[1]} 

password=$(oc exec ${platform_api_pod} -- env | grep ES_PASSWORD)
arrIN=(${password//=/ })
password=${arrIN[1]} 

url=$(oc exec ${platform_api_pod} -- env | grep ES_URL)
arrIN=(${url//=/ })
url=${arrIN[1]} 

echo "Clearing all training definitions"
oc exec ${platform_api_pod} -- curl -X POST -u ${username}:${password} ${url}/trainingdefinition/_delete_by_query -k -H 'Content-Type: application/json' -d ${payload}

echo "Clearing all training datasets"
oc exec ${platform_api_pod} -- curl -X POST -u ${username}:${password} ${url}/dataset/_delete_by_query -k -H 'Content-Type: application/json' -d ${payload}

echo "Clearing all training prechecks"
oc exec ${platform_api_pod} -- curl -X POST -u ${username}:${password} ${url}/prechecktrainingdetails/_delete_by_query -k -H 'Content-Type: application/json' -d ${payload}

echo "Clearing all training postchecks"
oc exec ${platform_api_pod} -- curl -X POST -u ${username}:${password} ${url}/postchecktrainingdetails/_delete_by_query -k -H 'Content-Type: application/json' -d ${payload}

echo "Clearing all deployment indices"
oc exec ${platform_api_pod} -- curl -X DELETE -u ${username}:${password} ${url}/1000-1000-log_models_latest -k
oc exec ${platform_api_pod} -- curl -X DELETE -u ${username}:${password} ${url}/1000-1000-event_models_latest -k
oc exec ${platform_api_pod} -- curl -X DELETE -u ${username}:${password} ${url}/1000-1000-changerisk_models_latest -k
oc exec ${platform_api_pod} -- curl -X DELETE -u ${username}:${password} ${url}/1000-1000-indicent_models_latest -k

# Clear any outstanding log models
echo "Clearing any outstanding log models"
oc exec ${platform_api_pod} -- curl -X DELETE -u ${username}:${password} ${url}/1000-1000-v* -k

# Clear any logs imported into AIOps for training
#echo "Clearing any imported logs"
#oc exec ${platform_api_pod} -- curl -X DELETE -u ${username}:${password} ${url}/*logtrain -k

echo "Success; done!"
