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






menu_option_11 () {
  echo "🧨 Create Bookinfo Topology"
  read -p "❗ Are you really, really, REALLY sure you want to install custom Bookinfo Topology? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
       if [[ $NOI_REST_USR == "not_configured" ]] || [[ $NOI_REST_PWD == "not_configured" ]] ;
      then
          echo "You have not defined the REST integration!"
          echo "Aborting...."
          exit 1
      fi
      ./bookinfo/create-topology.sh
  else
    echo "Aborted"
  fi

}


menu_option_12 () {
  echo "🧨 Create Robotshop Topology"
  read -p "❗ Are you really, really, REALLY sure you want to install custom Robotshop Topology? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
       if [[ $NOI_REST_USR == "not_configured" ]] || [[ $NOI_REST_PWD == "not_configured" ]] ;
      then
          echo "You have not defined the REST integration!"
          echo "Aborting...."
          exit 1
      fi
      ./robotshop/create-topology.sh
  else
    echo "Aborted"
  fi

}


menu_option_13 () {
  echo "🧨 Create Kubetoy Topology"
  read -p "❗ Are you really, really, REALLY sure you want to install custom Kubetoy Topology? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      if [[ $NOI_REST_USR == "not_configured" ]] || [[ $NOI_REST_PWD == "not_configured" ]] ;
      then
          echo "You have not defined the REST integration!"
          echo "Aborting...."
          exit 1
      fi
      ./kubetoy/create-topology.sh
  else
    echo "Aborted"
  fi

}





clear
get_sed

banner
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 AI OPS Load Topologies"
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
  echo "" 
  echo "  🧰 Create Topologies "
  echo "      1  -  Create Bookinfo Topology"
  echo "      2  -  Create Robotshop Topology"
  echo "      3  -  Create Kubetoy Topology"
  echo "" 
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo ""

  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in

    1 ) clear ; menu_option_11 ; press_enter ;;
    2 ) clear ; menu_option_12 ; press_enter ;;
    3 ) clear ; menu_option_13 ; press_enter ;;

    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection ; press_enter ;;
  esac
done







