# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Install Script for Turbonomic
#
# V3.1.1
#
# https://github.com/turbonomic/t8c-install/wiki/4.-Turbonomic-Multinode-Deployment-Steps
# https://github.com/turbonomic/t8c-install/wiki/Platform-Provided-Ingress-&-OpenShift-Routes
#
# ©2021 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

source ./tools/0_global/99_config-global.sh
__getClusterFQDN
__getInstallPath

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

#headerModuleFileBegin "Install Turbonomic " $0
if  ([[  $STORAGE_CLASS_TURBO == "" ]]); 
then 
    echo "      ⭕ Turbonomic Storage Class not defined. Aborting....";
    exit 1 
else
    echo "      ✅ OK: Turbonomic Storage Class: $STORAGE_CLASS_TURBO"; 

fi

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# INSTALL CHECKS
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
header3Begin "Install Turbonomic"


        getInstallPath


        checkAlreadyInstalled app=Turbonomic default
        if [[ $ALREADY_INSTALLED == 1 ]];
        then
            __output "    ⭕ Turbonomic already installed! Skipping..."

            #headerModuleFileEnd "Install Open LDAP " $0
            exit 0
        else
            __output "      ✅ OK"
        fi

header3End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PREREQUISITES
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Running Prerequisites" "rocket"

        export SCRIPT_PATH=$(pwd)
        __output "      ✅ OK"

header3End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install Turbonomic
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Install Turbonomic" "rocket"


      __output "Install Turbonomic"

        cp ./yaml/turbonomic/my-turbo-instance.yaml $TEMP_PATH/$CLUSTER_NAME/$0/my-turbo-instance.yaml
        ${SED} -i "s/<STORAGE_CLASS_TURBO>/$STORAGE_CLASS_TURBO/" $TEMP_PATH/$CLUSTER_NAME/$0/my-turbo-instance.yaml

        oc create ns turbonomic
        oc adm policy add-scc-to-group anyuid system:serviceaccounts:turbonomic
        oc create clusterrolebinding turbonomic-admin --clusterrole=cluster-admin --serviceaccount=turbonomic:t8c-operator
        oc create clusterrolebinding turbonomic-admin --clusterrole=cluster-admin --serviceaccount=turbonomic:turbo-user

        oc create -f ./yaml/turbonomic/service_account.yaml -n turbonomic
        oc create -f ./yaml/turbonomic/role.yaml -n turbonomic
        oc create -f ./yaml/turbonomic/role_binding.yaml -n turbonomic
        oc create -f ./yaml/turbonomic/crds/charts_v1alpha1_xl_crd.yaml
        oc create -f ./yaml/turbonomic/operator.yaml -n turbonomic




        oc apply -f $TEMP_PATH/$CLUSTER_NAME/$0/my-turbo-instance.yaml -n turbonomic


        __output "      ✅ Turbonomic Installed"
header3End



exit 1
# Delete Turbonomic

oc delete -f ./yaml/turbonomic/crds/charts_v1alpha1_xl_cr.yaml -n turbonomic

oc delete -f ./yaml/turbonomic/service_account.yaml -n turbonomic
oc delete -f ./yaml/turbonomic/role.yaml -n turbonomic
oc delete -f ./yaml/turbonomic/role_binding.yaml -n turbonomic
oc delete -f ./yaml/turbonomic/crds/charts_v1alpha1_xl_crd.yaml
oc delete -f ./yaml/turbonomic/operator.yaml -n turbonomic
oc delete clusterrolebinding turbonomic-admin -n turbonomic

oc delete secret -n turbonomic $(oc get secret -n turbonomic|grep turbo-user-|awk '{print$1}')

# # oc delete ns turbonomic

