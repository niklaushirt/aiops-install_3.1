# https://www-03preprod.ibm.com/support/knowledgecenter/SSTPTP_1.6.3_test/com.ibm.netcool_ops.doc/soc/integration/task/enable_metric_manger.html


oc scale deploy evtmanager-spark-slave --replicas=2

oc scale --replicas=1 deploy evtmanager-metric-ingestion-service-metricingestionservice
oc scale --replicas=1 deploy evtmanager-metric-action-service-metricactionservice
oc scale --replicas=1 deploy evtmanager-metric-trigger-service-metrictriggerservice
oc scale --replicas=1 deploy evtmanager-metric-api-service-metricapiservice
oc scale --replicas=1 deploy evtmanager-metric-spark-service-metricsparkservice

