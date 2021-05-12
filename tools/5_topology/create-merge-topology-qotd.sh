
source ./99_config-global.sh

export SCRIPT_PATH=$(pwd)
export LOG_PATH=""
__getClusterFQDN
__getInstallPath


export NOI_REST_USR="aimanager-topology-aiops-user"
export NOI_REST_PWD=$(oc get secret evtmanager-topology-asm-credentials -n $WAIOPS_NAMESPACE -o=template --template={{.data.password}} | base64 -D)


export LOGIN="$NOI_REST_USR:$NOI_REST_PWD"

echo "URL: https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources"
echo "LOGIN: $LOGIN"



# -------------------------------------------------------------------------------------------------------------------------------------------------
# CREATE EDGES
# -------------------------------------------------------------------------------------------------------------------------------------------------


curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-web","test"],"matchTokens": ["qotd-web"],"name": "qotd-web","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-web-id"}'
