
source ./01_config.sh

echo "...."

   echo "" > /tmp/robotshopErrorLogs.json
    input="./robotshop/robErrorTemplate.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo ${line} | gsed "s/@TIMESTAMP@/$my_timestamp/"  >> /tmp/robotshopErrorLogs.json
    done < "$input"


    export LOGS_TOPIC=$(oc get KafkaTopic -n $WAIOPS_NAMESPACE | grep logs-humio| awk '{print $1;}')
    export sasl_password=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443


    export LOGS_TOPIC=$(oc get KafkaTopic -n $WAIOPS_NAMESPACE | grep logs-humio| awk '{print $1;}')
    export sasl_password=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

echo "....."    #mv ca.crt ca.crt.old
    oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt --confirm>/dev/null 2>&1
      
    
    kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t $LOGS_TOPIC -l /tmp/robotshopErrorLogs.json>/dev/null 2>&1


