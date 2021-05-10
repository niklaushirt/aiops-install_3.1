

oc project aiops

export LOGS_TOPIC=$(oc get KafkaTopic -n aiops | grep logs-humio| awk '{print $1;}')
export sasl_password=$(oc get secret token -n aiops --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n aiops -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443




    echo "Injecting error Logs"
    echo "${ORANGE}Quit with Ctrl-Z${NC}"


    echo "Injecting into Topic $LOGS_TOPIC"

    #mv ca.crt ca.crt.old
    oc extract secret/strimzi-cluster-cluster-ca-cert -n aiops --keys=ca.crt

    export sasl_password=$(oc get secret token -n aiops --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n aiops -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      
    #input="./robotshop/bookinfo-error-inject.json"
    input="./robotshop/robotRestart.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo "Injecting Log line at: $my_timestamp"
      echo ${line} | gsed "s/@TIMESTAMP@/$my_timestamp/" | kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t $LOGS_TOPIC >/dev/null 2>&1
      #kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t derived-stories -o end -C -e >/dev/null 2>&1 | grep offset
      echo "----"
    done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""



echo "Done"
echo ""
echo ""
echo ""
echo ""
echo ""

