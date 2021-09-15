# https://www.ibm.com/support/pages/node/6381380

oc project ibm-common-services

oc delete secret cs-ca-certificate-secret -n ibm-common-services
mkdir secret_backup
cd secret_backup

oc get certs -o custom-columns=:spec.secretName,:spec.issuerRef.name --no-headers |egrep "cs-ca-clusterissuer|cs-ca-issuer" | while read secretName issuerName
do
oc get secret $secretName -o yaml -n ibm-common-services > secret.$secretName.yaml
oc delete secret $secretName -n ibm-common-services
done

oc delete pod -l app=auth-idp -n ibm-common-services
oc delete pod -l app=auth-pap -n ibm-common-services
oc delete pod -l app=auth-pdp -n ibm-common-services

oc delete secret ibmcloud-cluster-ca-cert -n ibm-common-services

oc delete route cp-console -n ibm-common-services

oc delete secret ibmcloud-cluster-ca-cert -n kube-system
oc delete secret ibmcloud-cluster-ca-cert -n open-cluster-management-issuer




