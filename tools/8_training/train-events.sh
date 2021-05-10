

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export NETCOOL_WEBHOOK_GENERIC=not_configured



if [[ $NETCOOL_WEBHOOK_GENERIC == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GENERIC == "" ]];
then
      echo "❌ Please specify the Event MAnager Webhook. Aborting..."
      exit 1
fi




source ./99_config-global.sh

export SCRIPT_PATH=$(pwd)
export LOG_PATH=""
__getClusterFQDN
__getInstallPath


banner
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Event Grouping Training"
echo ""
echo "***************************************************************************************************************************************************"


  read -p "Start Training? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      echo "✅ Ok, continuing..."
  else
    echo "❌ Aborted"
    exit 1
  fi

oc project $WAIOPS_NAMESPACE


echo "Creating RobotShop Events for training"

echo "Quit with Ctrl-Z"

if [[ $NETCOOL_WEBHOOK_GENERIC == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GENERIC == "" ]];
then
      echo "❗ Skipping Events injection. Webhook not defined."
else
  while true
  do


      echo "Deleting Events"

      echo "Quit with Ctrl-Z"

password=$(oc get secrets | grep omni-secret | awk '{print $1;}' | xargs oc get secret -o jsonpath --template '{.data.OMNIBUS_ROOT_PASSWORD}' | base64 --decode)
oc get pods | grep ncoprimary-0 | awk '{print $1;}' | xargs -I{} oc exec {} -- bash -c "/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P -user root -passwd ${password} << EOF
delete from alerts.status where AlertGroup='robot-shop';
go
exit
EOF"





      echo "Inject Events"
      input="./tools/8_training/1_events/events_robotshop.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"
line=${line/MY_TIMESTAMP/$my_timestamp}
#$(echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/")
echo $line
        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GENERIC" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "----"
      done < "$input"
  done
      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      sleep 2
fi


