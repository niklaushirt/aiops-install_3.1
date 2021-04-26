
export ASM_USER=aimanager-topology-aiops-user
export ASM_PWD=$(kubectl get secret evtmanager-topology-asm-credentials -n $WAIOPS_NAMESPACE -o=template --template={{.data.password}} | base64 -D)



## MERGE CREATE
curl -X "POST" "https://topology-merge-aiops.demo31-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/1.0/merge/rules?ruleType=matchTokensRule" --insecure \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'content-type: application/json' \
     -u '$ASM_USER:$ASM_PWD' \
     -d $'{
  "tokens": [
    "name"
  ],
  "entityTypes": [
    "deployment"
  ],
  "providers": [
    "*"
  ],
  "observers": [
    "*"
  ],
  "ruleType": "mergeRule",
  "name": "merge-name-type",
  "ruleStatus": "enabled"
}'



curl "https://topology-merge-aiops.demo31-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/1.0/merge/rules?ruleType=mergeRule&_include_count=false&_field=*" --insecure \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -u '$ASM_USER:$ASM_PWD'




