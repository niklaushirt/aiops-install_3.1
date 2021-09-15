# https://github.ibm.com/katamari/dev-issue-tracking/issues/4484
# https://github.ibm.com/katamari/dev-issue-tracking/issues/10680


topology-manage


oc get secret evtmanager-topology-asm-credentials -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'

echo -n “aimanager-topology-cp4waiops-user:7mTCrlfQAQteq1TxDCGcOhdgxWAJ1q8nLh5DMUC9nJM=“ | base64

oc -n aiops get secret evtmanager-topology-asm-credentials -o jsonpath='{.data.password}' | base64 --decode && echo

export ASM_TOPOLOGY_URL="https://evtmanager-topology-$WAIOPS_NAMESPACE.cp4waiops31-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud"
export OBSERVER_JOB_NAME="robot-shop"
export OBSERVER_JOB_NAME="kubetoy"

export ASM_TENANTID="cfd95b7e-3bc7-4006-a4a8-a73a79c71255"

export ASM_USERNAME=$(oc -n aiops get secret evtmanager-topology-asm-credentials -o jsonpath='{.data.username}' | base64 --decode)
export ASM_PASSWORD=$(oc -n aiops get secret evtmanager-topology-asm-credentials -o jsonpath='{.data.password}' | base64 --decode)

echo $ASM_USERNAME
echo $ASM_PASSWORD

export ASM_CREDENTIALS=$(echo -n $ASM_USERNAME:$ASM_PASSWORD | base64)
echo $ASM_CREDENTIALS
echo $ASM_CREDENTIALS | base64 --decode
echo $ASM_TENANTID


# export ASM_JOB_ID=$(curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts?_filter=entityTypes%3DASM_OBSERVER_JOB&_filter=name%3D$OBSERVER_JOB_NAME&_field=name&_field=keyIndexName&_include_count=false" | jq '._items[]._id'| tr -d '"')

# export ASM_JOB_ID=$(curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts?_type=observation&_filter=name%3D$OBSERVER_JOB_NAME&_field=name&_field=keyIndexName&_include_count=false" | jq '._items[]._id'| tr -d '"')
# echo $ASM_JOB_ID
export ASM_JOB_ID=$(curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts?_type=observation&_filter=name%3Dkubernetes-observer:$OBSERVER_JOB_NAME&_field=name&_field=keyIndexName&_include_count=false" | jq '._items[]._id'| tr -d '"')
echo $ASM_JOB_ID


export ASM_PROVIDER_ID=$(curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts/$ASM_JOB_ID/references/in/provided?_field=*&_return=nodes&_include_count=false" -k | jq '._items[] | select(.name|contains("KUB"))|.providerId'| tr -d '"')
echo $ASM_PROVIDER_ID


curl -X POST --insecure --header "Accept: application/json" --header "Content-Type: application/json"  --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" -d "{ \"providerId\": \"$ASM_PROVIDER_ID\" }" "$ASM_TOPOLOGY_URL/1.0/topology/crawlers/deleteProviderResources" -k 



curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts/$ASM_PROVIDER_ID/references/out/provided?_filter=vertexType%3Dresource&_field=*&_return=nodes&_include_count=true"
exit 1






curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts/$ASM_JOB_ID/references/in/provided?_field=*&_return=nodes&_include_count=false" -k
curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts/$ASM_JOB_ID/references/in/provided?_field=*&_return=nodes&_include_count=false" -k | jq '._items[]._id'

curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts/$ASM_JOB_ID/references/in/provided?_field=*&_return=nodes&_include_count=false" -k | jq '._items[] | select(.name|contains("KUB"))'



curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts?_include_count=false"


curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts?_filter=entityTypes%3AASM_OBSERVER_JOB&_filter=name%3D**as-asmith-delete-test-1**&_field=name&_field=keyIndexName&_field=observationCount&_include_count=false" -k {"_executionTime":2,"_offset":0,"_limit":50,"_items":[{"keyIndexName":"kubernetes-observer:as-asmith-delete-test-1","_id":"f8-GHZw-SE2WbKbgsJTAOg","observationCount":25,"name":"as-asmith-delete-test-1"}]}


curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts?_filter=entityTypes%3AASM_OBSERVER_JOB&_filter=name%3D**$OBSERVER_JOB_NAME**&_field=name&_field=keyIndexName&_field=observationCount&_include_count=false" -k {"_executionTime":2,"_offset":0,"_limit":50,"_items":[{"keyIndexName":"kubernetes-observer:$OBSERVER_JOB_NAME","_id":"f8-GHZw-SE2WbKbgsJTAOg","observationCount":25,"name":"$OBSERVER_JOB_NAME"}]}






curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts?_filter=entityTypes%3DASM_OBSERVER_JOB&_filter=name%3D$OBSERVER_JOB_NAME&_field=name&_field=keyIndexName&_include_count=false"



curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" "$ASM_TOPOLOGY_URL/1.0/topology/mgmt_artifacts/FVLDqfVcRFy371aK_6ktJQ/references/in/provided?_field=*&_return=nodes&_include_count=false" -k



3UMEuO4wFP9DgENPzHX2og

curl -X POST --insecure --header "Accept: application/json" --header "Content-Type: application/json"  --header "X-TenantID: $ASM_TENANTID" --header "Authorization: Basic $ASM_CREDENTIALS" -d "{ "providerId": "3UMEuO4wFP9DgENPzHX2og" }" "$ASM_TOPOLOGY_URL/1.0/topology/crawlers/deleteProviderResources" -k 




curl -X GET --insecure --header "Accept: application/json" --header "X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255" --header "Authorization: Basic 4oCcYWltYW5hZ2VyLXRvcG9sb2d5LWFpb3BzLXVzZXI6SXpJSk5KYUwrMi92blNMRUgybnIvRU1DVkpRaVRwcFlXejRiSi81cTJPZz3igJw=" "https://evtmanager-topology-$WAIOPS_NAMESPACE.cp4waiops31-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/topology/mgmt_artifacts?_include_count=false"