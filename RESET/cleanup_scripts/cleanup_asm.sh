#!/bin/bash

set -e

## e.g. evtmanager
RELEASE_NAME=$1

if [ -z "$RELEASE_NAME" ]; then
        echo "Release name for Event Manager is required as an input argument !!"
        exit 1
fi

echo "Scaling down topology deployments"
oc scale deployment -l release="${RELEASE_NAME}-topology" --replicas=0

echo "Deleting index files in Elasticsearch"
oc exec ${RELEASE_NAME}-elasticsearch-0 -- bash -c 'curl -X DELETE http://localhost:9200/searchservice*'

echo ""
echo "Deleting keyspace 'janusgraph' in Cassandra (this may take about 1 min)"
#oc exec ${RELEASE_NAME}-cassandra-0 -- bash -c 'cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS -e "DESCRIBE KEYSPACEs;"'
#https://stackoverflow.com/questions/39955968/cassandra-cqlsh-operationtimedout-error-client-request-timeout-see-session-exec
oc exec ${RELEASE_NAME}-cassandra-0 -- bash -c 'cqlsh --request-timeout=6000 -u $CASSANDRA_USER -p $CASSANDRA_PASS -e "DROP KEYSPACE janusgraph;"'

echo "Scaling back up topology deployments"
oc scale deployment -l release="${RELEASE_NAME}-topology" --replicas=1

echo "All topology data should have been removed."
echo "Topology pods are restarting"
echo "Done!"