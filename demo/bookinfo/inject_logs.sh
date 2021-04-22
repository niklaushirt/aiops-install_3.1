echo "Simulating RobotShop MongoDB outage"

echo "${ORANGE}Quit with Ctrl-Z${NC}"


export application_name=bookinfo
export appgroupid=rdx0jrtg
export appid=9r87turo

    echo "Injecting error Logs"
    echo "${ORANGE}Quit with Ctrl-Z${NC}"

    export LOGS_TOPIC=logs-humio-$appgroupid-$appid


    mv ca.crt ca.crt.old
    oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

    export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      

    export my_timestamp=$(date +%s)
    echo "Injecting Log line at: $my_timestamp"
echo "2---------------------------------------------------------------"

    #input="./robotshop/bookinfo-error-inject.json"
    input="./bookinfo-error1.json"
    echo "" > /tmp/logs-inject.json
    while IFS= read -r line
    do

        my_timestamp=$(($my_timestamp + 1))
    echo "Injecting Log line at: $my_timestamp"
        echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp000/" >> /tmp/logs-inject.json
        #sleep 1
        #kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t derived-stories -o end -C -e >/dev/null 2>&1 | grep offset
        #echo "."
    done < "$input"



while true
do
    kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t $LOGS_TOPIC -l ./bookinfo-error1.json
done

echo "Done"
echo ""
echo ""
echo ""
echo ""
echo ""




echo "Bookinfo Ratings outage simulation.... Done...."

exit 1
