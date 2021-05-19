

source ./01_config.sh

banner 

echo "Pushing QOTD to GitHub"



if [[ $NETCOOL_WEBHOOK_GENERIC == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GENERIC == "" ]];
then
      echo "❗ Configure WebHook. Aborting...."
      exit 1
else

    oc project $WAIOPS_NAMESPACE >/dev/null 2>&1

echo "."

password=$(oc get secrets | grep omni-secret | awk '{print $1;}' | xargs oc get secret -o jsonpath --template '{.data.OMNIBUS_ROOT_PASSWORD}' | base64 --decode)
oc get pods | grep ncoprimary-0 | awk '{print $1;}' | xargs -I{} oc exec {} -- bash -c "/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P -user root -passwd ${password} << EOF
delete from alerts.status where AlertGroup='qotd';
go
exit
EOF" >/dev/null 2>&1

echo ".."

    input="./qotd/events_qotd.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo ".."
    line=${line/MY_TIMESTAMP/$my_timestamp}
    #$(echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/")
    #echo $line
      curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GENERIC" \
        -H 'Content-Type: application/json; charset=utf-8' \
        -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
        -d $"${line}">/dev/null 2>&1
    done < "$input"



echo "..."

   echo "" > /tmp/qotdErrorLogs.json
    input="./qotd/qotdTemplate.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo ${line} | gsed "s/@TIMESTAMP@/$my_timestamp/"  >> /tmp/qotdErrorLogs.json
    done < "$input"


    export LOGS_TOPIC=$(oc get KafkaTopic -n aiops | grep logs-humio| awk '{print $1;}')
    export sasl_password=$(oc get secret token -n aiops --template={{.data.password}} | base64 --decode)
    export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n aiops -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

echo "...."

    #mv ca.crt ca.crt.old
    oc extract secret/strimzi-cluster-cluster-ca-cert -n aiops --keys=ca.crt>/dev/null 2>&1
      
    
    kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -P -t $LOGS_TOPIC -l /tmp/qotdErrorLogs.json>/dev/null 2>&1

fi




echo "Git Push.... Done...."


