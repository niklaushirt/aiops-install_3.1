# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Installing Script for all CP4WAIOPS V3.1.1 components
#
# V3.1.1 
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
__output "  "
__output "  CloudPak for Watson AI OPS V3.1.1"
__output "  "
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


# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# GET PARAMETERS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header2Begin "Input Parameters" "magnifying"



        while getopts "t:d:p:l:c:" opt
        do
          case "$opt" in
              t ) INPUT_TOKEN="$OPTARG" ;;
              d ) INPUT_PATH="$OPTARG" ;;
              p ) INPUT_PWD="$OPTARG" ;;
              l ) INPUT_LDAPPWD="$OPTARG";;
          esac
        done



        if [[ $INPUT_TOKEN == "" ]];
        then
            __output "       ERROR: Please provide the Registry Token"
            __output "       USAGE: $0 -t <REGISTRY_TOKEN> [-s <STORAGE_CLASS> -l <LDAP_ADMIN_PASSWORD> -d <TEMP_DIRECTORY>]"
            exit 1
        else
            __output "       🔐  Token                     Provided"
            export ENTITLED_REGISTRY_KEY=$INPUT_TOKEN
        fi


        if [[ $INPUT_PATH == "" ]];
        then
            __output "       #️⃣   No Path provided, using   $TEMP_PATH"
        else
            __output "       #️⃣   Temp Path      $INPUT_PATH"
            export TEMP_PATH=$INPUT_PATH
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
        check_oc
        check_helm
        checkHelmExecutable
        checkOpenshiftReachable
        checkKubeconfigIsSet
        check_jq
        check_kafkacat
        check_elasticdump
        check_cloudctl

        

header2End




header2Begin "CloudPak for Watson AI OPS  V3.1.1 (CP4WAIOPS) will be installed in Cluster '$CLUSTER_NAME'"

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# CONFIG SUMMARY
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
__output "       ---------------------------------------------------------------------------------------------------------------------"
__output "       🔍 Your configuration"
__output "       ---------------------------------------------------------------------------------------------------------------------"
__output "       🎛  CLUSTER :                  $CLUSTER_NAME"
__output "       🔐 REGISTRY TOKEN:            provided"
__output "       🛰 AI Manager NAMESPACE:       $WAIOPS_NAMESPACE"
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




header2Begin "CloudPak for Watson AI OPS  V3.1.1 (CP4WAIOPS) will be installed with the following features:"
printComponentsInstall
header2End

header1End "Initializing"


# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Installing Operators
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

header1Begin "Install Prerequisites"
  

        header2Begin "Storage Checks"

            checkStorageClassExists
            checkDefaultStorageDefined

        header2End


        header2Begin "Restart OCP Image Registry" 
            if [[ $CLUSTER_NAME =~ "appdomain.cloud" ]];
            then 
                 __output "     ⭕ You are on ROKS... Skipping"
            else
                oc delete pod -n openshift-image-registry $(oc get po -n openshift-image-registry|grep image-registry|awk '{print$1}') >$log_output_path 2>&1 
                __output "      ✅ OK"
            fi


        header2End


        header2Begin "Install Operators" 

            header3Begin "Patch OCP Registry"    
                oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge >$log_output_path 2>&1
                __output "      ✅ OK"
            header3End



            header3Begin "Create Namespace $WAIOPS_NAMESPACE"    
                oc create ns $WAIOPS_NAMESPACE >$log_output_path 2>&1 || true 
                __output "      ✅ OK"
            header3End



            header3Begin "Create Pull Secret"
                oc create secret docker-registry 'ibm-entitlement-key' --docker-server=$ENTITLED_REGISTRY --docker-username=$ENTITLED_REGISTRY_USER --docker-password=$ENTITLED_REGISTRY_KEY --namespace=$WAIOPS_NAMESPACE >$log_output_path 2>&1 || true 
                #oc create secret docker-registry custom-pull-secret --docker-server=hyc-katamari-cicd-team-docker-local.artifactory.swg-devops.com --docker-username=<user_id> --docker-password=<artifactory_token>
                #oc create secret generic ibm-entitlement-key --from-file=.dockercfg=./yaml/waiops/secret.json --type=kubernetes.io/dockercfg
                __output "      ✅ OK"
            header3End


            header3Begin "Patch builder service account"
                INTERNAL=$(oc get secret -n $WAIOPS_NAMESPACE | grep '^builder-dockercfg' | cut -f1 -d ' ')
                BASE=$(oc get secret ibm-entitlement-key -n $WAIOPS_NAMESPACE -o json | jq ".data[]" | sed -e 's/^"//' -e 's/"$//' | base64 -d | sed -e 's/}}$/,/')
                ADDITIONAL=$(oc get secret $INTERNAL -n $WAIOPS_NAMESPACE -o json | jq ".data[]" | sed -e 's/^"//' -e 's/"$//' | base64 -d | sed -e 's/^{//')
                echo $BASE$ADDITIONAL} > builder-secret.tmp
                oc create secret generic merged-secret --type=kubernetes.io/dockerconfigjson --from-file=.dockerconfigjson=builder-secret.tmp -n $WAIOPS_NAMESPACE || true
                rm builder-secret.tmp
                oc patch serviceaccount builder  -p '{"secrets": [{"name": "merged-secret"}]}' -n $WAIOPS_NAMESPACE || true
            header3End




            header3Begin "Adjust OCP Stuff"
                oc adm policy add-role-to-user cpd-admin-role $(oc whoami) --role-namespace=$WAIOPS_NAMESPACE -n $WAIOPS_NAMESPACE >$log_output_path 2>&1
                oc project $WAIOPS_NAMESPACE >$log_output_path 2>&1
                __output "      ✅ OK"
            header3End







            header3Begin "Install IBM Operator Catalog"

                CATALOG_INSTALLED=$(oc get -n openshift-marketplace CatalogSource ibm-operator-catalog -o yaml | grep "lastObservedState: READY" || true) 

                if [[ $CATALOG_INSTALLED =~ "READY" ]]; 
                then
                    __output "     ⭕ CatalogSource already installed... Skipping"
                else
                    oc apply -f ./yaml/waiops/cat-ibm-operator.yaml >$log_output_path 2>&1
                    __output "      ✅ OK"
                fi
            header3End



            header3Begin "Install IBM AIOps Catalog"

                CATALOG_INSTALLED=$(oc get -n openshift-marketplace CatalogSource ibm-aiops-catalog -o yaml | grep "lastObservedState: READY" || true) 

                if [[ $CATALOG_INSTALLED =~ "READY" ]]; 
                then
                    __output "     ⭕ CatalogSource already installed... Skipping"
                else
                    oc apply -f ./yaml/waiops/cat-ibm-aiops.yaml >$log_output_path 2>&1

                        #__output " 🔧 Restart Marketplace (HACK)"
                        #oc delete pod -n openshift-marketplace -l name=marketplace-operator 2>&1
                    __output "      ✅ OK"
                    __output "  "

                    #progressbar 60
                fi
            header3End


            header3Begin "Install IBM Common Services Catalog"

                CATALOG_INSTALLED=$(oc get -n openshift-marketplace CatalogSource ibm-aiops-catalog -o yaml | grep "lastObservedState: READY" || true) 

                if [[ $CATALOG_INSTALLED =~ "READY" ]]; 
                then
                    __output "     ⭕ CatalogSource already installed... Skipping"
                else
                    oc apply -f ./yaml/waiops/cat-ibm-common-services.yaml >$log_output_path 2>&1

                    __output "      ✅ OK"
                    __output "  "

                    #progressbar 60
                fi
            header3End



            header3Begin "AI OPS - Install Subscription"

                SUB_INSTALLED=$(oc get -n openshift-operators subscriptions.operators.coreos.com ibm-aiops-orchestrator -o yaml | grep "state: AtLatestKnown" || true) 

                if [[ $SUB_INSTALLED =~ "AtLatestKnown" ]]; 
                then
                    __output "     ⭕ Subscription already installed... Skipping"
                else
                    oc apply -n openshift-operators -f ./yaml/waiops/sub-ibm-aiops-orchestrator.yaml >$log_output_path 2>&1 || true
                    #progressbar 120
                    
                    __output "      ✅ OK"
                fi

            header3End
        header2End




        header2Begin "Install Strimzi"
  
            header3Begin "AI OPS - Create Subscription for Strimzi"
                CPD_SUB=$(oc get subscriptions.operators.coreos.com -n openshift-operators | grep strimzi-kafka-operator 2>&1 ) || true
                if [[ $CPD_SUB =~ "strimzi-kafka-operator" ]];
                then
                    __output "     ⭕ Strimzi Subscription already installed. Skipping..."
                else
                    oc apply -f ./yaml/strimzi/strimzi-subscription.yaml 2>&1  || true
                
                    __output "      ✅ OK"

                fi

                oc label --overwrite namespace $WAIOPS_NAMESPACE ns=$WAIOPS_NAMESPACE >$log_output_path 2>&1  || true

            header3End
        header2End 



        header2Begin "Install Knative"
  
            header3Begin "Create Namespace knative-serving"    
                oc create ns knative-serving >$log_output_path 2>&1 || true
                __output "      ✅ OK"
            header3End


            header3Begin "Create Namespace knative-eventing"    
                oc create ns knative-eventing >$log_output_path 2>&1 || true
                __output "      ✅ OK"
            header3End

            header3Begin "Create Namespace openshift-serverless"    
                oc create ns openshift-serverless >$log_output_path 2>&1 || true
                __output "      ✅ OK"
            header3End


            header3Begin "Install Knative Subscription"

                SUB_INSTALLED=$(oc get -n openshift-serverless subscriptions.operators.coreos.com serverless-operator -o yaml | grep "state: AtLatestKnown" || true) 

                if [[ $SUB_INSTALLED =~ "AtLatestKnown" ]]; 
                then
                    __output "     ⭕ Subscription already installed... Skipping"
                else
                    oc apply --namespace=openshift-serverless -f ./yaml/knative/knative-subscription.yaml || true
                    #progressbar 120
                    SUB_INSTALLED=$(oc get -n openshift-serverless subscriptions.operators.coreos.com serverless-operator -o yaml | grep "state: AtLatestKnown" || true) 
                    while  ([[ ! $SUB_INSTALLED =~ "AtLatestKnown" ]]); do 
                        SUB_INSTALLED=$(oc get -n openshift-serverless subscriptions.operators.coreos.com serverless-operator -o yaml | grep "state: AtLatestKnown" || true) 
                        __output "   🕦 The Knative Subscriptions is not ready. Waiting for 10 seconds...." && sleep 10; 
                    done

                    __output "      ✅ OK"
                fi

            header3End


            header3Begin "AI OPS - Create Knative Serving"
                CPD_SUB=$(oc get KnativeServing -n knative-serving | grep knative-serving 2>&1 ) || true
                if [[ $CPD_SUB =~ "knative-serving" ]];
                then
                    __output "     ⭕ Knative Serving already installed... Skipping"
                else
                    oc apply -n knative-serving -f ./yaml/knative/knative-serving.yaml
                     __output "      ✅ OK"
                fi

            header3End



            header3Begin "AI OPS - Create Knative Eventing"
                CPD_SUB=$(oc get KnativeEventing -n knative-eventing | grep knative-eventing 2>&1 ) || true
                if [[ $CPD_SUB =~ "knative-eventing" ]];
                then
                    __output "     ⭕ Knative Eventing  already installed... Skipping"
                else
                    oc apply -n knative-eventing -f ./yaml/knative/knative-eventing.yaml
                    oc annotate service.serving.knative.dev/kn-cli -n knative-serving serving.knative.openshift.io/disableRoute=true >$log_output_path 2>&1 || true

                    __output "      ✅ OK"
                fi

            header3End

                  

        header2End 


header1End "Install Prerequisites"




header1Begin "Waiting for Prerequisites to be ready"

    SUCCESFUL_SUBS=$(oc get -n openshift-operators ClusterServiceVersion | grep Succeeded | wc -l || true)
    __output "      ℹ️  Found $SUCCESFUL_SUBS in Ready state";
    __output "";

    SUCCESFUL_SUBS_TARGET=9

    while  ([[ $SUCCESFUL_SUBS -lt $SUCCESFUL_SUBS_TARGET ]]); do 
        SUCCESFUL_SUBS=$(oc get -n openshift-operators ClusterServiceVersion | grep Succeeded | wc -l || true)
        __output "            🕦 There are still Subscriptions that are not ready $SUCCESFUL_SUBS/$SUCCESFUL_SUBS_TARGET. Waiting for 10 seconds...." && sleep 10; 
    done

    __output "";
    __output "      ✅  Continuing..."
header1End "Waiting for Prerequisites to be ready"


# oc get catalogsource ibm-aiops-catalog -n openshift-marketplace  -o jsonpath='{.status.connectionState.lastObservedState}'


# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install WAIOPS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

header1Begin "Install CP4WAIOPS"

     
    AI_MANAGER_INSTALLED=$(oc get -n $WAIOPS_NAMESPACE installations.orchestrator.aiops.ibm.com ibm-aiops -o yaml | grep "phase: Running" || true) 

    if [[ $AI_MANAGER_INSTALLED =~ "Running" ]]; 
    then
        __output "     ⭕ CP4WAIOPS already installed... Skipping"
    else
        
        header3Begin "CP4WAIOPS - Create Template Files"
            cp ./yaml/waiops/waiops-install-template.yaml $TEMP_PATH/$CLUSTER_NAME/$0/waiops-install.yaml
            ${SED} -i "s/<STORAGE_CLASS>/$WAIOPS_STORAGE_CLASS_FILE/" $TEMP_PATH/$CLUSTER_NAME/$0/waiops-install.yaml
            ${SED} -i "s/<STORAGE_CLASS_LB>/$WAIOPS_STORAGE_CLASS_LARGE_BLOCK/" $TEMP_PATH/$CLUSTER_NAME/$0/waiops-install.yaml
            ${SED} -i "s/<NAME>/$WAIOPS_NAME/" $TEMP_PATH/$CLUSTER_NAME/$0/waiops-install.yaml
            ${SED} -i "s/<NAMESPACE>/$WAIOPS_NAMESPACE/" $TEMP_PATH/$CLUSTER_NAME/$0/waiops-install.yaml
            ${SED} -i "s/<ENV_SIZE>/$WAIOPS_SIZE/" $TEMP_PATH/$CLUSTER_NAME/$0/waiops-install.yaml

            __output "      ✅ OK"

        header3End



        header3Begin "Install CP4WAIOPS CR"
            oc apply -f $TEMP_PATH/$CLUSTER_NAME/$0/waiops-install.yaml || true
            __output "      ✅ OK"
        header3End


    fi


header1End "Install CP4WAIOPS"



__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output " ✅ CP4WAIOPS Base Elements Installed"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output " 🚀 Launching Post Install"
__output "  If there are any errors it is safe to relaunch this script manually (./11_postinstall_aiops.sh)"
__output ""
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"


./11_postinstall_aiops.sh


__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output " ✅ CP4WAIOPSInstalled"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "***************************************************************************************************************************************************"
__output "***************************************************************************************************************************************************"



