
oc get navconfigurations.foundation.ibm.com multicluster-hub-nav -n kube-system -o yaml > navconfigurations.orginal
cp navconfigurations.orginal navconfigurations.ldap.yaml
nano navconfigurations.ldap.yaml

Add this (don't forget to change the URL)

  - id: id-ldap
    label: OpenLDAP Admin
    parentId: administer-mcm
    serviceId: webui-nav
    target: _blank
    url: http://openldap-admin-default.cp4mcp-demo-002-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/




oc apply -n kube-system --validate=false -f navconfigurations.ldap.yaml  


