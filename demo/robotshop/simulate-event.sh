
source ./01_config.sh

banner 

echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Simulate Events for Robotshop"
echo ""
echo "***************************************************************************************************************************************************"



if [[ $NETCOOL_WEBHOOK_GENERIC == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GENERIC == "" ]];
then
      echo "Skipping Events injection"
else

    oc project $WAIOPS_NAMESPACE >/dev/null 2>&1

    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo "Delete NOI Events"
    echo "--------------------------------------------------------------------------------------------------------------------------------"

password=$(oc get secrets | grep omni-secret | awk '{print $1;}' | xargs oc get secret -o jsonpath --template '{.data.OMNIBUS_ROOT_PASSWORD}' | base64 --decode)
oc get pods | grep ncoprimary-0 | awk '{print $1;}' | xargs -I{} oc exec {} -- bash -c "/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P -user root -passwd ${password} << EOF
delete from alerts.status where AlertGroup='robot-shop';
go
exit
EOF"

    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo "Inject Events"
    echo "--------------------------------------------------------------------------------------------------------------------------------"

    input="./robotshop/events_robotshop.json"
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000
      echo "Injecting Event at: $my_timestamp"
    line=${line/MY_TIMESTAMP/$my_timestamp}
    #$(echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/")
    #echo $line
      curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GENERIC" \
        -H 'Content-Type: application/json; charset=utf-8' \
        -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
        -d $"${line}">/dev/null 2>&1
      echo "----"
      sleep 2
    done < "$input"






    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo "Done"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
fi





echo "Simulation.... Done...."


