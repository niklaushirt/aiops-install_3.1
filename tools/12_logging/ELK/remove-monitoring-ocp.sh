# https://docs.openshift.com/container-platform/4.7/monitoring/configuring-the-monitoring-stack.html

oc delete -f ./tools/12_logging/ELK/3_logging-cr.yaml
oc delete -f ./tools/12_logging/ELK/2_logging.yaml
oc delete -f ./tools/12_logging/ELK/1_elasticsearch.yaml


