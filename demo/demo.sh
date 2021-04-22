#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ADAPT VALUES in ./01_config.sh
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






















































source ./01_config.sh

menu_option_one () {
  echo "🧨 Simulate failure in BookInfo App (stop Ratings service)"
  ./bookinfo/simulate-incident.sh
}

menu_option_two() {
  echo "🧨 Simulate failure in Kubetoy App (Liveness Probe error )"
  ./kubetoy/simulate-incident.sh
}

menu_option_three() {
  echo "🧨 Simulate failure in RobotShop App (stop MongoDB)"
  echo "	Press Enter to start, press CTRL-C to stop "
  ./robotshop/simulate-incident.sh
}


menu_option_11() {
  echo "✅ Mitigate failure in BookInfo App (start Ratings service)"
  ./bookinfo/remove-incident.sh
}

menu_option_12() {
  echo "✅ Mitigate failure in RobotShop App (start Catalogue service)"
  ./robotshop/remove-incident.sh
}

menu_option_seven() {
  echo "Not implemented"

}


clear
get_sed

banner
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 AI OPS Demo"
echo "***************************************************************************************************************************************************"

echo "  Initializing......"

echo "  Checking K8s connection......"
checkK8sConnection

echo "***************************************************************************************************************************************************"
echo "  NOI Webhook is $NETCOOL_WEBHOOK_HUMIO"
echo "***************************************************************************************************************************************************"

echo "  "
echo "  "


until [ "$selection" = "0" ]; do
  
  echo ""
  
  echo "  🧰 Simulate Service Failures "
  echo "    	1  - [BookInfo] Simulate failure in BookInfo App (inject failure logs)"
  echo "    	2  - [Kubetoy]  Simulate Liveness Probe error in Kubetoy App"
  echo "    	3  - [RobotShop] Simulate failure in RobotShop App (inject failure logs)"
  echo "      "
  echo "  ✅ Mitigate Service Failures "
  echo "    	11  - [BookInfo] Mitigate failure in BookInfo App (start Ratings service)"
  echo "    	12  - [RobotShop] Mitigate failure in RobotShop App (start Catalogue service)"
  echo "" 
  echo ""
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo ""
  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_one ; press_enter ;;
    2 ) clear ; menu_option_two ; press_enter ;;
    3 ) clear ; menu_option_three ; press_enter ;;
    11 ) clear ; menu_option_11 ; press_enter ;;
    12 ) clear ; menu_option_12 ; press_enter ;;
    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done

