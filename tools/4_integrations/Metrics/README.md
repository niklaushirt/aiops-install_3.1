https://www-03preprod.ibm.com/support/knowledgecenter/SSTPTP_1.6.3_test/com.ibm.netcool_ops.doc/soc/integration/task/metricsingestions.html




export HTTP_SERVER=netcool-evtmanager.dteroks-270003bu3k-c7azm-4b4a324f027aea19c5cbc0c3275c4656-0000.eu-gb.containers.appdomain.cloud

export HTTP_PASSWORD=$(kubectl get secret evtmanager-systemauth-secret -o jsonpath --template '{.data.password}' | base64 --decode)
export HTTP_USERNAME=$(kubectl get secret evtmanager-systemauth-secret -o jsonpath --template '{.data.username}')


curl -X GET --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' "https://$HTTP_SERVER/metrics/api/1.0/metrics" -u "${HTTP_USERNAME}:${HTTP_PASSWORD}" --insecure

curl -X POST --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255; Content-Type: application/json; charset=utf-8' "https://$HTTP_SERVER/metrics/api/1.0/metrics" -u "${HTTP_USERNAME}:${HTTP_PASSWORD}" -d "data=@./tools/4_integrations/Metrics/test-data.json" --insecure 

curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -u "${HTTP_USERNAME}:${HTTP_PASSWORD}" -d '@./tools/4_integrations/Metrics/test-data.json' 'https://netcool-evtmanager.dteroks-270003bu3k-c7azm-4b4a324f027aea19c5cbc0c3275c4656-0000.eu-gb.containers.appdomain.cloud/metrics/api/1.0/metrics'


export HTTP_PASSWORD=$(kubectl get secret evtmanager-systemauth-secret -o jsonpath --template '{.data.password}' | base64 --decode)
export HTTP_USERNAME=$(kubectl get secret evtmanager-systemauth-secret -o jsonpath --template '{.data.username}')
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' "https://$HTTP_SERVER/metrics/api/1.0/metrics" -u "${HTTP_USERNAME}:${HTTP_PASSWORD}" --insecure -d @./tools/4_integrations/Metrics/test-data.json






curl -X GET --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' 'https://$HTTP_SERVER/metrics/api/1.0/metrics?resource=ABC001-2&group=DEFMetrics&metric=ResponseTime' -u "${HTTP_USERNAME}:${HTTP_PASSWORD}" --insecure

curl -X POST --header 'Accept: application/json' --header 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255; Content-Type: application/json; charset=utf-8' "https://$HTTP_SERVER/metrics/api/1.0/metrics?resource=ABC001-2&group=DEFMetrics&metric=ResponseTime" -u "${HTTP_USERNAME}:${HTTP_PASSWORD}" --insecure -d "data=@./tools/4_integrations/Metrics/test-data.json"

    curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d $"${line}"


-d "data=@path/to/my-file.txt"


UI is single tenant and that is:  cfd95b7e-3bc7-4006-a4a8-a73a79c71255


SOC-SXEV5QE
