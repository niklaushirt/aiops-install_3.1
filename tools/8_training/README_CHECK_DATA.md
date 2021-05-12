# ----------------------------------------------------------------------------------------------------------------------------------------------------------
## Data Check
# ----------------------------------------------------------------------------------------------------------------------------------------------------------



## Check Number of log lines per container

```bash
cat ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json|jq '.["kubernetes.container_name"]' | sort | uniq -c
```

## Delete istio-proxy entries

```bash
grep -v 'kubernetes.container_name":"details' ./tools/5_training/2_logs/trainingdata/raw/log-bookinfo.json > final.json
```

# Export Training Data

```bash
"kubernetes.namespace_name" = robot-shop
| "kubernetes.container_name" = /web|ratings|catalogue/
| @rawstring = /ratings/ | @rawstring = /error/
```


# Check indices

```bash

oc project aiops
oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') bash

oc exec -it $(oc get po |grep aimanager-aio-ai-platform-api-server|awk '{print$1}') bash


curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | sort

curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep logtrain | sort


oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') -- curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep logtrain | sort


```

oc exec -it $(oc get po |grep es-server-all-0|awk '{print$1}') bash


aimanager-aio-controller


oc exec -it $(oc get po |grep aimanager-aio-ai-platform-api-server|awk '{print$1}') -- bash curl -u elastic:$ES_PASSWORD -XGET https://elasticsearch-ibm-elasticsearch-ibm-elasticsearch-srv.aiops.svc.cluster.local:443/_cat/indices  --insecure | grep logtrain | sort


oc exec -it $(oc get po |grep aimanager-aio-ai-platform-api-server|awk '{print$1}') -- bash
curl -u elastic:$ES_PASSWORD -XGET https://elasticsearch-ibm-elasticsearch-ibm-elasticsearch-srv.aiops.svc.cluster.local:443/_cat/indices  --insecure | grep logtrain | sort

https://pages.github.ibm.com/watson-ai4it/zeno-connection-manager/#/Connections/getKDCConnections

oc exec -it $(oc get po |grep aimanager-aio-controller|awk '{print$1}') bash
curl -k -X GET https://localhost:9443/v3/connections/application_groups/1000/applications/1000/


oc exec -it $(oc get po |grep aimanager-aio-controller|awk '{print$1}') -- curl -k -X GET https://localhost:9443/v2/connections/application_groups/1000/applications/1000/ > test.json
jq '.[] | select(.connection_type=="humio") | .connection_id' test.json
jq '.[] | select(.connection_type=="humio") | .connection_config.display_name' test.json




echo $test |jq '.[] | select(.connection_type=="humio") | .connection_id'


oc exec -it $(oc get po |grep aimanager-aio-controller|awk '{print$1}') -- curl -k -X GET https://localhost:9443/v2/connections/application_groups/1000/applications/1000/ |jq '.[] | select(.connection_type=="humio") | .connection_id'

oc exec -it $(oc get po |grep aimanager-aio-controller|awk '{print$1}') -- curl -k -X PUT https://localhost:9443/v3/connections/1b362b3e-fedf-4da0-8ba0-832f26debbd3/enable
oc exec -it $(oc get po |grep aimanager-aio-controller|awk '{print$1}') -- curl -k -X PUT https://localhost:9443/v3/connections/1b362b3e-fedf-4da0-8ba0-832f26debbd3/disable


