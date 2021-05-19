
source ./01_config.sh

banner 

echo "."

./robotshop/simulate-log-silent.sh &



password=$(oc get secrets | grep omni-secret | awk '{print $1;}' | xargs oc get secret -o jsonpath --template '{.data.OMNIBUS_ROOT_PASSWORD}' | base64 --decode)
oc get pods | grep ncoprimary-0 | awk '{print $1;}' | xargs -I{} oc exec {} -- bash -c "/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P -user root -passwd ${password} << EOF
delete from alerts.status where AlertGroup='robot-shop';
go
exit
EOF">/dev/null 2>&1

echo "...."

    input="./robotshop/events_robotshop.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
echo "....."

    line=${line/MY_TIMESTAMP/$my_timestamp}
    #$(echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/")
    #echo $line
      curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GENERIC" \
        -H 'Content-Type: application/json; charset=utf-8' \
        -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
        -d $"${line}">/dev/null 2>&1
        sleep 2
    done < "$input"



echo "......."





echo "RobotShop Ratings outage simulation.... Done...."


