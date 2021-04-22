# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Install Script for Open LDAP Registration
#
# V3.1 
#
# ©2021 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

source ./99_config-global.sh

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

headerModuleFileBegin "Register LDAP Users in Common Services " $0



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# INSTALL
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Register LDAP Users in Common Services"


        getClusterFQDN
        CS_SERVER=https://cp-console.$CLUSTER_NAME

        BASE_DN="dc="$(echo $LDAP_DOMAIN | ${SED} -e "s/\./,dc=/")
        BIND_DN="cn=admin,"$BASE_DN

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output " Login to PHP LDAP Admin"
        __output "   GUI is here: http://openldap-admin-default.$CLUSTER_NAME"
        __output ""


        __output "   LDAP Admin User: $BIND_DN"
        __output "   LDAP Admin Password: $LDAP_ADMIN_PASSWORD"
        __output ""
        __output ""
        __output ""
        __output ""



        CS_PWD=$(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d)
        export SPOKE_CONTEXT=$(kubectl config current-context)

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output "    🛠️ Common Services Login"
        #echo cloudctl login -a ${CS_SERVER} --skip-ssl-validation -u ${MCM_USER} -p ${CS_PWD} -n kube-system
        cloudctl login -a ${CS_SERVER} --skip-ssl-validation -u admin -p ${CS_PWD} -n kube-system


        ALREADY_INSTALLED=$(cloudctl iam users | grep demo)
        if [[ $ALREADY_INSTALLED =~ "demo" ]];
        then
            __output "    ❌LDAP isers already registered! Skipping..."
            #exit 0
        fi


        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output "    🛠️ Creating LDAP Connection"
        #echo         cloudctl iam ldap-create "LDAP" --basedn "$BASE_DN" --server "ldap://openldap.default:389" --binddn "$BIND_DN" --binddn-password "$LDAP_ADMIN_PASSWORD" -t "Custom" --group-filter "(&(cn=%v)(objectclass=groupOfUniqueNames))" --group-id-map "*:cn" --group-member-id-map "groupOfUniqueNames:uniqueMember" --user-filter "(&(uid=%v)(objectclass=Person))" --user-id-map "*:uid"

        cloudctl iam ldap-create "LDAP" --basedn "$BASE_DN" --server "ldap://openldap.default:389" --binddn "$BIND_DN" --binddn-password "$LDAP_ADMIN_PASSWORD" -t "Custom" --group-filter "(&(cn=%v)(objectclass=groupOfUniqueNames))" --group-id-map "*:cn" --group-member-id-map "groupOfUniqueNames:uniqueMember" --user-filter "(&(uid=%v)(objectclass=Person))" --user-id-map "*:uid"
        TEAM_ID=$(cloudctl iam teams | awk '{print $1}' | grep zen)  # | sed -n 2p)

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output "    🛠️ Import Users"
        cloudctl iam user-import -u demo -f
        cloudctl iam user-import -u dev -f
        cloudctl iam user-import -u test -f
        cloudctl iam user-import -u prod -f
        cloudctl iam user-import -u boss -f
        cloudctl iam user-import -u nik -f
        cloudctl iam user-import -u sre1 -f
        cloudctl iam user-import -u sre2 -f

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output "    🛠️ Assign Users to Team"
        cloudctl iam team-add-users $TEAM_ID ClusterAdministrator -u demo
        cloudctl iam team-add-users $TEAM_ID Administrator -u dev
        cloudctl iam team-add-users $TEAM_ID Administrator -u test
        cloudctl iam team-add-users $TEAM_ID Administrator -u prod
        cloudctl iam team-add-users $TEAM_ID ClusterAdministrator -u boss    
        cloudctl iam team-add-users $TEAM_ID ClusterAdministrator -u nik
        cloudctl iam team-add-users $TEAM_ID ClusterAdministrator -u sre1
        cloudctl iam team-add-users $TEAM_ID ClusterAdministrator -u sre2

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output "    🛠️ Add LDAP Resource"
        cloudctl iam resource-add $TEAM_ID -r crn:v1:icp:private:iam::::Directory:LDAP

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output "    🛠️ Add Namespace Resources"
        cloudctl iam resource-add $TEAM_ID -r crn:v1:icp:private:k8:mycluster:n/default:::
        cloudctl iam resource-add $TEAM_ID -r crn:v1:icp:private:k8:mycluster:n/aiops:::



header3End

headerModuleFileEnd "Register LDAP Users in Common Services " $0

