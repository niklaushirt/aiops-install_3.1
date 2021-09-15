# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Postinstall Script for all CP4WAIOPS 3.1 components
#
# V3.1 
#
# ©2021 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

export TEMP_PATH=~/aiops-install

# HACK for M1 Macs
export GODEBUG=asyncpreemptoff=1

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

set -o errexit
set -o pipefail
#set -o xtrace
source ./tools/0_global/99_config-global.sh

export SCRIPT_PATH=$(pwd)
export LOG_PATH=""
__getClusterFQDN
__getInstallPath

banner
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "  "
__output "  🚀 CloudPak for Watson AI OPS 3.1 - Post Install"
__output "  "
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"
__output "  "
__output "  "



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header1Begin "Initializing"

header2Begin "Input Parameters" "magnifying"



        while getopts "o:" opt
        do
          case "$opt" in
              o ) OVERRIDE="$OPTARG" ;;
          esac
        done



        if [[ $OVERRIDE == "true" ]];
        then
           export OVERRIDE_CHECKS=true
            __output "     ⚠️ Warning: You have chosen to override install checks!"
        else
           export OVERRIDE_CHECKS=false
        fi


        export STORAGE_CLASS_FILE=$WAIOPS_STORAGE_CLASS_FILE

header2End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install Checks
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header2Begin "Prerequisites Checks"

        getClusterFQDN
        
        #getHosts

        check_jq
        check_kafkacat
        check_elasticdump
        check_cloudctl
        check_oc
        check_helm
        checkHelmExecutable
        checkOpenshiftReachable
        checkKubeconfigIsSet

        

header2End



header2Begin "CloudPak for Watson AI OPS 3.1 (CP4WAIOPS) will be installed in Cluster '$CLUSTER_NAME'"

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# CONFIG SUMMARY
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
__output "       ---------------------------------------------------------------------------------------------------------------------"
__output "       🔍 Your configuration"
__output "       ---------------------------------------------------------------------------------------------------------------------"
__output "       🎛  CLUSTER :                  $CLUSTER_NAME"
__output "       🛰  AI Manager NAMESPACE:      $WAIOPS_NAMESPACE"
__output "       📛 INSTANCE NAME :            $WAIOPS_NAME"
__output "       📦 INSTANCE SIZE :            $WAIOPS_SIZE"
__output "       ---------------------------------------------------------------------------------------------------------------------"
__output "       💾 STORAGE CLASS:             $WAIOPS_STORAGE_CLASS_FILE"
__output "       💾 STORAGE CLASS LARGE:       $WAIOPS_STORAGE_CLASS_LARGE_BLOCK"
__output "       ---------------------------------------------------------------------------------------------------------------------"
__output "       #️⃣  TEMP PATH:                 $INSTALL_PATH"
__output "       ---------------------------------------------------------------------------------------------------------------------------"
__output "  "
header2End



header2Begin "CloudPak for Watson AI OPS  3.1 (CP4WAIOPS) will be installed with the following features:"
printComponentsInstall
header2End

header1End "Initializing"



header1Begin "Post-Install - Independent from CP4WAIOPS"

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Installing Add-Ons that are independent from AIOPS Install
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    

        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Installing TURBONOMIC
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        header2Begin "Install TURBONOMIC"
        
            if [[ $INSTALL_TURBO == "true" ]]; 
            then
                # --------------------------------------------------------------------------------------------------------------------------------
                #  INSTALL
                # --------------------------------------------------------------------------------------------------------------------------------
                ./tools/0_global/44_addon_install_turbonomic.sh

            else
                __output "     ❌ Turbonomic is not enabled... Skipping"
            fi

        header2End 

        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Installing HUMIO
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        header2Begin "Install HUMIO"
        
            if [[ $INSTALL_HUMIO == "true" ]]; 
            then
                # --------------------------------------------------------------------------------------------------------------------------------
                #  INSTALL
                # --------------------------------------------------------------------------------------------------------------------------------
                ./tools/0_global/41_addon_install_humio.sh

            else
                __output "     ❌ Humio is not enabled... Skipping"
            fi

        header2End 








        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Installing LDAP
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
        header2Begin "LDAP - Install"

            if [[ $INSTALL_LDAP == "true" ]]; 
            then

                # --------------------------------------------------------------------------------------------------------------------------------
                #  INSTALL
                # --------------------------------------------------------------------------------------------------------------------------------
                ./tools/0_global/42_addon_install_ldap.sh

            else
                __output "     ❌ LDAP is not enabled... Skipping"
            fi
        header2End



        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Create Demo User
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
        header2Begin "Create OCP User"

            oc project $WAIOPS_NAMESPACE 
            
            oc create serviceaccount -n default demo-admin >$log_output_path 2>&1 || true
            oc create clusterrolebinding test-admin --clusterrole=cluster-admin --serviceaccount=default:demo-admin >$log_output_path 2>&1 || true

            oc create clusterrolebinding ibm-zen-operator-serviceaccount --clusterrole=cluster-admin --serviceaccount=ibm-common-services:ibm-zen-operator-serviceaccount >$log_output_path 2>&1 || true


            __output "      ✅ OK"

        header2End




        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Install Demo Apps
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            
        header2Begin "Install Demo Apps"


            if [[ $INSTALL_DEMO == "true" ]]; 
            then

                APP_INSTALLED=$(oc get ns kubetoy || true) 
                if [[ $APP_INSTALLED =~ "Active" ]]; 
                then
                    __output "     ⭕ Kubetoy already installed... Skipping"
                else
                    header2Begin "Install Kubetoy"
                        oc create ns kubetoy >$log_output_path 2>&1 || true
                        oc apply -n kubetoy -f ./demo_install/kubetoy/kubetoy_all_in_one.yaml >$log_output_path 2>&1 || true
                        
                        __output "      ✅ OK"

                    header2End
                fi


                APP_INSTALLED=$(oc get ns robot-shop || true) 
                if [[ $APP_INSTALLED =~ "Active" ]]; 
                then
                    __output "     ⭕ RobotShop already installed... Skipping"
                else
                    header2Begin "Install RobotShop"
                        oc create ns robot-shop >$log_output_path 2>&1 || true
                        oc adm policy add-scc-to-user privileged -n robot-shop -z robot-shop >$log_output_path 2>&1 || true
                        oc create clusterrolebinding default-robotinfo1-admin --clusterrole=cluster-admin --serviceaccount=robot-shop:robot-shop >$log_output_path 2>&1 || true
                        oc adm policy add-scc-to-user privileged -n robot-shop -z default >$log_output_path 2>&1         || true                                  
                        oc create clusterrolebinding default-robotinfo2-admin --clusterrole=cluster-admin --serviceaccount=robot-shop:default >$log_output_path 2>&1 || true
                        oc apply -f ./demo_install/robotshop/robot-all-in-one.yaml -n robot-shop >$log_output_path 2>&1 || true
                        oc apply -n robot-shop -f ./demo_install/robotshop/load-deployment.yaml >$log_output_path 2>&1 || true
                        
                        __output "      ✅ OK"

                    header3End
                fi


                APP_INSTALLED=$(oc get ns bookinfo || true) 
                if [[ $APP_INSTALLED =~ "Active" ]]; 
                then
                    __output "     ⭕ Bookinfo already installed... Skipping"
                else
                    header2Begin "Install Bookinfo"

                        oc create ns bookinfo >$log_output_path 2>&1 || true
                        oc apply -n bookinfo -f ./demo_install/bookinfo/bookinfo.yaml >$log_output_path 2>&1 || true
                        oc apply -n default -f ./demo_install/bookinfo/bookinfo-create-load.yaml >$log_output_path 2>&1 || true
                        __output "      ✅ OK"

                    header3End
                fi
    
                # APP_INSTALLED=$(oc get ns qotd || true) 
                # if [[ $APP_INSTALLED =~ "Active" ]]; 
                # then
                #     __output "     ⭕ Quote of the Day already installed... Skipping"
                # else
                #     header2Begin "Install Quote of the Day"
                #     oc new-project qotd
                #     oc adm policy add-scc-to-user anyuid -z default
                #     oc apply -f ./demo_install/qotd/k8s
                        
                #         __output "      ✅ OK"

                #     header3End
                # fi



            else
                __output "     ❌ Demo Apps are not enabled... Skipping"
            fi
        header2End "Install Demo Apps"



        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Patch Ingress 
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        header2Begin "Patch Ingress"

                    endpointPublishingStrategy=$(oc get ingresscontroller default -n openshift-ingress-operator -o yaml | grep HostNetwork || true) 

                    if [[ $endpointPublishingStrategy =~ "HostNetwork" ]]; 
                    then
                        header3Begin "Patch Ingress"
                            oc patch namespace default --type=json -p '[{"op":"add","path":"/metadata/labels","value":{"network.openshift.io/policy-group":"ingress"}}]' >$log_output_path 2>&1
                            __output "     ✅ Ingress successfully patched"
                        header3End
                    else
                        __output "     ⭕ Not needed... Skipping"
                    fi
        header2End "Patch Ingress"







        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Create Routes
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        header2Begin "Create Topology Routes"

            header3Begin "Create Topology Merge Route"
                    oc create route passthrough topology-merge -n $WAIOPS_NAMESPACE --insecure-policy="Redirect" --service=evtmanager-topology-merge --port=https-merge-api >$log_output_path 2>&1  || true
                __output "      ✅ OK"

            header3End

            header3Begin "Create Topology Rest Route"
                    oc create route passthrough topology-rest -n $WAIOPS_NAMESPACE --insecure-policy="Redirect" --service=evtmanager-topology-rest-observer --port=https-rest-observer-admin >$log_output_path 2>&1  || true
                __output "      ✅ OK"

            header3Begin "Create Topology Topology Route"
                    oc create route passthrough topology-manage -n $WAIOPS_NAMESPACE --service=evtmanager-topology-topology --port=https-topology-api >$log_output_path 2>&1  || true
                __output "      ✅ OK"

            header3End

        header2End "Create Topology Routes"



        header2Begin "Create Flink Job Manager Routes"

            header3Begin "Create Flink Job Manager Route"
                oc create route passthrough job-manager -n $WAIOPS_NAMESPACE --service=aimanager-ibm-flink-job-manager --port=8000 >$log_output_path 2>&1 || true
                __output "      ✅ OK"

            header3End

        header2End "Create Flink Job Manager Routes"






        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Installing Add-Ons that are dependent on Common Services
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # This can only be done if the CS install is finished
        if [[ $OVERRIDE_CHECKS == "false" ]]; 
                        then

            header2Begin "Install Checks"
                    checkCSDone
                    __output "      ✅ OK: Common Services are Ready"
            header2End
        fi






        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Register LDAP
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
        header2Begin "Register LDAP"


                header3Begin "LDAP - Register"

                    if [[ $INSTALL_LDAP == "true" ]]; 
                    then

                        # --------------------------------------------------------------------------------------------------------------------------------
                        #  INSTALL
                        # --------------------------------------------------------------------------------------------------------------------------------
                        ./tools/0_global/43_addon_register_ldap.sh
                        __output "      ✅ OK"

                    else
                        __output "     ❌ LDAP is not enabled... Skipping"
                    fi
                header3End


        header2End "Register LDAP"







        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Patch Resources for ROKS
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        header2Begin "Patch Resources for ROKS"


            HDM_ANLTCS_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "evtmanager-ibm-hdm-analytics-dev-inferenceservice" || true) 
            while  ([[ ! $HDM_ANLTCS_READY =~ "evtmanager-ibm-hdm-analytics-dev-inferenceservice" ]]); do 
                HDM_ANLTCS_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "evtmanager-ibm-hdm-analytics-dev-inferenceservice" || true) 
                __output "      ⭕ HDM Inference Service Pod not present. Waiting for 10 seconds...." && sleep 10; 
            done

            header3Begin "Patch evtmanager-ibm-hdm-analytics-dev-inferenceservice"
                oc patch deployment evtmanager-ibm-hdm-analytics-dev-inferenceservice -n $WAIOPS_NAMESPACE --patch-file ./yaml/waiops/patches/evtmanager-inferenceservice-patch.yaml || true >$log_output_path 2>&1
                __output "      ✅ OK"
            header3End



        header2End "Patch Resources for ROKS"



        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Wait for ZEN Operator to finish running Ansible Scripts
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        header2Begin "Wait for ZEN Operator to finish running Ansible Scripts  (❗ this will take some time - up to 15-20 mins)"

            ZEN_READY=$(oc logs -n ibm-common-services $(oc get po -n ibm-common-services|grep ibm-zen|awk '{print$1}') | tail -n 5| grep 'ok=2' || true) 
            while  ([[ ! $ZEN_READY =~ "ok=2" ]]); do 
                ZEN_READY=$(oc logs -n ibm-common-services $(oc get po -n ibm-common-services|grep ibm-zen|awk '{print$1}') | tail -n 5| grep 'ok=2' || true) 
                __output "      ⭕ ZEN Operator still running Ansible Scripts. Waiting for 10 seconds...." && sleep 10; 
            done

    
            __output "      $ZEN_READY"    
            __output "      ✅ OK"

        header2End "Wait for ZEN Operator to finish running Ansible Scripts"



        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Create Strimzi Route
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        header2Begin "Create Strimzi Route"

            STRIMZI_READY=$(oc get Kafka strimzi-cluster -n $WAIOPS_NAMESPACE | grep "strimzi-cluster   1" || true) 
            while  ([[ ! $STRIMZI_READY =~ "strimzi-cluster" ]]); do 
                STRIMZI_READY=$(oc get Kafka strimzi-cluster -n $WAIOPS_NAMESPACE | grep "strimzi-cluster   1" || true) 
                __output "      ⭕ STRIMZI Installation CR not ready. Waiting for 10 seconds...." && sleep 10; 
            done



            header3Begin "Create Strimzi Route"
                oc patch Kafka strimzi-cluster -n  $WAIOPS_NAMESPACE -p '{"spec": {"kafka": {"listeners": {"external": {"type": "route"}}}}}' --type=merge >$log_output_path 2>&1 || true
                __output "      ✅ OK"
            header3End

        header2End "Create Strimzi Route"





     




        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Patch Resources for ROKS
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        header2Begin "Patch Resources for ROKS"

            TOPO_MERGE_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "evtmanager-topology-merge" || true) 
            while  ([[ ! $TOPO_MERGE_READY =~ "evtmanager-topology-merge" ]]); do 
                TOPO_MERGE_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "evtmanager-topology-merge" || true) 
                __output "      ⭕ Topology Merge Pod not present. Waiting for 10 seconds...." && sleep 10; 
            done

            header3Begin "Patch evtmanager-topology-merge"

               oc patch deployment evtmanager-topology-merge -n $WAIOPS_NAMESPACE --patch-file ./yaml/waiops/patches/evtmanager-topology-merge-patch.yaml || true >$log_output_path 2>&1
                __output "      ✅ OK"
            header3End


            TOPO_STATUS_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "evtmanager-topology-status" || true) 
            while  ([[ ! $TOPO_STATUS_READY =~ "evtmanager-topology-status" ]]); do 
                TOPO_STATUS_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "evtmanager-topology-status" || true) 
                __output "      ⭕ Topology Status Pod not present. Waiting for 10 seconds...." && sleep 10; 
            done

            header3Begin "Patch evtmanager-topology-status"

               oc patch deployment evtmanager-topology-status -n $WAIOPS_NAMESPACE --patch-file ./yaml/waiops/patches/evtmanager-topology-status-patch.yaml || true >$log_output_path 2>&1
                __output "      ✅ OK"
            header3End
        header2End "Patch Resources for ROKS"










        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Adapt Slack Welcome Message
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        header2Begin "Adapt Slack Welcome Message"

            SLACK_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "slack" || true) 
            while  ([[ ! $SLACK_READY =~ "Running" ]]); do 
                SLACK_READY=$(oc get pod -n $WAIOPS_NAMESPACE | grep "slack" || true) 
                __output "      ⭕ Slack Pod Installation CR not ready. Waiting for 10 seconds...." && sleep 10; 
            done


            header3Begin "Patch Environment"
                  oc set env -n $WAIOPS_NAMESPACE deployment/$(oc get deploy -n $WAIOPS_NAMESPACE -l app.kubernetes.io/component=chatops-slack-integrator -o jsonpath='{.items[*].metadata.name }') SLACK_WELCOME_COMMAND_NAME=/welcome >$log_output_path 2>&1 || true
                __output "      ✅ OK"
            header3End

        header2End "Adapt Slack Welcome Message"



        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # Install Gateway
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        header2Begin "Create Gateway"

            header3Begin "Create Gateway for all Events Severity > 2"

                cp ./yaml/gateway/gateway-generic-template.yaml /tmp/gateway-generic.yaml
                ${SED} -i "s/<CP4WAIOPS_NAMESPACE>/$WAIOPS_NAMESPACE/" /tmp/gateway-generic.yaml
                oc apply -n $WAIOPS_NAMESPACE -f /tmp/gateway-generic.yaml || true >$log_output_path 2>&1
                __output "      ✅ OK"
            header3End

            header3Begin "Adapt Gateway to be able to connect (HACK)"
                oc apply -n $WAIOPS_NAMESPACE -f ./yaml/gateway/gateway_cr_cm.yaml || true >$log_output_path 2>&1
                oc delete pod -n $WAIOPS_NAMESPACE $(oc get po -n $WAIOPS_NAMESPACE|grep event-gateway-generic|awk '{print$1}') || true >$log_output_path 2>&1
                __output "      ✅ OK"
            header3End



        header2End "Create Gateway"


header1End "Post-Install - Independent from CP4WAIOPS"


header1Begin "Check installation status for CP4WAIOPS"
checkInstallDone
header1End "Check installation status for CP4WAIOPS"


__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output " ✅ CP4WAIOPS Base Elements Installed"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"





__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""
__output ""


printCredentials