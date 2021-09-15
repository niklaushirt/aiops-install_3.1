oc create namespace cp4waiops-infra

export ENTITLED_REGISTRY=cp.icr.io
export ENTITLED_REGISTRY_USER=cp
export ENTITLED_REGISTRY_KEY=eyJhbGciOiJIUzI1NiJ9.eyJpcxxxxxxxxxxxxxxxDYEkbYY
oc create secret docker-registry ibm-management-pull-secret --docker-username=$ENTITLED_REGISTRY_USER --docker-password=$ENTITLED_REGISTRY_KEY --docker-server=$ENTITLED_REGISTRY -n cp4waiops-infra

./infrastructureAutomation.sh --mode install --acceptLicense --namespace cp4waiops-infra --pullSecret ibm-management-pull-secret --roks --roksRegion eu-north --roksZone ams03 --rwxStorageClass ibmc-file-gold --rwoStorageClass ibmc-block-gold