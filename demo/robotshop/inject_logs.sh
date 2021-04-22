echo "Simulating RobotShop MongoDB outage"

echo "${ORANGE}Quit with Ctrl-Z${NC}"
source ./01_config.sh

export application_name=robotshop
export appgroupid=m3ejmihc
export appid=qbxggpep

    echo "Injecting error Logs"
    echo "${ORANGE}Quit with Ctrl-Z${NC}"

    export LOGS_TOPIC=logs-humio-$appgroupid-$appid


    mv ca.crt ca.crt.old
    oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

    export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      
while true
do
    kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t $LOGS_TOPIC -l ./log_errors.json
done

echo "Done"
echo ""
echo ""
echo ""
echo ""
echo ""




echo "Bookinfo Ratings outage simulation.... Done...."

exit 1
