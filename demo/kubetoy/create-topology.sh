#export CLUSTER_NAME=tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud


# Deployments
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "kubetoy","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"matchTokens": ["kubetoy-deployment"],"name": "kubetoy-deployment","namespace": "kubetoy","readyReplicas": 1,"tags": ["app:kubetoy","namespace:kubetoy"],"vertexType": "resource","uniqueId": "kubetoy-deployment-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "kubetoy","dataCenter": "demo","entityTypes": ["pod"],"matchTokens": ["kubetoy-pod"],"name": "kubetoy-pod","namespace": "kubetoy","readyReplicas": 1,"tags": ["app:kubetoy","namespace:kubetoy"],"vertexType": "resource","uniqueId": "kubetoy-pod-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $NOI_REST_USR':'$NOI_REST_PWD -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "kubetoy","dataCenter": "demo","entityTypes": ["service"],"matchTokens": ["kubetoy-svc"],"name": "kubetoy-svc","namespace": "kubetoy","readyReplicas": 1,"tags": ["app:kubetoy","namespace:kubetoy"],"vertexType": "resource","uniqueId": "kubetoy-svc-id"}'



curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "manages","_fromUniqueId": "kubetoy-deployment-id","_toUniqueId": "kubetoy-pod-id"}'
curl -X "POST" "https://topology-rest-aiops.$CLUSTER_NAME/1.0/rest-observer/rest/references" --insecure -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -H 'JobId: listenJob' -H 'Content-Type: application/json; charset=utf-8' -u $NOI_REST_USR':'$NOI_REST_PWD -d $'{"_edgeType": "manages","_fromUniqueId": "kubetoy-pod-id","_toUniqueId": "kubetoy-svc-id"}'

