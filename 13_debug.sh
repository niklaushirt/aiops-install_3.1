

kubectl patch deployment evtmanager-topology-merge -n aiops --patch-file ./yaml/waiops/topology-merge-patch.yaml


kubectl patch deployment evtmanager-ibm-hdm-analytics-dev-inferenceservice -n aiops --patch-file ./yaml/waiops/evtmanager-inferenceservice-patch.yaml



kubectl apply -n aiops -f ./yaml/gateway/gateway_cr_cm.yaml
oc delete pod -n aiops $(oc get po -n aiops|grep event-gateway-generic|awk '{print$1}')




oc exec -it $(oc get po |grep aimanager-aio-controller|awk '{print$1}') bash


