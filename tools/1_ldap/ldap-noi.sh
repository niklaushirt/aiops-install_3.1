oc delete secret evtmanager-ldap-secret -n cp4waiops
oc create secret generic evtmanager-ldap-secret -n cp4waiops  --from-literal='LDAP_BIND_PASSWORD=P4ssw0rd!'

