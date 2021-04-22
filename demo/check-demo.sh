
source ./01_config.sh

clear
get_sed

banner
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 AI OPS Demo - Check Prerequisites"
echo "***************************************************************************************************************************************************"


echo "  Initializing......"

echo "  Checking Config File......"

 if [[ demoapps_bookinfo =~ "not_configured" ]];
  then
      echo "      ❗ ERROR: Please copy the 01_config.sh file that you have received by mail into this ./demo folder"
      echo "           ❌ Aborting."
      exit 1
  else 
      echo "      ✅ OK"
  fi








echo "  Checking NOI WebHooks......"


  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" -H 'Content-Type: application/json; charset=utf-8' -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') 


 if [[ $checkConnection =~ "Cannot read property" ]];
  then
      echo "      ✅ Humio OK"
  else 
      echo "      ❗ ERROR: Humio is not accessible"
      echo "           ❌ Aborting."
      exit 1
  fi


  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GIT" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') >/dev/null 2>&1


 if [[ $checkConnection =~ "deduplicationKey" ]];
  then
      echo "      ✅ Git Webhook OK"
  else 
      echo "      ❗ WARNING: Git Webhook is not accessible"
  fi

  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_METRICS" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') >/dev/null 2>&1


 if [[ $checkConnection =~ "deduplicationKey" ]];
  then
      echo "      ✅ Metrics Webhook OK"
  else 
      echo "      ❗ WARNING: Metrics Webhook is not accessible"
  fi



  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_FALCO" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') >/dev/null 2>&1

 if [[ $checkConnection =~ "deduplicationKey" ]];
  then
      echo "      ✅ Falco Webhook OK"
  else 
      echo "      ❗ WARNING: Falco Webhook is not accessible"
  fi


  checkConnection=$(curl --insecure -X "POST" "$NETCOOL_WEBHOOK_INSTANA" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896') >/dev/null 2>&1

 if [[ $checkConnection =~ "deduplicationKey" ]];
  then
      echo "      ✅ Instana Webhook OK"
  else 
      echo "      ❗ WARNING: Instana Webhook is not accessible"
  fi




echo ""
echo "  Checking K8s connection......"
checkK8sConnection

echo ""
echo "      ✅   Checking Bookinfo......"
oc scale --replicas=1  deployment ratings-v1 -n bookinfo

echo ""
echo "      ✅   Checking RobotShop......"
robot_cat_running=$(oc get deployment catalogue -n robot-shop)
if [[ $robot_cat_running =~ "0/0" ]];
then
    oc scale --replicas=1  deployment catalogue -n robot-shop #>/dev/null 2>&1
    oc delete pod -n robot-shop $(oc get po -n robot-shop|grep catalogue|awk '{print$1}') --force --grace-period=0 #>/dev/null 2>&1
    oc delete pod -n robot-shop $(oc get po -n robot-shop|grep user|awk '{print$1}') --force --grace-period=0 #>/dev/null 2>&1
    oc delete pod -n robot-shop $(oc get po -n robot-shop|grep shipping|awk '{print$1}') --force --grace-period=0 #>/dev/null 2>&1
fi


# echo "  Restarting Bookinfo......"
#oc delete pods -n bookinfo --all



echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🆗 DONE - You're good to go!!!!!"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
