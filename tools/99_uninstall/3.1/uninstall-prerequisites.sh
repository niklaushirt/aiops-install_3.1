. ./tools/99_uninstall/3.1/uninstall-cp4waiops-props.sh

echo "Uninstall Strimzi Operator"
oc delete -f ./yaml/strimzi/strimzi-subscription.yaml
oc delete csv strimzi-cluster-operator.v0.19.0 -n openshift-operators


echo "Uninstall Knative Operator"

oc delete -n knative-eventing -f ./yaml/knative/knative-eventing.yaml
oc delete -n knative-serving -f ./yaml/knative/knative-serving.yaml

oc delete --namespace=openshift-serverless -f ./yaml/knative/knative-subscription.yaml

oc delete csv serverless-operator.v1.13.0 -n openshift-serverless


#oc delete ns knative-serving
#oc delete ns knative-eventing
#oc delete ns openshift-serverless
oc get csv -A

echo "Uninstall IBM Operator"
oc delete -n openshift-operators -f ./yaml/waiops/sub-ibm-aiops-orchestrator.yaml


oc delete -f ./yaml/waiops/cat-ibm-operator.yaml
oc delete -f ./yaml/waiops/cat-ibm-aiops.yaml
oc delete -f ./yaml/waiops/cat-ibm-common-services.yaml



