echo "Simulating Bookinfo Ratings outage"

echo "${ORANGE}Quit with Ctrl-Z${NC}"


if [[ $NETCOOL_WEBHOOK_GIT == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GIT == "" ]];
then
      echo "Skipping Git events injection"
else
      echo "Git Push"
      input="./bookinfo/events_git.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"

        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GIT" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "----"
      done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      sleep 2
fi




if [[ $NETCOOL_WEBHOOK_METRICS == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_METRICS == "" ]];
then
      echo "Skipping Metrics events injection"
else

      echo "Metrics Push"
      input="./bookinfo/events_metrics.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"

        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_METRICS" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "----"
      done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      sleep 2
fi





if [[ $NETCOOL_WEBHOOK_FALCO == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_FALCO == "" ]];
then
      echo "Skipping Falco events injection"
else
      echo "Falco Push"
      input="./bookinfo/events_falco.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"

        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_FALCO" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "----"
      done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      sleep 2
fi




if [[ $NETCOOL_WEBHOOK_INSTANA == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_INSTANA == "" ]];
then
      echo "Skipping Instana events injection"
else
      echo "Instana Push"
      input="./bookinfo/events_instana.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"

        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_INSTANA" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "----"
      done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      sleep 2
fi




if [[ $NETCOOL_WEBHOOK_HUMIO == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_HUMIO == "" ]];
then
      echo "Skipping Humio events injection"
else
      echo "Injecting Humio Events"
      input="./bookinfo/events_humio.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"

        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "----"
      done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
fi



if [[ demoapps_bookinfo == "not_configured" ]];
then
    echo "Skipping Log Anomaly injection"
else
    echo "Injecting error Logs"
    echo "${ORANGE}Quit with Ctrl-Z${NC}"

    export LOGS_TOPIC=logs-humio-demoapps_bookinfo-$appid_bookinfo

    echo "Injecting into Topic $LOGS_TOPIC"

    mv ca.crt ca.crt.old
    oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

    export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443
      
    #input="./bookinfo/bookinfo-error-inject.json"
    input="./bookinfo/log_errors.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo "Injecting Log line at: $my_timestamp"
      echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/" | kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t $LOGS_TOPIC >/dev/null 2>&1
      kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -t derived-stories -o end -C -e >/dev/null 2>&1 | grep offset
      echo "----"
    done < "$input"

      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""

fi


echo "Bookinfo Ratings outage simulation.... Done...."


