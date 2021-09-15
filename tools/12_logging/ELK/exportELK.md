kubernetes.pod_name:"fluentd-8kktl" AND kubernetes.namespace_name:"openshift-logging" AND kubernetes.container_name.raw:"fluentd"



{
  "codec": "elk",
  "message_field": "message",
  "log_entity_types": "hostname, kubernetes.container_image, kubernetes.namespace_name, kubernetes.host,  kubernetes.container_name, kubernetes.pod_name",
  "instance_id_field": " kubernetes.container_name",
  "rolling_time": 10,
  "timestamp_field": "@timestamp"
}



cat 1000-1000-20210906-logtrain.json |jq '.["_source"]'|jq '.["entities"]' |jq '.["kubernetes.container_name"]' | sort | uniq -c


cat 1000-1000-20210906-logtrain.json | grep -v "dispatch" > new1.json
cat new1.json | grep -v "mongodb" > new2.json
cat new2.json | grep -v "redis" > new3.json

cat new3.json > 1000-1000-20210906-logtrain_FINAL.json
cat 1000-1000-20210906-logtrain_FINAL.json |jq '.["_source"]'|jq '.["entities"]' |jq '.["kubernetes.container_name"]' | sort | uniq -c






{
  "codec": "elk",
  "message_field": "message",
  "log_entity_types": "hostname, kubernetes.container_image, kubernetes.namespace_name, kubernetes.host,  kubernetes.container_name, kubernetes.pod_name",
  "instance_id_field": " kubernetes.container_name",
  "rolling_time": 10,
  "timestamp_field": "@timestamp"
}


kubernetes.namespace_name:"robot-shop"
kubernetes.container_name:"web" | kubernetes.container_name:"ratings" kubernetes.container_name:"catalogue"



{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "kubernetes.container_name": "web"
          }
        },
        {
          "match": {
            "kubernetes.container_name": "ratings"
          }
        },
        {
          "match": {
            "kubernetes.container_name": "catalogue"
          }
        }
      ],
      "minimum_should_match": 1
    }
  }
}










































cat test.json | jq '.' | jq '.hits' | jq '.hits' > test1.json

},   {     "_index"
}
{"_index"

cat ./test.json|jq '.["kubernetes.container_name"]' | sort | uniq -c

cat ./test.json|jq '.["hits"] | .["hits"] | .[]._source.kubernetes.container.name' | sort | uniq -c


cat qotd-normal-1.json |jq '.["_source"] | .kubernetes.container.name' | sort | uniq -c

{
  "codec": "elk",
  "message_field": "message",
  "log_entity_types": "agent.hostname, kubernetes.container.image, kubernetes.namespace, kubernetes.node.hostname, kubernetes.container.name, kubernetes.pod.name",
  "instance_id_field": "kubernetes.container.name",
  "rolling_time": 10,
  "timestamp_field": "@timestamp"
}


{
  "rolling_time": 10,
  "instance_id_field": "kubernetes.container.name",
  "log_entity_types": "kubernetes.deployment.name, kubernetes.container.name, kubernetes.namespace, kubernetes.container.image, kubernetes.node.name,",
  "message_field": "message",
  "timestamp_field": "@timestamp",
  "codec": "elk"
}

cat test.json| tr '\n' ' ' | gsed 's/},   {     "_index":/}\n{"_index":/' > test1.json
cat test.json| tr '\n' ' '| gsed 's/\[  {/}/'
cat test.json| tr '\n' ' '| gsed 's/\[   {/{/'| gsed 's/  / /' > test5.json
cat test.json| tr '\n' ' '| gsed 's/\[   {/{/g'| gsed 's/  / /g'| gsed 's/]   },   {/}\n\r{/g' > test5.json

cat test.json| tr '\n' ' ' > test5.json
gsed -i 's/ //g' test5.json
gsed -i 's/\[{/{/g' test5.json
gsed -i 's/]},{/\]}\n\{/g' test5.json






]   },   {