source ./01_config.sh


oc create clusterrolebinding default-admin --clusterrole=cluster-admin --serviceaccount=default:default
oc create clusterrolebinding default-admin-demo --clusterrole=cluster-admin --serviceaccount=default:demo-admin
oc apply -n default -f ./demotoy/demotoy-all-in-one-vanilla.yaml

DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 -d)
DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')
echo  "oc login --token=$DEMO_TOKEN --server=$DEMO_URL"


oc patch cm demotoy-configmap-env -n default -p '{"data": {"OCP_URL": "'${DEMO_URL}'"}}' --type=merge
oc patch cm demotoy-configmap-env -n default -p '{"data": {"TOKEN": "'${DEMO_TOKEN}'"}}' --type=merge
oc patch cm demotoy-configmap-env -n default -p '{"data": {"SEC_TOKEN": "demo"}}' --type=merge




oc patch cm demotoy-configmap-env -n default -p '{"data": {"NETCOOL_WEBHOOK_HUMIO": "'${NETCOOL_WEBHOOK_HUMIO}'"}}' --type=merge
oc patch cm demotoy-configmap-env -n default -p '{"data": {"NETCOOL_WEBHOOK_GIT": "'${NETCOOL_WEBHOOK_GIT}'"}}' --type=merge
oc patch cm demotoy-configmap-env -n default -p '{"data": {"NETCOOL_WEBHOOK_METRICS": "'${NETCOOL_WEBHOOK_METRICS}'"}}' --type=merge
oc patch cm demotoy-configmap-env -n default -p '{"data": {"NETCOOL_WEBHOOK_FALCO": "'${NETCOOL_WEBHOOK_FALCO}'"}}' --type=merge
oc patch cm demotoy-configmap-env -n default -p '{"data": {"NETCOOL_WEBHOOK_INSTANA": "'${NETCOOL_WEBHOOK_INSTANA}'"}}' --type=merge

oc delete pod -n default $(oc get po -n default|grep demotoy|awk '{print$1}') --force --grace-period=0 


echo "accesstoken=demo"