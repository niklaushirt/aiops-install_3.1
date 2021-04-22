## CREATE JOB
curl -X "POST" "https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/rest-observer/jobs/listen" \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: 4537c95a03ec20cc9f6b6f42e89f1813=c0be3a94130da5df0c9ac3301f4cc803; 3a1a35fb207ba3c538d4e2b63ac68863=de912e600edcedf26b7b3ce9b7e71f40; 4bbb996250454381873de3d013af38e1=532530c6bdd7ac721f8684a66eff61b6' \
     -u 'demo-noi-topology-noi-user:Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=' \
     -d $'{
  "unique_id": "listenJob",
  "type": "listen",
  "parameters": {
    "provider": "MyListenJob"
  }
}' \
--insecure




## CREATE SERVICE
curl -X "POST" "https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/rest-observer/rest/resources" \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'JobId: listenJob' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: 4537c95a03ec20cc9f6b6f42e89f1813=c0be3a94130da5df0c9ac3301f4cc803; 3a1a35fb207ba3c538d4e2b63ac68863=de912e600edcedf26b7b3ce9b7e71f40; 4bbb996250454381873de3d013af38e1=532530c6bdd7ac721f8684a66eff61b6' \
     -u 'demo-noi-topology-noi-user:Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=' \
     -d $'{
  "name": "ratings",
  "entityTypes": [
    "service"
  ],
  "uniqueId": "835d66cc-24bc-448a-a864-3aa3a4914a38"
}' \
--insecure




## CREATE DEPLOYMENT
curl -X "POST" "https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/rest-observer/rest/resources" \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'JobId: listenJob' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: 4537c95a03ec20cc9f6b6f42e89f1813=c0be3a94130da5df0c9ac3301f4cc803; 3a1a35fb207ba3c538d4e2b63ac68863=de912e600edcedf26b7b3ce9b7e71f40; 4bbb996250454381873de3d013af38e1=532530c6bdd7ac721f8684a66eff61b6' \
     -u 'demo-noi-topology-noi-user:Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=' \
     -d $'{
  "name": "reviews-v2",
  "entityTypes": [
    "deployment"
  ],
  "uniqueId": "db57b32b-3ae9-4e40-ad2d-49489f148afd"
}' \
--insecure


## CREATE EDGE
curl -X "POST" "https://demo-noi-topology.noi.tec-cp4aiops-3c14aa1ff2da1901bfc7ad8b495c85d9-0000.eu-de.containers.appdomain.cloud/1.0/rest-observer/rest/references" \
     -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
     -H 'JobId: listenJob' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'Cookie: 4537c95a03ec20cc9f6b6f42e89f1813=c0be3a94130da5df0c9ac3301f4cc803; 3a1a35fb207ba3c538d4e2b63ac68863=de912e600edcedf26b7b3ce9b7e71f40; 4bbb996250454381873de3d013af38e1=532530c6bdd7ac721f8684a66eff61b6' \
     -u 'demo-noi-topology-noi-user:Q2d+Qz41b5RCs1NeUj6cJb63q0/Vmf1QANQFq57Yy/Y=' \
     -d $'{
  "_edgeType": "connectedTo",
  "_fromUniqueId": "db57b32b-3ae9-4e40-ad2d-49489f148afd",
  "_toUniqueId": "835d66cc-24bc-448a-a864-3aa3a4914a38"
}' \
--insecure
