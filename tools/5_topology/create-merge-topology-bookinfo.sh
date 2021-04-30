#export CLUSTER_NAME=tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud

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


# Deployments
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["productpage-v1"],"name": "productpage-v1","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "productpage-v1-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["reviews-v1"],"name": "reviews-v1","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "reviews-v1-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["reviews-v2"],"name": "reviews-v2","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "reviews-v2-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["reviews-v3"],"name": "reviews-v3","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "reviews-v3-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["details-v1"],"name": "details-v1","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "details-v1-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "bookinfo","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["ratings-v1"],"name": "ratings-v1","namespace": "bookinfo","readyReplicas": 1,"tags": ["app:productpage","namespace:bookinfo"],"vertexType": "resource","uniqueId": "ratings-v1-id"}'

curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "productpage-v1-id","_toUniqueId": "details-v1-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "productpage-v1-id","_toUniqueId": "reviews-v1-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "productpage-v1-id","_toUniqueId": "reviews-v2-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "productpage-v1-id","_toUniqueId": "reviews-v3-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "reviews-v2-id","_toUniqueId": "ratings-v1-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $LOGIN -d $'{"_edgeType": "dependsOn","_fromUniqueId": "reviews-v3-id","_toUniqueId": "ratings-v1-id"}'



