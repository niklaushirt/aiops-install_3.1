# https://www-03preprod.ibm.com/support/knowledgecenter/SSJGDOB_3.1.0/planning/considerations_storage.html
# https://docs.portworx.com/portworx-install-with-kubernetes/openshift/operator/2-deploy-px/ 
# https://central.portworx.com/specGen/wizard

oc -n kube-system create secret generic px-essential \
  --from-literal=px-essen-user-id=YOUR_ESSENTIAL_ENTITLEMENT_ID \
  --from-literal=px-osb-endpoint='https://pxessentials.portworx.com/osb/billing/v1/register'

oc apply -f ./tools/7_storage/portworx/px-test.yaml
