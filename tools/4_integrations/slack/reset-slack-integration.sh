
oc delete kafkatopic -n zen connections

oc apply -n zen -f ./tools/4_integrations/slack/connections_topic.yaml

