
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

source ./tools/0_global/99_config-global.sh
__getInstallPath



menu_check_install () {

    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo " 🚀  Examining unsuccessful CP4WAIOPS Installation for hints...." 
    echo "--------------------------------------------------------------------------------------------------------------------------------"

      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Stuck Pods in Namespace openshift-operators"
      echo "--------------------------------------------------------------------------------------------"

      oc get pods -n openshift-operators | grep -v "Completed" | grep "0/"

      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Stuck Pods in Namespace ibm-common-services"
      echo "--------------------------------------------------------------------------------------------"

      oc get pods -n ibm-common-services | grep -v "Completed" | grep "0/"


      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Stuck Pods in Namespace $WAIOPS_NAMESPACE"
      echo "--------------------------------------------------------------------------------------------"

      oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/"





      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check IAF Operators"
      echo "--------------------------------------------------------------------------------------------"

      CP4AIOPS_CHECK_LIST=(
      "iaf-core-operator-controller-manager"
      "iaf-eventprocessing-operator-controller-manager"
      "iaf-flink-operator-controller-manager"
      "iaf-operator-controller-manager")

      for ELEMENT in ${CP4AIOPS_CHECK_LIST[@]}; do
       echo "   Check $ELEMENT.."
            ELEMENT_OK=$(oc get pod -n openshift-operators --ignore-not-found | grep $ELEMENT || true) 
            if  ([[ ! $ELEMENT_OK =~ "1/1" ]]); 
            then 
                  echo "      ⭕ Pod $ELEMENT not runing successfully"; 
                  echo "      ⭕ (You may want to run option: 21  - Patch IAF)"; 
                  echo ""
            else
                  echo "      ✅ OK: Pod $ELEMENT"; 

            fi

      done

      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Topology"
      echo "--------------------------------------------------------------------------------------------"

      CP4AIOPS_CHECK_LIST=(
      "evtmanager-topology-merge"
      "evtmanager-topology-status"
      "evtmanager-topology-topology")

      for ELEMENT in ${CP4AIOPS_CHECK_LIST[@]}; do
        echo "   Check $ELEMENT.."
            ELEMENT_OK=$(oc get pod -n $WAIOPS_NAMESPACE --ignore-not-found | grep $ELEMENT || true) 
            if  ([[ ! $ELEMENT_OK =~ "1/1" ]]); 
            then 
                  echo "      ⭕ Pod $ELEMENT not runing successfully"; 
                  echo "      ⭕ (You may want to run option: 22  - Patch evtmanager topology pods)";  
                  echo ""
            else
                  echo "      ✅ OK: Pod $ELEMENT"; 

            fi

      done



      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Flink Secret"
      echo "--------------------------------------------------------------------------------------------"

      CP4AIOPS_CHECK_LIST=(
      "aimanager-flink-config-secret"
    )

      for ELEMENT in ${CP4AIOPS_CHECK_LIST[@]}; do
        echo "   Check $ELEMENT.."
            ELEMENT_OK=$(oc get secret $ELEMENT -n $WAIOPS_NAMESPACE --ignore-not-found -oyaml  || true) 
            if  ([[ ! $ELEMENT_OK =~ "kind: Secret" ]]); 
            then 
                  echo "      ⭕ Secret $ELEMENT does not exist"; 
                  echo "      ⭕ (You may want to run option: 24  - Patch evtmanager topology pods)";  
                  echo ""
            else
                  echo "      ✅ OK: Secret $ELEMENT"; 
            fi

      done




      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Job aimanager-aio-create-secrets"
      echo "--------------------------------------------------------------------------------------------"

      CP4AIOPS_CHECK_LIST=(
      "aimanager-aio-create-secrets"
    )

      for ELEMENT in ${CP4AIOPS_CHECK_LIST[@]}; do
        echo "   Check $ELEMENT.."
            ELEMENT_READY=$(oc get job $ELEMENT -n $WAIOPS_NAMESPACE --ignore-not-found  || true) 
            ELEMENT_OK=$(oc get job $ELEMENT -n $WAIOPS_NAMESPACE --ignore-not-found -oyaml || true) 

            if  ([[ ! $ELEMENT_READY =~ "1/1" ]]); 
            then 
                  echo "      ⭕ Job aimanager-aio-create-secrets has not run correctly";  
                  echo ""

                  if  ([[ ! $ELEMENT_OK =~ "type: Complete" ]]); 
                  then 
                        ELEMENT_REASON=$(oc get job $ELEMENT -n $WAIOPS_NAMESPACE --ignore-not-found -ojson | jq ".status.conditions" || true) 
                        echo "      ⭕ Status:"; 
                        echo "$ELEMENT_REASON"; 

                  fi



                  echo "      ⭕ (You may want to run option: 24  - Patch evtmanager topology pods)";  
                  echo ""
            else
                  echo "      ✅ OK: Secret $ELEMENT"; 
            fi

      done


      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Jobs"
      echo "--------------------------------------------------------------------------------------------"

      CP4AIOPS_CHECK_LIST=(
      "aimanager-ibm-flink-create-flink-config-secret"
      "aimanager-postgres-create-cluster"
      "aimanager-aio-create-truststore"
      "aimanager-aio-create-secrets")

      for ELEMENT in ${CP4AIOPS_CHECK_LIST[@]}; do
        echo "   Check $ELEMENT.."
            ELEMENT_OK=$(oc get job -n $WAIOPS_NAMESPACE --ignore-not-found | grep $ELEMENT || true) 
            if  ([[ ! $ELEMENT_OK =~ "1/1" ]]); 
            then 
                  echo "      ⭕ Job $ELEMENT not run successfully"; 
                  echo "      ⭕ (You may want to run option: 24  - Patch evtmanager topology pods)";  
                  echo ""
            else
                  echo "      ✅ OK: Job $ELEMENT"; 

            fi

      done


      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Secrets"
      echo "--------------------------------------------------------------------------------------------"

      CP4AIOPS_CHECK_LIST=(
      "aimanager-ibm-elasticsearch-secret"
      "aimanager-ibm-elasticsearch-secret-min"
      "aimanager-modeltrain-cert-secret"
      "aimanager-postgres-auth-secret-full"
      "aimanager-aio-truststores"
      "kafka-truststore"
      "aimanager-postgres-auth-secret"
      "aimanager-postgres-tls-secret")

      for ELEMENT in ${CP4AIOPS_CHECK_LIST[@]}; do
        echo "   Check $ELEMENT.."
            ELEMENT_OK=$(oc get secret $ELEMENT -n $WAIOPS_NAMESPACE --ignore-not-found -oyaml  || true) 
            if  ([[ ! $ELEMENT_OK =~ "kind: Secret" ]]); 
            then 
                  echo "      ⭕ Secret $ELEMENT does not exist"; 
                  echo "      ⭕ (You may want to run option: 24  - Patch evtmanager topology pods)";  
                  echo ""
            else
                  echo "      ✅ OK: Secret $ELEMENT"; 

            fi

      done





      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Patches"
      echo "--------------------------------------------------------------------------------------------"

      INGRESS_OK=$(oc get namespace default -oyaml | grep ingress || true) 
      if  ([[ ! $INGRESS_OK =~ "ingress" ]]); 
      then 
            echo "      ⭕ Ingress Not Patched"; 
            echo "      ⭕ (You may want to run option: 23  - Patch/enable ZEN route traffic)";  
            echo ""
      else
            echo "      ✅ OK: Ingress Patched"; 

      fi


      PATCH_OK=$(oc get deployment evtmanager-ibm-hdm-analytics-dev-inferenceservice -n $WAIOPS_NAMESPACE -oyaml | grep "failureThreshold: 30" || true) 
      if  ([[ ! $PATCH_OK =~ "failureThreshold: 30" ]]); 
      then 
            echo "      ⭕ evtmanager-ibm-hdm-analytics-dev-inferenceservice Not Patched"; 
            echo "      ⭕ (You may want to run option: 22  - Patch evtmanager topology pods)";  
            echo ""
      else
            echo "      ✅ OK: evtmanager-ibm-hdm-analytics-dev-inferenceservice Patched"; 
      fi

      PATCH_OK=$(oc get deployment evtmanager-topology-merge -n $WAIOPS_NAMESPACE -oyaml | grep "failureThreshold: 61" || true) 
      if  ([[ ! $PATCH_OK =~ "failureThreshold: 61" ]]); 
      then 
            echo "      ⭕ evtmanager-topology-merge Not Patched"; 
            echo "      ⭕ (You may want to run option: 22  - Patch evtmanager topology pods)";  
            echo ""
      else
            echo "      ✅ OK: evtmanager-topology-merge Patched"; 
      fi




      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Routes"
      echo "--------------------------------------------------------------------------------------------"

      ROUTE_OK=$(oc get route topology-merge -n $WAIOPS_NAMESPACE || true) 
      if  ([[ ! $ROUTE_OK =~ "topology-merge" ]]); 
      then 
            echo "      ⭕ topology-merge Route does not exist"; 
            echo "      ⭕ (You may want to run option: 13  - Recreate custom Routes)";  
            echo ""
      else
            echo "      ✅ OK: topology-merge Route exists"; 
      fi

      ROUTE_OK=$(oc get route topology-rest -n $WAIOPS_NAMESPACE || true) 
      if  ([[ ! $ROUTE_OK =~ "topology-rest" ]]); 
      then 
            echo "      ⭕ topology-rest Route does not exist"; 
            echo "      ⭕ (You may want to run option: 13  - Recreate custom Routes)";  
            echo ""
      else
            echo "      ✅ OK: topology-rest Route exists"; 
      fi

      ROUTE_OK=$(oc get route topology-manage -n $WAIOPS_NAMESPACE || true) 
      if  ([[ ! $ROUTE_OK =~ "topology-manage" ]]); 
      then 
            echo "      ⭕ topology-manage Route does not exist"; 
            echo "      ⭕ (You may want to run option: 13  - Recreate custom Routes)";  
            echo ""
      else
            echo "      ✅ OK: topology-manage Route exists"; 
      fi

      ROUTE_OK=$(oc get route job-manager -n $WAIOPS_NAMESPACE || true) 
      if  ([[ ! $ROUTE_OK =~ "job-manager" ]]); 
      then 
            echo "      ⭕ job-manager Route does not exist"; 
            echo "      ⭕ (You may want to run option: 13  - Recreate custom Routes)";  
            echo ""
      else
            echo "      ✅ OK: job-manager Route exists"; 
      fi

      ROUTE_OK=$(oc get route strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE || true) 
      if  ([[ ! $ROUTE_OK =~ "strimzi-cluster-kafka-bootstrap" ]]); 
      then 
            echo "      ⭕ strimzi-cluster-kafka-bootstrap Route does not exist"; 
            echo "      ⭕ (You may want to run option: 13  - Recreate custom Routes)";  
            echo ""
      else
            echo "      ✅ OK: strimzi-cluster-kafka-bootstrap Route exists"; 
      fi







      echo ""
      echo ""
      echo "--------------------------------------------------------------------------------------------"
      echo "🔎 Check Kafka Instance"
      echo "--------------------------------------------------------------------------------------------"



      echo "    🔬 Check for Kafka Broker" 

      export KAFKA_PASSWORD=$(oc get secret token -n $WAIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
      export KAFKA_BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n $WAIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

      if [[ ! $KAFKA_BROKER =~ "strimzi-cluster-kafka-bootstrap-$WAIOPS_NAMESPACE" ]] ;
      then
            echo "      ❗ Strimzi Kafka Broker not found..."
            echo "      ❗    Make sure that the 11_postinstall_aiops.sh script has run to completion."
            echo "      ❗    This should create the Strimzi Route automatically."
      else
            echo "       ✅ OK - Kafka Broker"
      fi

      echo "    🔬 Check for Kafka Password"

      if [[ $KAFKA_PASSWORD == "" ]] ;
      then
            echo "      ❗ Strimzi Kafka Password not found..."
            echo "      ❗    Make sure that the 11_postinstall_aiops.sh script has run to completion."
      else
            echo "       ✅ OK - Kafka Password"
      fi





    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo " 🚀  Check official list from uninstaller...." 
    echo "--------------------------------------------------------------------------------------------------------------------------------"

      CHECK_NAME=CP4AIOPS_CONFIGMAPS
      CHECK_ARRAY=("${CP4AIOPS_CONFIGMAPS[@]}")    
      check_array

      CHECK_NAME=CP4AIOPS_PVCS
      CHECK_ARRAY=("${CP4AIOPS_PVCS[@]}")    
      check_array


      CHECK_NAME=CP4AIOPS_PVC_SECRETS
      CHECK_ARRAY=("${CP4AIOPS_PVC_SECRETS[@]}")    
      check_array

      CHECK_NAME=CP4AIOPS_SECRETS
      CHECK_ARRAY=("${CP4AIOPS_SECRETS[@]}")    
      check_array

      CHECK_NAME=CP4AIOPS_KAFKATOPICS
      CHECK_ARRAY=("${CP4AIOPS_KAFKATOPICS[@]}")    
      check_array

      CHECK_NAME=CP4AIOPS_LEASE
      CHECK_ARRAY=("${CP4AIOPS_LEASE[@]}")    
      check_array

      # CHECK_NAME=CP4WAIOPS_CRDS
      # CHECK_ARRAY=("${CP4WAIOPS_CRDS[@]}")    
      # check_array

      # CHECK_NAME=CAMELK_CRDS
      # CHECK_ARRAY=("${CAMELK_CRDS[@]}")    
      # check_array

      # CHECK_NAME=KONG_CRDS
      # CHECK_ARRAY=("${KONG_CRDS[@]}")    
      # check_array

      CHECK_NAME=IAF_CERTMANAGER
      CHECK_ARRAY=("${IAF_CERTMANAGER[@]}")    
      check_array

      CHECK_NAME=IAF_SECRETS
      CHECK_ARRAY=("${IAF_SECRETS[@]}")    
      check_array

      CHECK_NAME=IAF_CONFIGMAPS
      CHECK_ARRAY=("${IAF_CONFIGMAPS[@]}")    
      check_array

      CHECK_NAME=IAF_PVCS
      CHECK_ARRAY=("${IAF_PVCS[@]}")    
      check_array

      CHECK_NAME=IAF_MISC
      CHECK_ARRAY=("${IAF_MISC[@]}")    
      check_array

      # CHECK_NAME=IAF_CRDS
      # CHECK_ARRAY=("${IAF_CRDS[@]}")    
      # check_array

      # CHECK_NAME=BEDROCK_CRDS
      # CHECK_ARRAY=("${BEDROCK_CRDS[@]}")    
      # check_array





}



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Patch IAF Resources for ROKS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
menu_patch_iaf () {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Patching IAF Subscriptions" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo "   Details are here: https://www.ibm.com/docs/en/cloud-paks/1.0?topic=issues-operator-pods-crashing-during-installation"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""
            echo ""
            echo ""
            echo "Patch IAF Resources for ROKS"


            echo  "Patching IBM Automation Foundation Subscriiption for ibm-automation-v1.2-ibm-operator-catalog-openshift-marketplace" 
            IAF_OP_EXISTS=$(oc get subscriptions.operators.coreos.com -n openshift-operators ibm-automation-v1.2-ibm-operator-catalog-openshift-marketplace || true) 
            while  ([[ ! $IAF_OP_EXISTS =~ "v1.2" ]]); do 
                  IAF_OP_EXISTS=$(oc get subscriptions.operators.coreos.com -n openshift-operators ibm-automation-v1.2-ibm-operator-catalog-openshift-marketplace || true)  
                  echo "      ⭕ IAF Core Subscription not present. Waiting for 10 seconds...." && sleep 10; 
            done

            echo "Backup IBM Automation ClusterServiceVersion for ibm-automation-v1.2-ibm-operator-catalog-openshift-marketplace"
                  oc get subscriptions.operators.coreos.com ibm-automation-v1.2-ibm-operator-catalog-openshift-marketplace -n openshift-operators -oyaml > ibm-automation-v1.2-ibm-operator-catalog-openshift-marketplace-backup.yaml
                  echo "      ✅ OK"
            echo ""

            echo "Patch IAF Core Subscription"
                  oc patch subscriptions.operators.coreos.com ibm-automation-v1.2-ibm-operator-catalog-openshift-marketplace -n openshift-operators --patch "$(cat ./yaml/waiops/patches/ibm-automation-sub-patch.yaml)"  --type=merge || true >$log_output_path 2>&1
                  echo "      ✅ OK"
            echo ""




            echo  "Patching IBM Automation Foundation Subscriiption for ibm-automation-core-v1.2-ibm-operator-catalog-openshift-marketplace" 
            IAF_CORE_EXISTS=$(oc get subscriptions.operators.coreos.com -n openshift-operators ibm-automation-core-v1.2-ibm-operator-catalog-openshift-marketplace || true) 
            while  ([[ ! $IAF_CORE_EXISTS =~ "v1.2" ]]); do 
                  IAF_CORE_EXISTS=$(oc get subscriptions.operators.coreos.com -n openshift-operators ibm-automation-core-v1.2-ibm-operator-catalog-openshift-marketplace || true)  
                  echo "      ⭕ IAF Core Subscription not present. Waiting for 10 seconds...." && sleep 10; 
            done

            echo "Backup IBM Automation ClusterServiceVersion for ibm-automation-core-v1.2-ibm-operator-catalog-openshift-marketplace"
                  oc get subscriptions.operators.coreos.com ibm-automation-core-v1.2-ibm-operator-catalog-openshift-marketplace -n openshift-operators -oyaml > ibm-automation-core-v1.2-ibm-operator-catalog-openshift-marketplace-backup.yaml
                  echo "      ✅ OK"
            echo ""

            echo "Patch IAF Core Subscription"
                  oc patch subscriptions.operators.coreos.com ibm-automation-core-v1.2-ibm-operator-catalog-openshift-marketplace -n openshift-operators --patch "$(cat ./yaml/waiops/patches/ibm-automation-core-sub-patch.yaml)"  --type=merge || true >$log_output_path 2>&1
                  echo "      ✅ OK"
            echo ""




            echo  "Patching IBM Automation Foundation Subscriiption for ibm-automation-eventprocessing-v1.2-ibm-operator-catalog-openshift-marketplace" 
            IAF_EVENT_EXISTS=$(oc get subscriptions.operators.coreos.com -n openshift-operators ibm-automation-eventprocessing-v1.2-ibm-operator-catalog-openshift-marketplace || true) 
            while  ([[ ! $IAF_EVENT_EXISTS =~ "v1.2" ]]); do 
                  IAF_EVENT_EXISTS=$(oc get subscriptions.operators.coreos.com -n openshift-operators ibm-automation-eventprocessing-v1.2-ibm-operator-catalog-openshift-marketplace || true) 
                  echo "      ⭕ IAF Core Subscription not present. Waiting for 10 seconds...." && sleep 10; 
            done

            echo "Backup IBM Automation ClusterServiceVersion for ibm-automation-eventprocessing-v1.2-ibm-operator-catalog-openshift-marketplace"
                  oc get subscriptions.operators.coreos.com ibm-automation-eventprocessing-v1.2-ibm-operator-catalog-openshift-marketplace -n openshift-operators -oyaml > ibm-automation-eventprocessing-v1.2-ibm-operator-catalog-openshift-marketplace-backup.yaml
                  echo "      ✅ OK"
            echo ""



            echo "Patch IAF Event Subscription"
                  oc patch subscriptions.operators.coreos.com ibm-automation-eventprocessing-v1.2-ibm-operator-catalog-openshift-marketplace -n openshift-operators --patch "$(cat ./yaml/waiops/patches/ibm-automation-eventprocessing-sub-patch.yaml)"  --type=merge
                  echo "      ✅ OK"
            echo ""




        else
          echo "    ⚠️  Skipping"
          echo "--------------------------------------------------------------------------------------------------------------------------------"
          echo  ""    
          echo  ""
        fi

}



menu_patch_iaf_ai_operator () {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Patching IBM Automation ClusterServiceVersion for iaf-operator-controller-manager" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""
            echo ""
            echo ""

            IBM_AUTO_EXISTS=$(oc get ClusterServiceVersion -n openshift-operators ibm-automation.v1.2.0 || true) 
            while  ([[ ! $IBM_AUTO_EXISTS =~ "IBM Automation Foundation" ]]); do 
                  IBM_AUTO_EXISTS=$(oc get ClusterServiceVersion -n openshift-operators ibm-automation.v1.2.0 || true)  
                  echo "      ⭕ IBM Automation ClusterServiceVersion for iaf-operator-controller-manager not present. Waiting for 10 seconds...." && sleep 10; 
            done

            echo "Backup IBM Automation ClusterServiceVersion for iaf-eventprocessing-operator-controller-manager"
                  oc get ClusterServiceVersion ibm-automation.v1.2.0 -n openshift-operators -oyaml > ibm-automation.v1.2.0-backup.yaml
                  echo "      ✅ OK"
            echo ""


            echo "Patch IBM Automation ClusterServiceVersion for iaf-operator-controller-manager"
                  oc patch ClusterServiceVersion ibm-automation.v1.2.0 -n openshift-operators --patch "$(cat ./yaml/waiops/patches/iaf-operator-controller-manager-patch.yaml)"  --type=merge
                  echo "      ✅ OK"
            echo ""

            echo "Delete iaf-operator-controller-manager Deployment (will be recreated by Operator)"
                  #oc delete deployment -n openshift-operators iaf-operator-controller-manager
                  echo "      ✅ OK"
            echo ""


            echo "Patch Resources for ROKS"
        else
          echo "    ⚠️  Skipping"
          echo "--------------------------------------------------------------------------------------------------------------------------------"
          echo  ""    
          echo  ""
        fi

}


menu_patch_iaf_eventprocessing () {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Patching IBM Automation ClusterServiceVersion for iaf-eventprocessing-operator-controller-manager" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""
            echo ""
            echo ""

            IBM_AUTO_EXISTS=$(oc get ClusterServiceVersion -n openshift-operators ibm-automation-eventprocessing.v1.2.0 || true) 
            while  ([[ ! $IBM_AUTO_EXISTS =~ "IBM Automation Foundation" ]]); do 
                  IBM_AUTO_EXISTS=$(oc get ClusterServiceVersion -n openshift-operators iibm-automation-eventprocessing.v1.2.0 || true)  
                  echo "      ⭕ IBM Automation ClusterServiceVersion for iaf-eventprocessing-operator-controller-manager not present. Waiting for 10 seconds...." && sleep 10; 
            done

            echo "Backup IBM Automation ClusterServiceVersion for iaf-eventprocessing-operator-controller-manager"
                  oc get ClusterServiceVersion ibm-automation-eventprocessing.v1.2.0 -n openshift-operators -oyaml > ibm-automation-eventprocessing.v1.2.0-backup.yaml
                  echo "      ✅ OK"
            echo ""



            echo "Patch IBM Automation ClusterServiceVersion for iaf-eventprocessing-operator-controller-manager"
                  oc patch ClusterServiceVersion ibm-automation-eventprocessing.v1.2.0 -n openshift-operators --patch "$(cat ./yaml/waiops/patches/iaf-eventprocessing-operator-controller-manager-patch.yaml)"  --type=merge
                  echo "      ✅ OK"
            echo ""

            echo "Delete iaf-eventprocessing-operator-controller-manager Deployment (will be recreated by Operator)"
                  #oc delete deployment -n openshift-operators iaf-eventprocessing-operator-controller-manager
                  echo "      ✅ OK"
            echo ""


            echo "Patch Resources for ROKS"
        else
          echo "    ⚠️  Skipping"
          echo "--------------------------------------------------------------------------------------------------------------------------------"
          echo  ""    
          echo  ""
        fi

}







# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Restart the CP4WAIOPS Namespace
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
menu_restart_namespace() {
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo " 🚀  Restarting Namespace $WAIOPS_NAMESPACE" 
    echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
      read -p " ❗❓ Continue? [y,N] " DO_COMM
      if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
          echo "   ✅ Ok, continuing..."
          echo ""
          echo ""
          echo ""
          echo ""

          echo " 🧻  Restarting Namespace $WAIOPS_NAMESPACE" 
          oc delete pods -n $WAIOPS_NAMESPACE --all
          echo "      ✅ OK"
          
          echo ""
          echo ""
          echo ""
          echo  "   🔬 Waiting for all pods in $WAIOPS_NAMESPACE to restart."

          WAIOPS_PODS_COUNT_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" | wc -l || true)
          WAIOPS_PODS_COUNT_TOTAL=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | wc -l || true) 

          while  ([[ ! $(($WAIOPS_PODS_COUNT_NOTREADY)) == 0 ]] || [[  $(($WAIOPS_PODS_COUNT_TOTAL)) < $WAIOPS_PODS_COUNT_EXPECTED ]] ); do 
                WAIOPS_PODS_COUNT_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" | wc -l || true) 
                WAIOPS_PODS_COUNT_TOTAL=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | wc -l || true) 
                
                echo  "      ⭕ CP4WAIOPS: $(($WAIOPS_PODS_COUNT_NOTREADY)) Pods not ready ($(($WAIOPS_PODS_COUNT_TOTAL - $WAIOPS_PODS_COUNT_NOTREADY))/$(($WAIOPS_PODS_COUNT_TOTAL)))  (will be around $WAIOPS_PODS_COUNT_EXPECTED pods).. Waiting for 10 seconds...." && sleep 10; 
          done
          echo  "      ✅ OK"
          echo  ""

      else
        echo "    ⚠️  Skipping"
        echo "--------------------------------------------------------------------------------------------------------------------------------"
        echo  ""    
        echo  ""
      fi

}



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Patch the SSL Certs for Slack
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
menu_ssl_certs() {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Recreating SSL Certs for Slack" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
          


      echo "   --------------------------------------------------------------------------------------------------------------------------------"
      echo "    🚀  Patching Certs, old method first" 
      echo "   --------------------------------------------------------------------------------------------------------------------------------"

# collect certificate from OpenShift ingress
ingress_pod=$(oc get secrets -n openshift-ingress | grep tls | grep -v router-metrics-certs-default | awk '{print $1}')
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.crt"}}' ${ingress_pod} | base64 -d > cert.crt
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.key"}}' ${ingress_pod} | base64 -d > cert.key
# backup existing secret
oc get secret -n $WAIOPS_NAMESPACE external-tls-secret -o yaml > external-tls-secret.yaml
# delete existing secret
oc delete secret -n $WAIOPS_NAMESPACE external-tls-secret
# create new secret
oc create secret generic -n $WAIOPS_NAMESPACE external-tls-secret --from-file=cert.crt=cert.crt --from-file=cert.key=cert.key --dry-run=client -o yaml | oc apply -f -
# scale down nginx
REPLICAS=2
oc scale Deployment/ibm-nginx --replicas=0
# scale up nginx
sleep 3
oc scale Deployment/ibm-nginx --replicas=${REPLICAS}
rm cert.crt
rm cert.key
rm external-tls-secret

NGINX_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "ibm-nginx" | grep "0/1" || true) 
while  ([[  $NGINX_READY =~ "0/1" ]]); do 
    NGINX_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "ibm-nginx" | grep "0/1" || true) 
    echo "      ⭕ Nginx not ready. Waiting for 10 seconds...." && sleep 10; 
done



      echo "   --------------------------------------------------------------------------------------------------------------------------------"
      echo "    🚀  Patching Certs, new method" 
      echo "   --------------------------------------------------------------------------------------------------------------------------------"

IAF_STORAGE=$(oc get AutomationUIConfig -n $WAIOPS_NAMESPACE -o jsonpath='{ .items[*].spec.storage.class }')
oc get -n $WAIOPS_NAMESPACE AutomationUIConfig iaf-system -oyaml > iaf-system-backup.yaml
oc delete -n $WAIOPS_NAMESPACE AutomationUIConfig iaf-system
cat <<EOF | oc apply -f -
apiVersion: core.automation.ibm.com/v1beta1
kind: AutomationUIConfig
metadata:
  name: iaf-system
  namespace: $WAIOPS_NAMESPACE
spec:
  description: AutomationUIConfig for cp4waiops
  license:
    accept: true
  version: v1.0
  storage:
    class: $IAF_STORAGE
  tls:
    caSecret:
      key: ca.crt
      secretName: external-tls-secret
    certificateSecret:
      secretName: external-tls-secret
EOF
rm iaf-system-backup.yaml

      else
        echo "    ⚠️  Skipping"
        echo "--------------------------------------------------------------------------------------------------------------------------------"
        echo  ""    
        echo  ""
      fi
}




# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Recreate aimanager-aio-create-secrets Job
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

menu_patch_secrets() {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Preparing to delete aimanager-aio-create-secrets Job to recreate secrets" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo "      🕦 Initializing..." 
      echo ""
      FLINK_SECRET_NOT_FOUND=$(oc logs -n $WAIOPS_NAMESPACE $(oc get po -n $WAIOPS_NAMESPACE --ignore-not-found|grep aimanager-operator|awk '{print$1}') | tail -n 5 | grep "aimanager-flink-config-secret not found")
      if  ([[ $FLINK_SECRET_NOT_FOUND =~ "aimanager-flink-config-secret not found" ]]); then 
            echo "      --------------------------------------------------------------------------------------------------------------------------------"
            echo "      Last Error:  $FLINK_SECRET_NOT_FOUND" 
            echo "      --------------------------------------------------------------------------------------------------------------------------------"
            echo "      ⭕ Secrets seem stuck... " 
            echo ""
      else
            echo "      ✅ Secrets don't seem stuck... Do you still want to do this?" 
            echo ""
      fi

        read -p " ❗❓ Continue (takes 15-20 minutes)? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
          


            echo "   --------------------------------------------------------------------------------------------------------------------------------"
            echo "    🚀  Patching Certs, old method first" 
            echo "   --------------------------------------------------------------------------------------------------------------------------------"


              oc create clusterrolebinding ibm-zen-operator-serviceaccount --clusterrole=cluster-admin --serviceaccount=ibm-common-services:ibm-zen-operator-serviceaccount>$log_output_path 2>&1 || true  

              SECRETS_JOB_EXIST=$(oc get job -n $WAIOPS_NAMESPACE aimanager-aio-create-secrets | grep "/1" || true) 
              while  ([[ ! $SECRETS_JOB_EXIST =~ "/1" ]]); do 
                  SECRETS_JOB_EXIST=$(oc get job -n $WAIOPS_NAMESPACE aimanager-aio-create-secrets | grep "/1" || true) 
                  echo "      ⭕ Secrets generation Pod not created. Waiting for 10 seconds...." && sleep 10; 
              done


            #   SECRETS_JOB_READY=$(oc get job -n $WAIOPS_NAMESPACE aimanager-aio-create-secrets -oyaml | grep "type: Complete" || true) 
            #   if  ([[ ! $SECRETS_JOB_READY =~ "type: Complete" ]]); 
            #   then
            #       echo "      ✅ Job not ready. Waiting for 2 minutes"
            #       sleep 120
            #   fi

            echo "Delete aimanager-aio-create-secrets for recreation"
            oc delete job aimanager-aio-create-secrets -n $WAIOPS_NAMESPACE >$log_output_path 2>&1 || true

            echo "      ✅ OK. Job deleted. Wait 5-10 minutes for it to be recreated."
            echo " "
            echo " "

            echo "      ✅ Scale down the aimanager-operator operator"
            oc scale deployment -n $WAIOPS_NAMESPACE aimanager-operator --replicas=0 >$log_output_path 2>&1 || true
            echo "      ✅ Wait 30 seconds"
            sleep 30
            echo "      ✅ Scale up the aimanager-operator operator"
            oc scale deployment -n $WAIOPS_NAMESPACE aimanager-operator --replicas=1 >$log_output_path 2>&1 || true
            echo " "
            echo " "





            SECRETS_JOB_EXISTS=$(oc get Job aimanager-aio-create-secrets -n $WAIOPS_NAMESPACE | grep "aimanager-aio-create-secrets" || true) 
            while  ([[ ! $SECRETS_JOB_EXISTS =~ "0/1" ]]); do 
            SECRETS_JOB_EXISTS=$(oc get Job aimanager-aio-create-secrets -n $WAIOPS_NAMESPACE | grep "aimanager-aio-create-secrets" || true) 
            __output "      ⭕ Secrets Job not recreated yet. Waiting for 30 seconds...." && sleep 10; 
            done

            echo "Increase activeDeadlineSeconds"
            oc patch Job aimanager-aio-create-secrets -n $WAIOPS_NAMESPACE --patch '{"spec":{"activeDeadlineSeconds":1000}}' --type=merge


            SECRETS_JOB_READY=$(oc get job -n $WAIOPS_NAMESPACE aimanager-aio-create-secrets -oyaml | grep "type: Complete" || true) 
            while  ([[ ! $SECRETS_JOB_READY =~ "type: Complete" ]]); do 
                  SECRETS_JOB_READY=$(oc get job -n $WAIOPS_NAMESPACE aimanager-aio-create-secrets -oyaml | grep "type: Complete" || true) 
                  __output "      ⭕ Secrets Job not ready. Waiting for 10 seconds...." && sleep 10; 
            done
            echo "      ✅ DONE... Job has run successfully and should have created the missing secrets."

      else
        echo "    ⚠️  Skipping"
        echo "--------------------------------------------------------------------------------------------------------------------------------"
        echo  ""    
        echo  ""
      fi
}

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Patch EventManager Resources for ROKS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
menu_patch_evtmanager() {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Patching EventManager Pods" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""
            echo ""
            echo ""

            echo "Patch evtmanager-ibm-hdm-analytics-dev-inferenceservice"
                oc patch deployment evtmanager-ibm-hdm-analytics-dev-inferenceservice -n $WAIOPS_NAMESPACE --patch-file ./yaml/waiops/patches/evtmanager-inferenceservice-patch.yaml || true >$log_output_path 2>&1
                echo "      ✅ OK"
            echo ""

            echo "Patch evtmanager-topology-merge"
                oc patch deployment evtmanager-topology-merge -n $WAIOPS_NAMESPACE --patch-file ./yaml/waiops/patches/evtmanager-topology-merge-patch.yaml || true >$log_output_path 2>&1
                echo "      ✅ OK"
            echo

            echo "Patch evtmanager-topology-merge"
                oc patch deployment evtmanager-topology-status -n $WAIOPS_NAMESPACE --patch-file ./yaml/waiops/patches/evtmanager-topology-status-patch.yaml || true >$log_output_path 2>&1
                echo "      ✅ OK"
            echo

      else
        echo "    ⚠️  Skipping"
        echo "--------------------------------------------------------------------------------------------------------------------------------"
        echo  ""    
        echo  ""
      fi
}






# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Patch ZEN Ingress
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
menu_enable_zen_traffic() {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Patching ZEN Ingress Traffic" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""
            echo ""
            echo ""

            echo "Patch Ingress"
            oc patch namespace default --type=json -p '[{"op":"add","path":"/metadata/labels","value":{"network.openshift.io/policy-group":"ingress"}}]' >$log_output_path 2>&1
            echo "     ✅ Ingress successfully patched"
            echo ""
      else
        echo "    ⚠️  Skipping"
        echo "--------------------------------------------------------------------------------------------------------------------------------"
        echo  ""    
        echo  ""
      fi
}



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create Routes
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
menu_routes() {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Patching Create Custom Routes" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""
            echo ""
            echo ""
            echo "Create Strimzi Route"
                oc patch Kafka strimzi-cluster -n  $WAIOPS_NAMESPACE -p '{"spec": {"kafka": {"listeners": {"external": {"type": "route"}}}}}' --type=merge >$log_output_path 2>&1 || true
                echo "      ✅ OK"
            echo ""

            echo "Create Topology Routes"

            echo "  Create Topology Merge Route"
                    oc create route passthrough topology-merge -n $WAIOPS_NAMESPACE --insecure-policy="Redirect" --service=evtmanager-topology-merge --port=https-merge-api >$log_output_path 2>&1  || true
                echo "      ✅ OK"

            echo ""

            echo "  Create Topology Rest Route"
                    oc create route passthrough topology-rest -n $WAIOPS_NAMESPACE --insecure-policy="Redirect" --service=evtmanager-topology-rest-observer --port=https-rest-observer-admin >$log_output_path 2>&1  || true
                echo "      ✅ OK"

            echo "  Create Topology Topology Route"
                    oc create route passthrough topology-manage -n $WAIOPS_NAMESPACE --service=evtmanager-topology-topology --port=https-topology-api >$log_output_path 2>&1  || true
                echo "      ✅ OK"

            echo ""



            echo "Create Flink Job Manager Routes"

            echo "  Create Flink Job Manager Route"
                oc create route passthrough job-manager -n $WAIOPS_NAMESPACE --service=aimanager-ibm-flink-job-manager --port=8000 >$log_output_path 2>&1 || true
                echo "      ✅ OK"

            echo ""

      else
        echo "    ⚠️  Skipping"
        echo "--------------------------------------------------------------------------------------------------------------------------------"
        echo  ""    
        echo  ""
      fi
}


menu_restart_operators() {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " 🚀  Restart WAIOPS Operators" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo ""
      echo ""
        read -p " ❗❓ Continue? [y,N] " DO_COMM
        if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then


            CP4AIOPS_CHECK_LIST=(
            "iaf-ai-operator-controller-manager"
            "iaf-core-operator-controller-manager"
            "iaf-eventprocessing-operator-controller"
            "iaf-flink-operator-controller-manager"
            "iaf-operator-controller-manager"
            "ibm-aiops-orchestrator"
            "ibm-common-service-operator"
            "ibm-elastic-operator-controller-manager"
            "strimzi-cluster-operator-v0.19.0$")

            for ELEMENT in ${CP4AIOPS_CHECK_LIST[@]}; do
                  echo "   Delete Pod $ELEMENT.."
                  oc delete pod $(oc get po -n openshift-operators|grep $ELEMENT|awk '{print$1}') -n openshift-operators --grace-period 0 --force|| true
                  echo "      ✅ OK: Pod $ELEMENT"; 
            done
      else
        echo "    ⚠️  Skipping"
        echo "--------------------------------------------------------------------------------------------------------------------------------"
        echo  ""    
        echo  ""
      fi
}

incorrect_selection() {
      echo "--------------------------------------------------------------------------------------------------------------------------------"
      echo " ❗ This option does not exist!" 
      echo "--------------------------------------------------------------------------------------------------------------------------------"
}


clear

banner 

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo " 🚀 CloudPak for Watson AIOPs - FIX INSTALL"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  ℹ️  This script provides several options to fix problems with CP4WAIOPS installations"
echo "  "
echo "  🎬 Start with Option 1 to gather some information and recommendations."
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "

#export LOGS_TOPIC=$(oc get kafkatopics.kafka.strimzi.io -n $WAIOPS_NAMESPACE | grep logs-$LOG_TYPE| awk '{print $1;}')


until [ "$selection" = "0" ]; do
  
  echo ""
  
  echo "  ✅ Gather Information (<-- START HERE)"
  echo ""      
  echo "    	1  - Check unsuccessful CP4WAIOPS Installation for hints      - examining unsuccessful CP4WAIOPS Installation for hints (this is by no means complete)    "
  echo ""      
  echo ""      
  echo ""      
  echo ""      
  echo "  ⚠️  Troubleshoot Connections (Low-Danger Zone) "
  echo ""
  echo "    	11  - Troubleshoot/Recreate Certificates for Slack             - recreates ingress certificates if you get SSL error in Slack"
  echo "    	12  - Recreate custom Routes                                   - if the check above mentions missing routes"
  echo ""      
  echo ""      
  echo ""      
  echo "  ❗ Patch stuck installations (Warning Zone) "                    
  echo ""
  echo "    	21  - Patch IAF                                                - if the IBM Automation Foundation does not come up try this"
  echo "    	22  - Patch evtmanager topology pods                           - if the topology-merge pod is crashlooping"
  echo "    	23  - Patch/enable ZEN route traffic                           - if ZEN related components are not coming up"
  
  #echo "    	18  - Patch IBM Automation CSV iaf-eventprocessing-operator    - if iaf-eventprocessing-operator-controller-manager is not coming up"
  echo "    	24  - Delete aio-create-secrets Job                            - stuck at about 107 Pods - if eventmanager related components are not coming up - (takes 15-20 minutes)"
  echo ""      
  echo ""      
  echo ""      
  echo "  💣 Restart Cluster Elements (Danger Zone)"
  echo ""
  echo "    	91  - Restart WAIOPS Operators                                - if everything above fails restart WAIOPS Operators "
  echo "    	92  - Restart CP4WAIOPS Namespace                             - if everything else fails restart $WAIOPS_NAMESPACE  (takes up to an hour)"
  echo "      "
  echo "      "
  echo "      "
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_check_install  ;;
    11 ) clear ; menu_ssl_certs  ;;
    12 ) clear ; menu_routes  ;;
    21 ) clear ; menu_patch_iaf  ;;
    22 ) clear ; menu_patch_evtmanager  ;;
    23 ) clear ; menu_enable_zen_traffic  ;;
#    17 ) clear ; menu_stuck_107 ;;
#    17 ) clear ; menu_patch_iaf_ai_operator   ;;
#    18 ) clear ; menu_patch_iaf_eventprocessing ;;
    24 ) clear ; menu_patch_secrets  ;;
    91 ) clear ;menu_restart_operators ;;
    92 ) clear ; menu_restart_namespace  ;;

    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection  ;;
  esac
  read -p "Press Enter to continue..."
  clear 
done


