#!/bin/bash

set -e

oc scale deployment -l release=evtmanager-topology --replicas=0
oc exec evtmanager-elasticsearch-0 -- bash -c 'curl -X DELETE http://localhost:9200/searchservice*'
oc exec evtmanager-cassandra-0 -ti -- bash
cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS -e "DESCRIBE KEYSPACES"
cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS -e "DROP KEYSPACE janusgraph"


oc scale deployment -l release=evtmanager-topology --replicas=1

echo "All topology data should have been removed."
echo "Done!"



