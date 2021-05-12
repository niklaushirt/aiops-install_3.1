
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


curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-web"],"matchTokens": ["qotd-web"],"name": "qotd-web","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-web-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-author"],"matchTokens": ["qotd-author"],"name": "qotd-author","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-author-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-quote"],"matchTokens": ["qotd-quote"],"name": "qotd-quote","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-quote-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-pdf"],"matchTokens": ["qotd-pdf"],"name": "qotd-pdf","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-pdf-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-image"],"matchTokens": ["qotd-image"],"name": "qotd-image","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-image-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-db"],"matchTokens": ["qotd-db"],"name": "qotd-db","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-db-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-ratings"],"matchTokens": ["qotd-ratings"],"name": "qotd-ratings","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-ratings-id"}'

curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-load"],"matchTokens": ["qotd-load"],"name": "qotd-load","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-load-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "qotd","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["qotd-usecase"],"matchTokens": ["qotd-usecase"],"name": "qotd-usecase","namespace": "qotd","readyReplicas": 1,"tags": ["app:qotd","namespace:qotd"],"vertexType": "resource","uniqueId": "qotd-usecase-id"}'







# -------------------------------------------------------------------------------------------------------------------------------------------------
# CREATE LINKS
# -------------------------------------------------------------------------------------------------------------------------------------------------

curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-web-id","_toUniqueId": "qotd-author-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-web-id","_toUniqueId": "qotd-quote-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-web-id","_toUniqueId": "qotd-pdf-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-web-id","_toUniqueId": "qotd-ratings-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-pdf-id","_toUniqueId": "qotd-quote-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-author-id","_toUniqueId": "qotd-image-id"}'


curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-author-id","_toUniqueId": "qotd-db-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-quote-id","_toUniqueId": "qotd-db-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-ratings-id","_toUniqueId": "qotd-db-id"}'

curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-load-id","_toUniqueId": "qotd-web-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "qotd-usecase-id","_toUniqueId": "qotd-web-id"}'
