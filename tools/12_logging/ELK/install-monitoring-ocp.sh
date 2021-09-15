# https://docs.openshift.com/container-platform/4.7/monitoring/configuring-the-monitoring-stack.html

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 CloudPak for Watson AI OPS 3.1 - Install OCP Monitoring"
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "



LOG_READY=$(oc -n openshift-logging get configmap kibana-trusted-ca-bundle -oyaml || true) 
if  ([[ ! $LOG_READY =~ "manager: elasticsearch-operator" ]]); 
then
    echo "   🌏 OCP Cluster Logging will be installed" ; 
    echo "" ; 
    echo "" ; 
    echo "" ; 
else
    echo "   ⭕ OCP Cluster Logging already installed. Aborting..."
    exit 1
fi

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🚀 Installing Elasticsearch" ; 

oc apply -f ./tools/12_logging/ELK/1_elasticsearch.yaml

CSV_READY=$(oc get csv -n openshift-logging | grep elasticsearch-operator || true) 
while  ([[ ! $CSV_READY =~ "Succeeded" ]]); do 
    CSV_READY=$(oc get csv -n openshift-logging | grep elasticsearch-operator || true) 
    echo "      ⭕ elasticsearch-operator not ready. Waiting for 10 seconds...." ; 
done
echo "      ✅ Installing Elasticsearch... Done" ; 
echo "" ; 
echo "" ; 
echo "" ; 


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🚀 Installing Cluster Logging Operator" ; 

oc apply -f ./tools/12_logging/ELK/2_logging.yaml


CSV_READY=$(oc get csv -n openshift-logging | grep cluster-logging || true) 
while  ([[ ! $CSV_READY =~ "Succeeded" ]]); do 
    CSV_READY=$(oc get csv -n openshift-logging | grep cluster-logging || true) 
    echo "      ⭕ cluster-logging not ready. Waiting for 10 seconds...." ; 
done
echo "      ✅ Installing Cluster Logging Operator... Done" ; 
echo "" ; 
echo "" ; 
echo "" ; 


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🚀 Installing Cluster Logging" ; 
oc apply -f ./tools/12_logging/ELK/3_logging-cr.yaml
echo "      ✅ Installing Cluster Logging... Done" ; 
echo "" ; 
echo "" ; 
echo "" ; 
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🕦 Waiting 30 seconds to settle" ; 
sleep 30
echo "" ; 
echo "" ; 
echo "" ; 


MAXCOUNT=100
ACTCOUNT=0
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🕦 Waiting for Elasticsearch in Namespace openshift-logging being ready."

PODS_PENDING=$(oc get po -n openshift-logging -l component=elasticsearch | grep -v Running | grep -v Completed | grep -c "" || true)
while  [[ $PODS_PENDING > 1 ]] && [[ $ACTCOUNT -lt $MAXCOUNT ]]; do 
    PODS_PENDING=$(oc get po -n openshift-logging -l component=elasticsearch | grep -v Running |grep -v Completed | grep -c "" || true)
    if [[ -z "$PODS_PENDING" ]]; then
        PODS_PENDING=0
        echo "${warning}  Namespace has no Pods..."
    fi
    ACTCOUNT=$((ACTCOUNT+1))
    echo "            🕦   Still checking...  ❗ $PODS_PENDING in Namespace openshift-logging still not ready ready. Waiting for 5 seconds....($ACTCOUNT/$MAXCOUNT)"
    sleep 5
done
echo "" ; 
echo "" ; 
echo "" ; 

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🚀 Patching Fluentbit for robot-shop Namespace" ; 
# Set Logging Operator to "Unmanaged"
oc patch ClusterLogging instance -n openshift-logging --patch "$(cat ./tools/12_logging/ELK/4_logging-patch.yaml)"  --type=merge
#In order to create Filter to only ingest robot-shop logs
oc delete cm fluentd -n openshift-logging
oc apply -f ./tools/12_logging/ELK/5_fluentd-configmap.yaml


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🧻   Restarting Fluentd Pods"
oc delete pods -n openshift-logging -l component=fluentd


MAXCOUNT=100
ACTCOUNT=0
echo "      🕦   Waiting for Namespace openshift-logging being ready."

PODS_PENDING=$(oc get po -n openshift-logging | grep -v Running | grep -v Completed | grep -c "" || true)
while  [[ $PODS_PENDING > 1 ]] && [[ $ACTCOUNT -lt $MAXCOUNT ]]; do 
    PODS_PENDING=$(oc get po -n openshift-logging | grep -v Running |grep -v Completed | grep -c "" || true)
    if [[ -z "$PODS_PENDING" ]]; then
        PODS_PENDING=0
        echo "${warning}  Namespace has no Pods..."
    fi
    ACTCOUNT=$((ACTCOUNT+1))
    echo "            🕦   Still checking...  ❗ $PODS_PENDING in Namespace openshift-logging still not ready ready. Waiting for 5 seconds....($ACTCOUNT/$MAXCOUNT)"
    sleep 5
done







echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🚀 Creating Route" ; 

rm admin-ca
oc delete route  elasticsearch -n openshift-logging
oc extract secret/elasticsearch -n openshift-logging --to=. --keys=admin-ca --confirm
oc create route reencrypt elasticsearch -n openshift-logging --service=elasticsearch --port=elasticsearch --dest-ca-cert=admin-ca
rm admin-ca




token=$(oc sa get-token cluster-logging-operator -n openshift-logging)
routeES=`oc get route elasticsearch -o jsonpath={.spec.host} -n openshift-logging`
routeKIBANA=`oc get route kibana -o jsonpath={.spec.host} -n openshift-logging`



echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🔎  Parameter for OCP ElasticSearch Integration "
echo "  "
echo "           🌏 ELK service URL             : https://$routeES/app*"
echo "           🔐 Authentication type         : Token"
echo "           🔐 Token                       : $token"
echo "  "
echo "           🌏 Kibana URL                  : https://$routeKIBANA"
echo "           🚪 Kibana port                 : 443"
echo "           🗺️  Mapping                     : "
echo "{ "
echo "  \"codec\": \"elk\","
echo "  \"message_field\": \"message\","
echo "  \"log_entity_types\": \"kubernetes.container_image_id, kubernetes.host, kubernetes.pod_name, kubernetes.namespace_name\","
echo "  \"instance_id_field\": \"kubernetes.container_name\","
echo "  \"rolling_time\": 10,"
echo "  \"timestamp_field\": \"@timestamp\""
echo "}"
echo "  "




echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      🕦 Waiting 30 seconds to settle" ; 
sleep 30

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  💨  Testing Connectivity"
echo "***************************************************************************************************************************************************"
echo "  "

curl -tlsv1.2 --insecure -H "Authorization: Bearer ${token}" "https://${routeES}"
#curl -tlsv1.2 --insecure -H "Authorization: Bearer ${token}" "https://${routeES}/_search?scroll=1m"
#curl --insecure -H "Authorization: Bearer ${token}" https://${routeES}/\n
#curl -tlsv1.2 --insecure -H "Authorization: Bearer ${token}" "https://elasticsearch-openshift-logging.ibmcloud-roks-6o5tkw0d-6ccd7f378ae819553d37d5f2ee142bd6-0000.ams03.containers.appdomain.cloud/app*/_search?scroll=1m"

echo "  "
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "   ✅ OCP Cluster Logging has been installed" ; 
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

