#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Functions for install scripts
#
# V2.0 
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


export TEMP_PATH=~/aiops-install

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Init Code
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
        # fix sed issue on mac
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
        SED="sed"
        if [ "${OS}" == "darwin" ]; then
            SED="gsed"
            if [ ! -x "$(command -v ${SED})"  ]; then
            __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
            exit
            fi
        fi


export INDENT=""

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Functions
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
    # Helpers
    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
        

        function __output() {
            echo "$INDENT $1"
            echo "$(date +'%Y.%m.%d') - $(date +'%T')      $1" | sed "s/\[.;..m//" | sed "s/\[0;32m//" | sed "s/\[0m//" >> $LOG_FILE
        }
        

        function __getInstallPath() {

            export INSTALL_PATH=$TEMP_PATH/$CLUSTER_NAME/$0
            if [[ -z $LOG_PATH  ]];
            then
                export LOG_PATH=$TEMP_PATH/$CLUSTER_NAME
                export LOG_FILE=$LOG_PATH/install_$(date +'%Y%m%d%H%M').log
            fi
            mkdir -p $INSTALL_PATH 
        }

        
        function __getClusterFQDN() {
            CLUSTER_ROUTE=$(oc get routes console -n openshift-console | tail -n 1 2>&1 ) 
            if [[ $CLUSTER_ROUTE =~ "reencrypt" ]];
            then
                CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
                export CLUSTER_NAME=$(echo $CLUSTER_FQDN | ${SED} "s/$OCP_CONSOLE_PREFIX.//")
            
                export CONSOLE_URL=$OCP_CONSOLE_PREFIX.$CLUSTER_NAME
                export MCM_SERVER=https://cp-console.$CLUSTER_NAME
                export MCM_PROXY=https://icp-proxy.$CLUSTER_NAME
            else
                CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
                
                echo "1111:$CLUSTER_FQDN"
                
                export CLUSTER_NAME=$(echo $CLUSTER_FQDN | ${SED} "s/$OCP_CONSOLE_PREFIX.//")
                            echo "1112:$CLUSTER_NAME"

                export CONSOLE_URL=$OCP_CONSOLE_PREFIX.$CLUSTER_NAME
                export MCM_SERVER=https://cp-console.$CLUSTER_NAME
                export MCM_PROXY=https://icp-proxy.$CLUSTER_NAME

                echo "    ❗ Cannot determine Route"
                echo "    Check your Kubernetes Configuration"
                echo "    IF you are on Fyre you might have to add the following to your hosts file:"
                IP_HOST=$(ping -c 1 api.$CLUSTER_NAME | sed -n 1p | awk '{print $3}' | gsed "s/\://"| gsed "s/(//"| gsed "s/)//")
                echo "    9$IP_HOST	cp-console.apps.<FYRE_INSTALCE_NAME>.os.fyre.ibm.com api.<FYRE_INSTALCE_NAME>.os.fyre.ibm.com"
                echo "    ❌ Aborting"
                exit 1
            fi
        }



 function printCredentials() {



            banner
            __output "***************************************************************************************************************************************************"
            __output "***************************************************************************************************************************************************"
            __output "***************************************************************************************************************************************************"
            __output "***************************************************************************************************************************************************"
            __output "  "
            __output "  CloudPak for Watson AIOps Passwords"
            __output "  "
            __output "***************************************************************************************************************************************************"
            __output "***************************************************************************************************************************************************"
            __output "***************************************************************************************************************************************************"
            __output "  "
            __output "  "



   


            header2Begin "CloudPak for Watson AIOps"

                header3Begin "CP4WAIOPS"
                        __output "    AIOPS:"
                        __output "        URL:      https://cpd-aiops.$CLUSTER_NAME"
                        __output "        User:     $(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_username}' | base64 -d && echo)"
                        __output "        Password: $(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d)"

                header3End



                header3Begin "Administration hub / Common Services"
                        __output "        URL:      https://cp-console.$CLUSTER_NAME"
                        __output "        User:     $(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_username}' | base64 -d && echo)"
                        __output "        Password: $(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d)"

                header3End


                header3Begin "Event Manager"

                        __output "---------------------------------------------------------------------------------------------"
                        __output "    ICPADMIN USER:"
                        __output "        User:     icpadmin"
                        __output "        Password: $(oc get secret evtmanager-icpadmin-secret -o json -n $WAIOPS_NAMESPACE| grep ICP_ADMIN_PASSWORD  | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"

                        __output "---------------------------------------------------------------------------------------------"
                        __output "    SMADMIN USER:"
                        __output "        User:     smadmin"
                        __output "        Password: $(oc get secret evtmanager-was-secret -o json -n $WAIOPS_NAMESPACE| grep WAS_PASSWORD | cut -d : -f2 | cut -d '"' -f2 | base64 -d;)"
                        
                        __output "---------------------------------------------------------------------------------------------"
                        __output "    ASM TOPOLOGY USER:"
                        __output "        User:     aimanager-topology-aiops-user"
                        __output "        Password: $(oc get secret evtmanager-topology-asm-credentials -n $WAIOPS_NAMESPACE -o=template --template={{.data.password}} | base64 -D)"
                        __output " "
                        __output " "

                        __output "---------------------------------------------------------------------------------------------"
                        __output "---------------------------------------------------------------------------------------------"

                        __output "    Netcool (NOI):"
                        __output "        URL:     https://netcool-evtmanager.$CLUSTER_NAME/"


                        __output "---------------------------------------------------------------------------------------------"
                        __output "    WebGUI:"
                        __output "        URL:     https://netcool.evtmanager.$CLUSTER_NAME/ibm/console"



                        __output "---------------------------------------------------------------------------------------------"
                        __output "    WAS Console:"
                        __output "        URL:     https://was-evtmanager.$CLUSTER_NAME/ibm/console"



                        __output "---------------------------------------------------------------------------------------------"
                        __output "    CUSTOM TOPOLOGY ROUTES:"
                        __output "        MERGE:"
                        __output "            SWAGGER URL:     https://$(oc get route topology-merge  -n $WAIOPS_NAMESPACE -o jsonpath='{ .spec.host}')/1.0/merge/swagger"
                        __output "        REST:"
                        __output "            SWAGGER URL:     https://$(oc get route topology-rest  -n $WAIOPS_NAMESPACE -o jsonpath='{ .spec.host}')/1.0/rest-observer/swagger"

                header3End

            header2End "CloudPak for Watson AIOps"




            header2Begin "LDAP Connection Details"
                    
                        __output "    OPENLDAP:"
                        __output "        URL:      http://openldap-admin-default.$CLUSTER_NAME/"
                        __output "        User:     cn=admin,dc=ibm,dc=com"
                        __output "        Password: P4ssw0rd!"


            header2End "LDAP Connection Details"





            header2Begin "OCP Connection Details"
                    

                        DEMO_TOKEN=$(oc -n default get secret $(oc get secret -n default |grep -m1 demo-admin-token|awk '{print$1}') -o jsonpath='{.data.token}'|base64 -d)
                        DEMO_URL=$(oc status|grep -m1 "In project"|awk '{print$6}')

                        #echo "        URL:     $DEMO_URL"
                        #echo "        Token:   $DEMO_TOKEN"

                        __output "        URL:     $DEMO_URL"
                        __output "        Token:   $DEMO_TOKEN"
                        __output ""
                        __output ""
                        __output ""

                        __output "        Login:   oc login --token=$DEMO_TOKEN --server=$DEMO_URL"


            header2End "OCP Connection Details"


            if [[ $INSTALL_HUMIO == "true" ]]; 
            then
                header2Begin "HUMIO Connection Details"
                        

                            __output "    HUMIO:"
                            __output "        URL:      http://humio-humio-logging.$CLUSTER_NAME/"
                            __output "        User:     developer"
                            __output "        Password: $(oc get secret developer-user-password -n humio-logging -o=template --template={{.data.password}} | base64 -D)"
                            __output ""
                            __output ""
                            __output ""
                            __output "        INTEGRATION URL:      http://humio-humio-logging.$CLUSTER_NAME/api/v1/repositories/aiops/query"

                header2End "HUMIO Connection Details"
            fi



            MYFS_READY=$(oc get pods -n rook-ceph | grep "rook-ceph-mds-myfs" | grep "Running" | grep "1/1" || true) 
            if [[ $MYFS_READY =~ "Running" ]]; 
            then

                header2Begin "Rook/Ceph Dashboard Connection Details"


                __output "    Rook/Ceph Dashboard :"
                __output "        URL:      https://dash-rook-ceph.$CLUSTER_NAME/"
                __output "        User:     admin"
                __output "        Password: $(oc -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode)"
                header2End "Rook/Ceph Dashboard Connection Details"
            fi

        }


        function checkInstallDone() {


            __output "   🔎 Check if CP4WAIOPS Installation CR ready."

            WAIOPS_READY=$(oc get installations.orchestrator.aiops.ibm.com $WAIOPS_NAME -n $WAIOPS_NAMESPACE -oyaml | grep "phase: Running" || true) 
            while  ([[ ! $WAIOPS_READY =~ "Running" ]]); do 
                WAIOPS_READY=$(oc get installations.orchestrator.aiops.ibm.com $WAIOPS_NAME -n $WAIOPS_NAMESPACE -oyaml | grep "phase: Running" || true) 
                WAIOPS_PODS_COUNT_TOTAL=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | wc -l || true) 
                WAIOPS_PODS_COUNT_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" | wc -l || true) 
        
                __output "      ⭕ CP4WAIOPS Installation CR not ready ($(($WAIOPS_PODS_COUNT_TOTAL - $WAIOPS_PODS_COUNT_NOTREADY))/$(($WAIOPS_PODS_COUNT_TOTAL))). Waiting for 10 seconds...." && sleep 10; 

                if [[ $VERBOSE_INSTALL == "true" ]]; 
                then
                    WAIOPS_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" || true) 
                    __output "      🔎  Namespace $WAIOPS_NAMESPACE not ready"
                    __output "$WAIOPS_NOTREADY"
                fi
            done
            __output "      ✅ OK"
            __output ""





            __output "   🔎 Check if AI Manager Password is ready."

            AI_MGR_PWD=$(oc -n $WAIOPS_NAMESPACE get secret admin-user-details -o jsonpath='{.data.initial_admin_password}' | base64 -d || true )     
            while  ([[ $AI_MGR_PWD == "" ]]); do 
                AI_MGR_PWD=$(oc -n $WAIOPS_NAMESPACE get secret admin-user-details -o jsonpath='{.data.initial_admin_password}' | base64 -d || true )   
                WAIOPS_PODS_COUNT_TOTAL=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | wc -l || true) 
                WAIOPS_PODS_COUNT_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" | wc -l || true) 
                
                __output "      ⭕ AI Manager not ready ($(($WAIOPS_PODS_COUNT_TOTAL - $WAIOPS_PODS_COUNT_NOTREADY))/$(($WAIOPS_PODS_COUNT_TOTAL))). Waiting for 10 seconds...." && sleep 10; 

                if [[ $VERBOSE_INSTALL == "true" ]]; 
                then
                    WAIOPS_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" || true) 
                    __output "      🔎  Namespace $WAIOPS_NAMESPACE not ready"
                    __output "$WAIOPS_NOTREADY"
                fi
            done
            __output "      ✅ OK"
            __output ""




            __output "   🔎 Check if Common Services Password is ready."

            COMMON_SVC_PWD=$(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d || true )     
            while  ([[ $COMMON_SVC_PWD == "" ]]); do 
                COMMON_SVC_PWD=$(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d || true )     
                
                __output "      ⭕ Common Services not ready. Waiting for 10 seconds...." && sleep 10; 

                if [[ $VERBOSE_INSTALL == "true" ]]; 
                then
                    CS_NOTREADY=$(oc get pods -n ibm-common-services | grep -v "Completed" | grep "0/" || true) 
                    __output "      🔎 Namespace ibm-common-services not ready"
                    __output "$CS_NOTREADY"
                fi
            done
            __output "      ✅ OK"
            __output ""




            __output "   🔎 Check if Event Manager is ready."

            EVT_MGR_PWD=$(oc get secret evtmanager-icpadmin-secret -o json -n $WAIOPS_NAMESPACE| grep ICP_ADMIN_PASSWORD  | cut -d : -f2 | cut -d '"' -f2 | base64 -d || true )     
            while  ([[ $EVT_MGR_PWD == "" ]]); do 
                EVT_MGR_PWD=$(oc get secret evtmanager-icpadmin-secret -o json -n $WAIOPS_NAMESPACE| grep ICP_ADMIN_PASSWORD  | cut -d : -f2 | cut -d '"' -f2 | base64 -d  || true )     
                WAIOPS_PODS_COUNT_TOTAL=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | wc -l || true) 
                WAIOPS_PODS_COUNT_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" | wc -l || true) 
                
                __output "      ⭕ Event Manager not ready ($(($WAIOPS_PODS_COUNT_TOTAL - $WAIOPS_PODS_COUNT_NOTREADY))/$(($WAIOPS_PODS_COUNT_TOTAL))). Waiting for 10 seconds...." && sleep 10; 

                if [[ $VERBOSE_INSTALL == "true" ]]; 
                then
                    WAIOPS_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" || true) 
                    __output "      🔎  Namespace $WAIOPS_NAMESPACE not ready"
                    __output "$WAIOPS_NOTREADY"
                fi
            done
            __output "      ✅ OK"
            __output ""




            __output "   🔎 Check if all pods in $WAIOPS_NAMESPACE are ready."

            WAIOPS_PODS_COUNT_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" | wc -l || true) 
            #WAIOPS_PODS_COUNT_NOTREADY="   0"
            while  ([[ ! $WAIOPS_PODS_COUNT_NOTREADY =~ " 0" ]]); do 
                WAIOPS_PODS_COUNT_NOTREADY=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | grep "0/" | wc -l || true) 
                WAIOPS_PODS_COUNT_TOTAL=$(oc get pods -n $WAIOPS_NAMESPACE | grep -v "Completed" | wc -l || true) 
                
                __output "      ⭕ CP4WAIOPS not ready ($(($WAIOPS_PODS_COUNT_TOTAL - $WAIOPS_PODS_COUNT_NOTREADY))/$(($WAIOPS_PODS_COUNT_TOTAL)))  (will be around 150 pods).. Waiting for 10 seconds...." && sleep 10; 
            done
            __output "      ✅ OK"
            __output ""
        }
            


        function checkCSDone() {
 
            __output "   🔎 Check if Common Services Password is ready."

            COMMON_SVC_PWD=$(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d || true )     
            while  ([[ $COMMON_SVC_PWD == "" ]]); do 
                COMMON_SVC_PWD=$(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d || true )     

                __output "      ⭕ Common Services not ready. Waiting for 10 seconds...." && sleep 10; 

                if [[ $VERBOSE_INSTALL == "true" ]]; 
                then
                    CS_NOTREADY=$(oc get pods -n ibm-common-services | grep -v "Completed" | grep "0/" || true) 
                    __output "      🔎 Namespace ibm-common-services not ready"
                    __output "$CS_NOTREADY"
                fi
            done
            __output "      ✅ OK"
            __output ""

            __output "   🔎 Check if all pods in common-services are ready."

            CS_PODS_COUNT_NOTREADY=$(oc get pods -n ibm-common-services | grep -v "Completed" | grep "0/" | wc -l || true) 
            #WAIOPS_PODS_COUNT_NOTREADY="   0"
            while  ([[ ! $CS_PODS_COUNT_NOTREADY =~ " 0" ]]); do 
                CS_PODS_COUNT_NOTREADY=$(oc get pods -n ibm-common-services | grep -v "Completed" | grep "0/" | wc -l || true) 
                CS_PODS_COUNT_TOTAL=$(oc get pods -n ibm-common-services | grep -v "Completed" | wc -l || true) 

                __output "      ⭕ Common Services not ready ($(($CS_PODS_COUNT_TOTAL - $CS_PODS_COUNT_NOTREADY))/$(($CS_PODS_COUNT_TOTAL)))  (will be around 33 pods). Waiting for 10 seconds...." && sleep 10; 
            done
            __output "      ✅ OK"
            __output ""
        }

        function getInstallPath() {

            export INSTALL_PATH=$TEMP_PATH/$CLUSTER_NAME/$0
            if [[ -z $LOG_PATH  ]];
            then
                export LOG_PATH=$TEMP_PATH/$CLUSTER_NAME
                export LOG_FILE=$LOG_PATH/install_$(date +'%Y%m%d%H%M').log
            fi
            #__output $INSTALL_PATH
            mkdir -p $INSTALL_PATH 
            #__output "    🔧 Get Temp Directory Path:"
            #__output "        $INSTALL_PATH"
        }

        
        function getClusterFQDN() {
        __output  "  "
        __output " 🔧 Determining Cluster FQDN"
            CLUSTER_ROUTE=$(oc get routes console -n openshift-console | tail -n 1 2>&1 ) 
            if [[ $CLUSTER_ROUTE =~ "reencrypt" ]];
            then
                CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
                export CLUSTER_NAME=$(echo $CLUSTER_FQDN | ${SED} "s/$OCP_CONSOLE_PREFIX.//")
            
                export CONSOLE_URL=$OCP_CONSOLE_PREFIX.$CLUSTER_NAME
                export MCM_SERVER=https://cp-console.$CLUSTER_NAME
                export MCM_PROXY=https://icp-proxy.$CLUSTER_NAME
                
                __output "      🖲️  Cluster FQDN:                                   $CLUSTER_NAME"
                __output " "
            #return $CLUSTER_NAME
            else
                __output "    ❗ Cannot determine Route"
                __output "    Check your Kubernetes Configuration"
                __output "    IF you are on Fyre you might have to add the following to your hosts file:"
                IP_HOST=$(ping -c 1 api.$CLUSTER_NAME | sed -n 1p | awk '{print $3}' | gsed "s/\://"| gsed "s/(//"| gsed "s/)//")
                __output "    9$IP_HOST	cp-console.apps.<FYRE_INSTALCE_NAME>.os.fyre.ibm.com api.<FYRE_INSTALCE_NAME>.os.fyre.ibm.com"
                __output "    ❗ ❌ Aborting"
                exit 1
            fi
        }




        function getAPIUrl() {
            __output "  "
            __output " 🔧 Determining API URL"
            API_URL_STRING=$(oc config current-context 2>&1 ) 

            API_URL=https://$( echo "$API_URL_STRING" | awk -F/ '{print $2}' 2>&1 ) 
    
            __output "       API URL:                  $API_URL"
        
        }






        function getHosts() {
            __output "  "
            __output " 🔧 Determining Cluster Node IPs"
            CLUSTERS=$(oc get nodes --selector=node-role.kubernetes.io/worker="" 2>&1 ) 


            if [[ $CLUSTERS =~ "No resources found" ]];
            then
                CLUSTERS=$(oc get nodes --selector=node-role.kubernetes.io/compute='true' 2>&1 ) 
            fi

            if [[ $CLUSTERS =~ "NAME" ]];
                then
                CLUSTER_W1=$( echo "$CLUSTERS" | sed -n 2p | awk '{print $1}' 2>&1 ) 
                CLUSTER_W2=$( echo "$CLUSTERS" | sed -n 3p | awk '{print $1}' 2>&1 ) 
                CLUSTER_W3=$( echo "$CLUSTERS" | sed -n 4p | awk '{print $1}' 2>&1 ) 

                if [[ $CLUSTER_W3 == "" &&  $CLUSTER_W2 == "" ]];
                then
                    __output "       One Worker"
                    export MASTER_HOST=$CLUSTER_W1
                    export PROXY_HOST=$CLUSTER_W1
                    export MANAGEMENT_HOST=$CLUSTER_W1
                elif [[ $CLUSTER_W3 == "" ]];
                then
                    __output "       Two Workers"
                    export MASTER_HOST=$CLUSTER_W1
                    export PROXY_HOST=$CLUSTER_W1
                    export MANAGEMENT_HOST=$CLUSTER_W2
                else                   
                    __output "       Three or more Workers"
                    export MASTER_HOST=$CLUSTER_W1
                    export PROXY_HOST=$CLUSTER_W2
                    export MANAGEMENT_HOST=$CLUSTER_W3
                fi

                __output "       Setting Master to:                  $MASTER_HOST"
                __output "       Setting Proxy to:                   $PROXY_HOST"
                __output "       Setting Management to:              $MANAGEMENT_HOST"
            else
                __output "       ❗ Cannot determine Cluster Nodes"
                __output "       Check your Kubernetes Configuration"
                __output "       oc output is: $CLUSTERS"
                __output "       ❗ ❌ Aborting"
                exit 1
            fi
        }




        function assignHosts() {
            __output "    🔧 Assign Hosts"
            export MASTER_COMPONENTS=$MASTER_HOST  #.$CLUSTER_NAME
            export PROXY_COMPONENTS=$PROXY_HOST  #.$CLUSTER_NAME
            export MANAGEMENT_COMPONENTS=$MANAGEMENT_HOST  #.$CLUSTER_NAME
        }






      function createToken
        {
            __output "     🔧 Create Token"
            export serviceIDName='service-deploy'
            export serviceApiKeyName='service-deploy-api-key'
            
            LOGIN_OK=$(cloudctl login -a ${MCM_SERVER} --skip-ssl-validation -u ${MCM_USER} -p ${MCM_PWD} -n services)
            if [[ $LOGIN_OK =~ "Error response from server" ]];
            then
                __output "    ❗ ERROR: Could not login to MCM Hub on Cluster '$CLUSTER_NAME'. Aborting."
                exit 2
            fi

            cloudctl iam service-id-delete ${serviceIDName} -f
            #cloudctl iam service-api-key-delete ${serviceApiKeyName} ${serviceIDName} -f

            cloudctl iam service-id-create ${serviceIDName} -d 'Service ID for service-deploy'
            cloudctl iam service-policy-create ${serviceIDName} -r Administrator,ClusterAdministrator --service-name 'idmgmt'
            cloudctl iam service-policy-create ${serviceIDName} -r Administrator,ClusterAdministrator --service-name 'identity'
            cloudctl iam service-api-key-create ${serviceApiKeyName} ${serviceIDName} -d 'Api key for service-deploy' > token.txt
        }





    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    # INSTALL CHECKS
    # ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         function dockerRunning() {
            __output "   🔎 Check if Docker is running"
            DOCKER_RESOLVE=$(docker ps || true 2>&1)
            if [[ $DOCKER_RESOLVE =~ "CONTAINER ID" ]];
            then
                __output "      ✅ OK"
            else 
                __output "    ❗   ERROR: Docker is not running"
                __output "           ❗ ❌ Aborting."
                exit 1
            fi
            __output ""
        }
 
 
 
        function checkOpenshiftReachable() {
            __output "   🔎 Check if OpenShift is reachable at               $CONSOLE_URL"
            PING_RESOLVE=$(ping -c 1 $CONSOLE_URL 2>&1)
            if [[ $PING_RESOLVE =~ "cannot resolve" ]];
            then
                __output "    ❗   ERROR: Cluster '$CLUSTER_NAME' is not reachable"
                __output "           ❗ ❌ Aborting."
                exit 1
            else 
                __output "      ✅ OK"
            fi
            __output ""
        }


        function checkKubeconfigIsSet() {
            __output "   🔎 Check if OpenShift KUBECONTEXT is set for        $CLUSTER_NAME"
            KUBECTX_RESOLVE=$(oc get routes --all-namespaces 2>&1)


            if [[ $KUBECTX_RESOLVE =~ $CLUSTER_NAME ]];
            then
                __output "      ✅ OK"
            else 
                __output "    ❗   ERROR: Please log into  '$CLUSTER_NAME' via the OpenShift web console"
                __output "           ❗ ❌ Aborting."
                exit 1
            fi
            __output ""

        }


        function checkStorageClassExists() {
            __output "   🔎 Check if Storage Class exists: $STORAGE_CLASS_FILE"
            SC_RESOLVE=$(oc get sc 2>&1)

            if [[ $SC_RESOLVE =~ $STORAGE_CLASS_FILE ]];
            then
                __output "      ✅ OK: Storage Class exists"
            else 
                __output "    ❗   ERROR: Storage Class $STORAGE_CLASS_FILE does not exist."
                __output "                 On IBM ROKS use: ibmc-file-gold-gid"
                __output "                 On TEC use:      nfs-client"
                __output "                 On FYRE use:     rook-cephfs (you can install Rook/Ceph with ./22_install_rook.sh"
                __output "            Please set the correct storage class in file 01_config-modules.sh"
                __output "           ❗ Aborting."
                exit 1
            fi
            __output ""

            if [[ $CLUSTER_NAME =~ "appdomain.cloud" ]] && [[ ! $STORAGE_CLASS_FILE =~ "ibmc-file-gold-gid" ]];
            then 
                __output "    ⚠️   WARNING: It seems that you are on IBM ROKS and your Storage Class is $STORAGE_CLASS_FILE."
                __output "        This might not work!."
            fi

            if [[ $CLUSTER_NAME =~ "tec.uk.ibm.com" ]] && [[ ! $STORAGE_CLASS_FILE =~ "nfs-client" ]];
            then 
                __output "    ⚠️   WARNING: It seems that you are on TEC and your Storage Class is $STORAGE_CLASS_FILE."
                __output "        This might not work!."
            fi

            if [[ $CLUSTER_NAME =~ "fyre.ibm.com" ]] && [[ ! $STORAGE_CLASS_FILE =~ "rook-cephfs" ]];
            then 
                __output "    ⚠️   WARNING: It seems that you are on IBM Fyre and your Storage Class is $STORAGE_CLASS_FILE."
                __output "        This might not work!."
            fi

        }


        function checkDefaultStorageDefined() {
            __output "   🔎 Check if Default Storage Class is defined"
            SC_RESOLVE=$(oc get sc 2>&1)

            if [[ $SC_RESOLVE =~ (default) ]];
            then
                __output "      ✅ OK: Default Storage Class defined"
            else 
                __output "    ❗   ERROR: No default Storage Class defined."
                __output "           Define Annotation: storageclass.kubernetes.io/is-default-class=true"
                __output "           ❗ ❌ Aborting."
                exit 1
            fi
            __output ""
        }


        function checkRegistryCredentials() {
            __output "   🔎 Check if Docker Registry Credentials work ($ENTITLED_REGISTRY_KEY)"
            __output "         This might take some time"

            DOCKER_LOGIN=$(echo "$ENTITLED_REGISTRY_KEY" | docker login "$ENTITLED_REGISTRY" -u "$ENTITLED_REGISTRY_USER" --password-stdin ) > /dev/null
          #        cp.icr.io/cp/cp4mcm/synthetic-agent@sha256:c89ebd794dc97a557e56b5d7d9eeefde99bb48ec16f0cf79a2d2ddba93ef6d40
            docker pull $ENTITLED_REGISTRY/cp/cp4mcm/synthetic-agent@sha256:c89ebd794dc97a557e56b5d7d9eeefde99bb48ec16f0cf79a2d2ddba93ef6d40

            DOCKER_PULL=$(docker pull $ENTITLED_REGISTRY/cp/cp4mcm/synthetic-agent@sha256:c89ebd794dc97a557e56b5d7d9eeefde99bb48ec16f0cf79a2d2ddba93ef6d40 > /dev/null)


            if [[ $DOCKER_PULL =~ "pull access denied" ]];
            then
                __output "❗   ERROR: Not entitled for Registry or not reachable"
                __output "           ❗ Aborting."
                exit 1
            else
                __output "      ✅ OK"
            fi
            __output ""
        }

   function checkRegistryCredentialsOK() {
            __output "   🔎 Check if Docker Registry Credentials work ($ENTITLED_REGISTRY_KEY)"
            __output "         This might take some time"

            #docker login "$ENTITLED_REGISTRY" -u "$ENTITLED_REGISTRY_USER" -p "$ENTITLED_REGISTRY_KEY"

            DOCKER_LOGIN=$(docker login "$ENTITLED_REGISTRY" -u "$ENTITLED_REGISTRY_USER" -p "$ENTITLED_REGISTRY_KEY" 2>&1)
            echo $DOCKER_LOGIN

            docker pull $ENTITLED_REGISTRY/cp/cp4mcm/synthetic-agent@sha256:c89ebd794dc97a557e56b5d7d9eeefde99bb48ec16f0cf79a2d2ddba93ef6d40

            DOCKER_PULL=$(docker pull $ENTITLED_REGISTRY/cp/cp4mcm/synthetic-agent@sha256:c89ebd794dc97a557e56b5d7d9eeefde99bb48ec16f0cf79a2d2ddba93ef6d40 2>&1)

            if [[ $DOCKER_PULL =~ "pull access denied" ]];
            then
                __output "❗   ERROR: Not entitled for Registry or not reachable"
                __output "           ❗ Aborting."
                exit 1
            else
                __output "      ✅ OK"
            fi
            __output ""
        }

        function checkClusterServiceBroker() {
            __output "   🔎 Check if ClusterServiceBroker exists on          $CLUSTER_NAME"
            CSB_RESOLVE=$(oc api-resources 2>&1)

            if [[ $CSB_RESOLVE =~ "servicecatalog.k8s.io" ]];
            then
                __output "      ✅ OK"
            else 
                __output "    ❗   ERROR: ClusterServiceBroker does not exist on Cluster '$CLUSTER_NAME'. ❌ Aborting."
                __output "      Install ClusterServiceBroker on OpenShift 4.2"
                __output "      https://docs.openshift.com/container-platform/4.2/applications/service_brokers/installing-service-catalog.html"
                __output "     "
                __output "      Updating 'Removed' to 'Managed'  "
                oc patch -n openshift-service-catalog-apiserver servicecatalogapiserver cluster --type=json -p '[{"op":"replace","path":"/spec/managementState","value":"Managed"}]'
                oc patch -n openshift-service-catalog-controller-manager servicecatalogcontrollermanager cluster --type=json -p '[{"op":"replace","path":"/spec/managementState","value":"Managed"}]'
                
                #oc get servicecatalogapiservers cluster -oyaml --export | sed -e '/status:/d' -e '/creationTimestamp:/d' -e '/selfLink: [a-z0-9A-Z/]\+/d' -e '/resourceVersion: "[0-9]\+"/d' -e '/phase:/d' -e '/uid: [a-z0-9-]\+/d'
                #oc get servicecatalogcontrollermanagers cluster -oyaml --export | sed -e '/status:/d' -e '/creationTimestamp:/d' -e '/selfLink: [a-z0-9A-Z/]\+/d' -e '/resourceVersion: "[0-9]\+"/d' -e '/phase:/d' -e '/uid: [a-z0-9-]\+/d'

                # oc apply -f ./tools/catalog_operator/ServiceCatalogAPIServer.yaml
                # oc apply -f ./tools/catalog_operator/ServiceCatalogControllerManager.yaml

                # waitForPod apiserver openshift-service-catalog-apiserver
                # waitForPod controller-manager openshift-service-catalog-controller-manager

                __output "      Or update manually 'Removed' to 'Managed'  "
                __output "        KUBE_EDITOR="nano" oc edit servicecatalogapiservers" 
                __output "        KUBE_EDITOR="nano" oc edit servicecatalogcontrollermanagers"
                exit 1
            fi
            __output ""
        }



SLEEP_DURATION=1

function progressbar {
  local duration
  local columns
  local space_available
  local fit_to_screen  
  local space_reserved

  space_reserved=6   # reserved width for the percentage value
  duration=${1}
  columns=$(tput cols)
  space_available=$(( columns-space_reserved ))

  if (( duration < space_available )); then 
  	fit_to_screen=1; 
  else 
    fit_to_screen=$(( duration / space_available )); 
    fit_to_screen=$((fit_to_screen+1)); 
  fi

  already_done() { for ((done=0; done<(elapsed / fit_to_screen) ; done=done+1 )); do printf "▇"; done }
  remaining() { for (( remain=(elapsed/fit_to_screen) ; remain<(duration/fit_to_screen) ; remain=remain+1 )); do printf " "; done }
  percentage() { printf "| %s%%" $(( ((elapsed)*100)/(duration)*100/100 )); }
  clean_line() { printf "\r"; }

  for (( elapsed=1; elapsed<=duration; elapsed=elapsed+1 )); do
      already_done; remaining; percentage
      sleep "$SLEEP_DURATION"
      clean_line
  done
  clean_line
  printf "\n";
}


        function checkHelmExecutable() {
            __output "   🔎 Check HELM Version (must be 3.x)"
            HELM_RESOLVE=$($HELM_BIN version 2>&1)

            if [[ $HELM_RESOLVE =~ "v3." ]];
            then
                __output "      ✅ OK"
            else 
                __output "    ❗   ERROR: Wrong Helm Version ($HELM_RESOLVE)"
                __output "       Trying 'helm3'"

                export HELM_BIN=helm3
                HELM_RESOLVE=$($HELM_BIN version 2>&1)

                if [[ $HELM_RESOLVE =~ "v3." ]];
                then
                    __output "      ✅ OK"
                else 
                    __output "    ❗   ERROR: Helm Version 3 does not exist in your Path"
                    __output "      Please install from https://cp-console.$CLUSTER_NAME/common-nav/cli?useNav=multicluster-hub-nav-nav"
                    __output "       or run"
                    __output "     curl -sL https://ibm.biz/idt-installer | bash"
                    __output "           ❗ Aborting."
                    exit 1
                fi
            fi
            __output ""
        }


        function checkCloudctlExecutable() {
            __output "   🔎 Check if cloudctl Command Line Tool is available"
            CLOUDCTL_RESOLVE=$(cloudctl 2>&1)

            if [[ $CLOUDCTL_RESOLVE =~ "USAGE" ]];
            then
                __output "      ✅ OK"
            else 
                __output "    ❗   ERROR: cloudctl Command Line Tool does not exist in your Path"
                __output "      Please install from https://cp-console.$CLUSTER_NAME/common-nav/cli?useNav=multicluster-hub-nav-nav"
                __output "       or run"
                __output "      curl -sL https://ibm.biz/idt-installer | bash"
                __output "           ❗ ❌ Aborting."
                exit 1
            fi
            __output ""
        }

  

        function checkHelmChartInstalled() {
            HELM_CHART=$1
            __output "   🔎 Check if Helm Chart '$HELM_CHART' is already installed"
            HELM_RESOLVE=$($HELM_BIN list $HELM_TLS 2>&1)

            if [[ $HELM_RESOLVE =~ $HELM_CHART ]];
            then
            __output "    ❗ ERROR: Helm Chart already installed"
            read -p "       UNINSTALL? [y,N]" DO_COMM
            if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; 
            then
                $HELM_BIN delete $HELM_CHART --purge $HELM_TLS
                __output "      ✅ OK"
            else
                __output "    ❗ ❌ Installation aborted"
                exit 2
            fi
            else 
            __output "      ✅ OK"
            fi
        } 
 
 

        function checkComponentNotInstalled() {
            COMPONENT=$1
            __output "   🔎 Check if Component '$COMPONENT' is already installed"

            if [[ $COMPONENT =~ "MCM" ]]; 
            then
                COMP_NAMESPACE="kube-system"
                COMP_LABEL_NAME="release=multicluster-hub"
                INSTALL_COMPONENT=$INSTALL_MCM
            fi


            if [[ $COMPONENT =~ "CAM" ]]; 
            then
                COMP_NAMESPACE="services"
                COMP_LABEL_NAME="release=$CAM_HELM_RELEASE_NAME"
                INSTALL_COMPONENT=$INSTALL_CAM
            fi

            if [[ $COMPONENT =~ "MIQ" ]]; 
            then
                COMP_NAMESPACE="manageiq"
                COMP_LABEL_NAME="app=manageiq"
                INSTALL_COMPONENT=$INSTALL_MIQ
            fi


            if [[ $COMPONENT =~ "APM" ]]; 
            then
                COMP_NAMESPACE="kube-system"
                COMP_LABEL_NAME="release=$APM_HELM_RELEASE_NAME"
                INSTALL_COMPONENT=$INSTALL_APM
            fi


            if [[ $COMPONENT =~ "LDAP" ]]; 
            then
                COMP_NAMESPACE="default"
                COMP_LABEL_NAME="app=openldap"
                INSTALL_COMPONENT=$INSTALL_LDAP
            fi

            if [[ $COMPONENT =~ "MCMREG" ]]; 
            then
                COMP_NAMESPACE="multicluster-endpoint"
                COMP_LABEL_NAME="app=service-registry "
                INSTALL_COMPONENT=$INSTALL_MCMREG
            fi

            if [[ $COMPONENT =~ "MCMMON" ]]; 
            then
                COMP_NAMESPACE="multicluster-endpoint"
                COMP_LABEL_NAME="app=mon "
                INSTALL_COMPONENT=$INSTALL_MCMMON
            fi

            if [[ $COMPONENT =~ "ANSIBLE" ]]; 
            then
                COMP_NAMESPACE="ansible-tower"
                COMP_LABEL_NAME="app=ansible-tower"
                INSTALL_COMPONENT=$INSTALL_ANSIBLE
            fi

            if [[ $COMPONENT =~ "TURBO" ]]; 
            then
                COMP_NAMESPACE="turbonomic"
                COMP_LABEL_NAME="app=ansible-tower"
                INSTALL_COMPONENT=$INSTALL_TURBO
            fi


            if [[ $INSTALL_COMPONENT == true ]]; 
            then
                NUM_FOUND=$(oc get pods -n $COMP_NAMESPACE -l $COMP_LABEL_NAME | grep -c "")

                if [[ $NUM_FOUND > 0 ]]; 
                then
                    __output "    Component '$COMPONENT' is already installed"
                    export MUST_INSTALL=0
                else
                    export MUST_INSTALL=1
                fi
            else
                export MUST_INSTALL=0
                __output "   🔧Component '$COMPONENT' is not selected for installation"
            fi
        } 



        function printComponentsInstall() {

            __output "     📦 CP4WAIOPS"

            __output "          ✅ 'CP4WAIOPS' will be installed with size: $WAIOPS_SIZE"
         

            __output ""
            __output "     📦 Humio"
            if [[ $INSTALL_HUMIO == true ]]; 
            then
                __output "          ✅ 'Humio' will be installed"
            else
                __output "          ⭕ 'Humio' will NOT be installed"

            fi

        
            __output ""
            __output "     📦 OpenLDAP"
            if [[ $INSTALL_LDAP == true ]]; 
            then
                __output "          ✅ 'OpenLDAP' will be installed"
            else
                __output "          ⭕ 'OpenLDAP' will NOT be installed"

            fi

            __output ""
            __output "     📦 Demo Apps"
            if [[ $INSTALL_DEMO == true ]]; 
            then
                __output "          ✅ 'Demo Apps' will be installed"
            else
                __output "          ⭕ 'Demo Apps' will NOT be installed"

            fi
        } 
 




        function checkComponentReady() {
            COMPONENT=$1

            if [[ $COMPONENT =~ "MCM" ]]; 
            then
                COMP_NAMESPACE="kube-system"
                COMP_LABEL_NAME="release=multicluster-hub"
                INSTALL_COMPONENT=$INSTALL_MCM
            fi


            if [[ $COMPONENT =~ "CAM" ]]; 
            then
                COMP_NAMESPACE="services"
                COMP_LABEL_NAME="release=$CAM_HELM_RELEASE_NAME"
                INSTALL_COMPONENT=$INSTALL_CAM
            fi

            if [[ $COMPONENT =~ "MIQ" ]]; 
            then
                COMP_NAMESPACE="manageiq"
                COMP_LABEL_NAME="app=manageiq"
                INSTALL_COMPONENT=$INSTALL_MIQ
            fi

            if [[ $COMPONENT =~ "APM" ]]; 
            then
                COMP_NAMESPACE="kube-system"
                COMP_LABEL_NAME="release=$APM_HELM_RELEASE_NAME"
                INSTALL_COMPONENT=$INSTALL_APM
            fi


            if [[ $COMPONENT =~ "LDAP" ]]; 
            then
                COMP_NAMESPACE="default"
                COMP_LABEL_NAME="app=openldap"
                INSTALL_COMPONENT=$INSTALL_LDAP
            fi

            if [[ $COMPONENT =~ "MCMREG" ]]; 
            then
                COMP_NAMESPACE="multicluster-endpoint"
                COMP_LABEL_NAME="app=service-registry "
                INSTALL_COMPONENT=$INSTALL_MCMREG
            fi


            if [[ $COMPONENT =~ "MCMMON" ]]; 
            then
                COMP_NAMESPACE="multicluster-endpoint"
                COMP_LABEL_NAME="app=mon "
                INSTALL_COMPONENT=$INSTALL_MCMMON
            fi


            if [[ $COMPONENT =~ "ANSIBLE" ]]; 
            then
                COMP_NAMESPACE="ansible-tower"
                COMP_LABEL_NAME="app=ansible-tower"
                INSTALL_COMPONENT=$INSTALL_ANSIBLE
            fi


            if [[ $INSTALL_COMPONENT == true ]]; 
            then
                NUM_FOUND=$(oc get pods -n $COMP_NAMESPACE -l $COMP_LABEL_NAME | grep -c "" || true )

                if [[ $NUM_FOUND > 0 ]]; 
                then
                    export MUST_INSTALL=0
                else
                    export MUST_INSTALL=1
                fi
            fi
        } 


        function checkAlreadyInstalled() {
            COMP_LABEL=$1
            COMP_NAMESPACE=$2

            NUM_FOUND=$(oc get pods -n $COMP_NAMESPACE -l $COMP_LABEL | grep -c "" || true )

            if [[ $NUM_FOUND > 0 ]]; 
            then
                export ALREADY_INSTALLED=1
            else
                export ALREADY_INSTALLED=0
            fi

        } 


    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
    # OUTPUT 
    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
       
       
       
        function header1Begin() {
            export INDENT="  "
            __output "  *****************************************************************************************************************************************"
            __output "  *****************************************************************************************************************************************"
            __output "  *****************************************************************************************************************************************"
            __output "  -----------------------------------------------------------------------------------------------------------------------------------------"
            __output "  🚀 $1"
            __output "  -----------------------------------------------------------------------------------------------------------------------------------------"
            __output "  "
        }


        function header1End() {
            __output "  "
            __output "  "
            __output "  -----------------------------------------------------------------------------------------------------------------------------------------"
            __output "  ✅ $1.... DONE"
            __output "  -----------------------------------------------------------------------------------------------------------------------------------------"
            __output "  -----------------------------------------------------------------------------------------------------------------------------------------"
            __output "  *****************************************************************************************************************************************"
            __output "  *****************************************************************************************************************************************"
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            __output "  "
            export INDENT=""
        }



        function header2Begin() {
            export INDENT="        "
            __output "  "
            __output "***********************************************************************************************************************************"
            __output "-----------------------------------------------------------------------------------------------------------------------------------"
            if [[ $2  == "magnifying" ]]; 
            then
                __output " 🔎 $1"
            elif [[ $2  == "eyes" ]]; 
            then
                __output " 👀 $1"
            else
                __output " 📥 $1"
            fi
            __output "-----------------------------------------------------------------------------------------------------------------------------------"

        }


        function header2End() {
            __output "-----------------------------------------------------------------------------------------------------------------------------------"
            __output "***********************************************************************************************************************************"
            __output "  "
            export INDENT=" "
        }


        function header3Begin() {
            export INDENT="         "
            __output "  "
            __output "*******************************************************************************************************************"
            __output "-------------------------------------------------------------------------------------------------------------------"
            if [[ $2  == "magnifying" ]]; 
            then
                __output " 🔎  $1"
            elif [[ $2  == "eyes" ]]; 
            then
                __output " 👀  $1"
            else
                __output " 🧰  $1"
            fi
            __output "-------------------------------------------------------------------------------------------------------------------"

        }


        function header3End() {
            __output "-------------------------------------------------------------------------------------------------------------------"
            __output "  "
            export INDENT="    "
        }



        function headerModuleFileBegin() {
            export INDENT="         "
            __output "****************************************************************************************************************************"
            __output " 🚚 $1                   $2"
            __output "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

        }

        function headerModuleFileEnd() {
            export INDENT="         "
            __output "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
            __output " 🚚 $1....Done            $2"
            __output "****************************************************************************************************************************"
            __output "  "
            __output "  "
            __output "  "
        }



    # ---------------------------------------------------------------------------------------------------------------------------------------------------"
    # Internal
    # ----^-----------------------------------------------------------------------------------------------------------------------------------------------"
        function waitForPod() {
            FOUND=1
            MINUTE=0
            podName=$1
            namespace=$2
            runnings="$3"
            __output "🕦 Wait for ${podName} to reach running state (4min)."
            while [ ${FOUND} -eq 1 ]; do
                # Wait up to 4min, should only take about 20-30s
                if [ $MINUTE -gt 240 ]; 
                then
                    __output "Timeout waiting for the ${podName}. Try cleaning up using the uninstall scripts before running again."
                    __output "List of current pods:"
                    oc -n ${namespace} get pods || true
                    echo
                    __output "You should see ${podName}, multiclusterhub-repo, and multicloud-operators-subscription pods"
                    exit 1
                fi

                operatorPod=`oc -n ${namespace} get pods | grep ${podName}`
              
                if [[ "$operatorPod" =~ "${running}     Running" ]]; 
                then
                    __output "* ${podName} is running"
                    break
                elif [ "$operatorPod" == "" ]; 
                then
                    operatorPod="Waiting"
                fi
                __output "* STATUS: $operatorPod"
                sleep 3
                (( MINUTE = MINUTE + 3 ))
            done
            printf "#####\n\n"
        }


        function waitForCPPassword() {
            FOUND=false
            COUNT=0
            MAX_COUNT=1000000
            __output "🕦   Waiting for CloudPak Common Services to initialize. ($COUNT/$MAX_COUNT)"
            while [[ ${FOUND} == "false" && $COUNT -lt $MAX_COUNT ]]; do
                TEMP_PWD=$(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d || true ) 

                if [[ $TEMP_PWD == "" ]]; 
                then
                    ((COUNT=COUNT+1))
                    __output "🕦   Waiting for CloudPak Route to initialize. ($COUNT/$MAX_COUNT)"
                    sleep 15
                else
                    __output "   DONE"
                    FOUND=true
                    export MCM_PWD=TEMP_PWD
                fi
            done
        }



        function waitForCPRoute() {
            FOUND=false
            COUNT=0
            MAX_COUNT=1000000
            __output "🕦   Waiting for CloudPak Common Services to initialize. ($COUNT/$MAX_COUNT)"
            while [[ ${FOUND} == "false" && $COUNT -lt $MAX_COUNT ]]; do
                TEMP_ROUTE=$(oc get route -n ibm-common-services cp-console -o jsonpath=‘{.spec.host}’ || true ) 

                if [[ $TEMP_ROUTE =~ "not found" ]]; 
                then
                    ((COUNT=COUNT+1))
                    __output "🕦   Waiting for CloudPak Route to initialize. ($COUNT/$MAX_COUNT)"
                    sleep 15
                else
                    __output "   DONE"
                    FOUND=true
                    export CS_SERVER=TEMP_ROUTE
                fi
            done
        }




        function waitForNSReady() {
            NAMESPACE=$1
            MAXCOUNT=$2    
            ACTCOUNT=0
            __output "🕦   Waiting for Namespace $NAMESPACE being ready."


            PODS_PENDING=$(oc get po -n $NAMESPACE | grep -v Running | grep -v Completed | grep -c "" || true)


            while  [[ $PODS_PENDING > 1 ]] && [[ $ACTCOUNT -lt $MAXCOUNT ]]; do 
                
                PODS_PENDING=$(oc get po -n $NAMESPACE | grep -v Running |grep -v Completed | grep -c "" || true)

                if [[ -z "$PODS_PENDING" ]]; then
                    PODS_PENDING=0
                    __output "${warning}  Namespace has no Pods..."
                fi

                ACTCOUNT=$((ACTCOUNT+1))
                __output "🕦   Still checking...  ❗ $PODS_PENDING in Namespace $NAMESPACE still not ready ready. Waiting for 5 seconds....($ACTCOUNT/$MAXCOUNT)"
                sleep 5
            done


            __output "   DONE";  
        }

        function waitForComponentReady() {
            COMP=$1
            MAXCOUNT=$2    
            ACTCOUNT=0
            __output "🕦   Waiting for Component $COMP being ready."

            checkComponentReady $COMP
            while  [[ $MUST_INSTALL > 0 ]] || [[ $ACTCOUNT -lt $MAXCOUNT ]]; do 
                checkComponentReady $COMP
                ACTCOUNT=$((ACTCOUNT+1))
                __output "🕦   Still checking for Component $COMP being ready ($ACTCOUNT/$MAXCOUNT). Waiting for 15 seconds...."
                sleep 15
            done


            __output "   DONE";  
        }




        function waitForCPReady() {
            NAMESPACE=$1
            MAXCOUNT=$2    
            ACTCOUNT=0
            __output "🕦   Waiting for CloudPak for Multicloud Management in Namespace $NAMESPACE being ready."


            PODS_PENDING=$(oc get po -n $NAMESPACE | grep -v Running | grep -v Completed | grep -c "" || true)


            while  [[ $PODS_PENDING > 1 ]] && [[ $ACTCOUNT -lt $MAXCOUNT ]]; do 
                
                PODS_PENDING=$(oc get po -n $NAMESPACE | grep -v Running |grep -v Completed | grep -c "" || true)

                if [[ -z "$PODS_PENDING" ]]; then
                    PODS_PENDING=0
                    __output "${warning}  Namespace has no Pods..."
                fi

                ACTCOUNT=$((ACTCOUNT+1))
                __output "🕦   Still checking...  ❗ $PODS_PENDING in Namespace $NAMESPACE still not ready ready. Waiting for 5 seconds....($ACTCOUNT/$MAXCOUNT)"
                sleep 5
            done


            __output "   DONE";  
        }



        function waitForPodsReady() {
            NAMESPACE=$1
            __output "🕦   Waiting for Pods running in Namespace $NAMESPACE."

           podsPending $NAMESPACE
            
            while  [[ $PODS_NOT_RUNNING_COUNT > 0 ]]; do 
                podsPending $NAMESPACE
                __output "   🕦 There are still ❗ $PODS_NOT_RUNNING_COUNT Pods not running. Waiting for 10 seconds...." && sleep 10; 
            done
            sleep 10

            __output "   DONE";  
        }




        function waitForPodsReadyLabel() {
            NAMESPACE=$1
            LABEL=$2
            __output "   🕦 Waiting for Pods running in Namespace $NAMESPACE and with Label $LABEL."

            podsPendingLabel $NAMESPACE $LABEL
            while  [[ $PODS_NOT_RUNNING_COUNT > 0 ]]; do 
                podsPendingLabel $NAMESPACE $LABEL
                __output "   🕦 There are still ❗ $PODS_NOT_RUNNING_COUNT Pods not running. Waiting for 10 seconds...." && sleep 10; 
            done

            __output "   DONE";  
        }



        function podsPending() {
            NAMESPACE=$1
            PODS_PENDING=$(oc get pods --field-selector=status.phase=Pending -n $NAMESPACE | grep -c "" || true )
            if [[ "$PODS_PENDING" == "" ]]; then
                PODS_PENDING=0
            fi
            PODS_STATE=$(oc get pods -n $NAMESPACE | grep -E "Crash|Creat" | grep -c "" || true )
            if [[ "$PODS_STATE" == "" ]]; then
                PODS_STATE=0
            fi

            PODS_NOT_RUNNING_COUNT=$((PODS_PENDING+PODS_STATE))
        }


        function podsPendingLabel() {
            NAMESPACE=$1
            PODS_PENDING=$(oc get pods -l $LABEL --field-selector=status.phase=Pending -n $NAMESPACE | grep -c "" || true )
            if [[ "$PODS_PENDING" == "" ]]; then
                PODS_PENDING=0
            fi
            PODS_STATE=$(oc get pods -l $LABEL -n $NAMESPACE | grep -E "Crash|Creat" | grep -c "" || true )
            if [[ "$PODS_STATE" == "" ]]; then
                PODS_STATE=0
            fi

            PODS_NOT_RUNNING_COUNT=$((PODS_PENDING+PODS_STATE))
        }

##########################################################
# Shamelessly stolen from XIANQUAN ZHENG
# https://github.ibm.com/Bright-Zheng/cp4mcm-automation-scripts/blob/master/02-tools.sh
##########################################################

check_and_install_jq() {
    __output "   🔎 Check if jq is installed"
    if [ -x "$(command -v jq)" ]; then
        __output "      ✅ OK"
    else
        __output "      WARNING: jq is not installed. Installing it now"
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            brew install jq >/dev/null;
        else
            sudo yum install epel-release -y
            sudo yum install jq -y
        fi
    fi
    __output ""
}

check_and_install_cloudctl() {
    __output "   🔎 Check if cloudctl is installed"
    if [ -x "$(command -v cloudctl)" ]; then
        __output "      ✅ OK"
    else
        __output "      WARNING: cloudctl is not installed. Installing it now"
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            curl --silent --show-error -kLo cloudctl-darwin-amd64 "https://${CLUSTER_NAME}:443/api/cli/cloudctl-darwin-amd64" \
                && chmod +x cloudctl-darwin-amd64 \
                && sudo mv cloudctl-darwin-amd64 /usr/local/bin/cloudctl
        else
            curl --silent --show-error -kLo cloudctl-linux-amd64 "https://${CLUSTER_NAME}:443/api/cli/cloudctl-linux-amd64" \
                && chmod +x cloudctl-linux-amd64 \
                && sudo mv cloudctl-linux-amd64 /usr/local/bin/cloudctl
        fi
    fi
    __output ""
}

check_and_install_kubectl() {
    __output "   🔎 Check if kubectl is installed"
    if [ -x "$(command -v kubectl)" ]; then
        __output "      ✅ OK"
    else
        __output "      WARNING: oc is not installed. Installing it now"
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            curl --silent --show-error -kLo kubectl-darwin-amd64 "https://${CLUSTER_NAME}:443/api/cli/kubectl-darwin-amd64" \
                && chmod +x kubectl-darwin-amd64 \
                && sudo mv kubectl-darwin-amd64 /usr/local/bin/kubectl
        else
            curl --silent --show-error -kLo kubectl-linux-amd64 "https://${CLUSTER_NAME}:443/api/cli/kubectl-linux-amd64" \
                && chmod +x kubectl-linux-amd64 \
                && sudo mv kubectl-linux-amd64 /usr/local/bin/kubectl
        fi
    fi
    __output ""
}

check_and_install_oc() {
    __output "   🔎 Check if oc is installed"
    if [ -x "$(command -v oc)" ]; then
        __output "      ✅ OK"
    else
        __output "      WARNING: oc is not installed. Installing it now"
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            curl --silent --show-error -kLo oc-darwin-amd64 "https://${CLUSTER_NAME}:443/api/cli/oc-darwin-amd64" \
                && chmod +x oc-darwin-amd64 \
                && sudo mv oc-darwin-amd64 /usr/local/bin/oc
        else
            curl --silent --show-error -kLo oc-linux-amd64 "https://${CLUSTER_NAME}:443/api/cli/oc-linux-amd64" \
                && chmod +x oc-linux-amd64 \
                && sudo mv oc-linux-amd64 /usr/local/bin/oc
        fi
    fi
    __output ""
}

check_and_install_helm() {
    __output "   🔎 Check if helm 3 is installed"
    if [ -x "$(command -v helm)" ]; then
        __output "      ✅ OK"
    else
        __output "      WARNING: helm3 is not installed. Installing it now"
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            curl --silent --show-error -kLo helm-darwin-amd64.tar.gz "https://${CLUSTER_NAME}:443/api/cli/helm-darwin-amd64.tar.gz" \
                && tar -xf helm-darwin-amd64.tar.gz --strip-components 1 darwin-amd64/helm \
                && chmod +x helm \
                && mv helm /usr/local/bin \
                && rm helm-darwin-amd64.tar.gz
        else
            curl --silent --show-error -kLo helm-linux-amd64.tar.gz "https://${CLUSTER_NAME}:443/api/cli/helm-linux-amd64.tar.gz" \
                && tar -xf helm-linux-amd64.tar.gz --strip-components 1 linux-amd64/helm \
                && chmod +x helm \
                && mv helm /usr/local/bin && rm helm-linux-amd64.tar.gz
        fi
    fi
    __output ""
}

check_and_install_yq() {
    __output "   🔎 Check if yq is installed"
    if [ -x "$(command -v yq)" ]; then
        __output "      ✅ OK"
    else

        if [[ "${OSTYPE}" == "darwin"* ]]; then
            __output "      WARNING: yq is not installed. Installing it now"
            brew install yq
        else
            __output "      WARNING: yq is not installed. Please install it and restart the script."
            __output "    ❌ Aborting"
            exit 1
        fi
    fi
    __output ""
}
