#!/bin/bash

set -e

######## Global vars ########
OUTPUT_DIR=$(date '+%Y-%m-%d-%H-%M-%S')
# AIOps vV3.1.1has only one App Group and one App
APP_GROUP_ID='1000'
APP_ID='1000'
# Deleting the Kafka connection for events also deletes the "alerts-noi-${APP_GROUP_ID}-${APP_ID}" topic.
# Hence, no need to add alerts-noi-${APP_GROUP_ID}-${APP_ID} to the array below.
declare -a TOPICS=("windowed-logs-${APP_GROUP_ID}-${APP_ID}" "normalized-alerts-${APP_GROUP_ID}-${APP_ID}" "derived-stories")

save_pods_logs () {
        echo "0.0 Storing pods logs data ..."

        pushd "${OUTPUT_DIR}"

        mkdir "logs"
        pushd "logs"

        oc get pods --no-headers -o custom-columns=":metadata.name" | grep "detector\|grouping\|localization\|aio-topology\|incidents\|orchestrator\|integrator\|persistence\|aio-controller" | xargs -I {} bash -c "oc logs {} > {}.txt"

        popd
        popd
}

save_db_data () {
        # https://pages.github.ibm.com/watson-ai4it/persistence-service/
        echo "0.1 Storing db data ..."

        pushd "${OUTPUT_DIR}"

        mkdir "db"
        pushd "db"

        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/similar_incident_lists" > similar_incident_lists.json
        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/alertgroups" > alertgroups.json
        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/application_groups/${APP_GROUP_ID}/app_states" > app_states.json
        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/stories" > stories.json

        popd
        popd
}

save_data () {
        echo "0. STORING DATA (pods logs, db data)"

        save_pods_logs
        save_db_data

        echo ""
}

delete_connections () {
        echo "I. DELETING CONNECTIONS"
        echo "INFO: All connections for APP_ID '$APP_ID' will be deleted"

        pushd "${OUTPUT_DIR}"

        mkdir "connections"
        pushd "connections"

        # Get connection docs for app
        local connections_docs=$(oc exec $(oc get pods | grep aio-controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/application_groups/${APP_GROUP_ID}/applications/${APP_ID}")
        # Store connections so we can re-create them
        echo "${connections_docs}" > connections.json

        # Get connection ids for app
        local connections_ids=($(oc exec $(oc get pods | grep aio-controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/application_groups/${APP_GROUP_ID}/applications/${APP_ID}" | jq '.[].global_id'))

        for connection_id in "${connections_ids[@]}"
        do
                echo "Deleting connection ID: ${connection_id}"
                deleted_id=$(oc exec $(oc get pods | grep aio-controller | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:9443/v2/cpdconnections/${connection_id}")
        done

        connections_ids=$(oc exec $(oc get pods | grep aio-controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/application_groups/${APP_GROUP_ID}/applications/${APP_ID}")

        if [ "$connections_ids" == "[]" ]; then
                echo "INFO: Connections for APP_ID '${APP_ID}' are deleted"
        else
                echo "WARNING: Connections for APP_ID '${APP_ID}' are not deleted ... PLS CHECK !!"
        fi

        popd
        popd

        echo ""
}

delete_kafka_topics () {
        echo "II. DELETING KAFKA TOPICS"

        pushd "${OUTPUT_DIR}"

        mkdir "topics"
        pushd "topics"

        for topic in "${TOPICS[@]}"
        do
                echo "Backing up Kafka Topic: ${topic}"
                oc get kafkatopic "${topic}" -o yaml > "${topic}.yaml"
                echo "Deleting Kafka Topic: ${topic}"
                oc delete kafkatopic ${topic}
        done

        popd
        popd

        echo ""
}

check_pod_status () {
	local pod_name="$1"
	local grep_string="$2"
        local pod_running=false
	local failure_count=0
	local max_failure_count=3

        while [ "${pod_running}" == "false" ]; do
                local status=$(oc get pods | grep "${grep_string}")
                if [[ $status == *"Pending"* ]]; then
                        echo "INFO: '${pod_name}' pod pending"
                        sleep 10s
                elif [[ $status == *"Running"* ]]; then
                        echo "INFO: '${pod_name}' pod running"
                        sleep 20s
                        pod_running=true
                else
                        if [ ${failure_count} -gt ${max_failure_count} ]; then 
                                echo "ERROR: There was a problem with '${pod_name}' pod"
                        	echo "Exiting ..."
                        	exit 1
			else 
			        echo "INFO: 'Waiting on ${pod_name}' pod to stabilize..."
                        	sleep 35s
                                failure_count=$((failure_count+1))
                        fi
                fi
        done
}

delete_pods () {
        oc delete pod $(oc get pods | grep log-anomaly-detector | awk '{print $1;}')
        oc delete pod $(oc get pods | grep aio-event | awk '{print $1;}')
	oc delete pod $(oc get pods | grep slack | awk '{print $1;}')
        oc delete pod $(oc get pods | grep aio-topology | awk '{print $1;}')
	oc delete pod $(oc get pods | grep flink-task | awk '{print $1;}')

        check_pod_status "Log Anomaly Detector" "anomaly"
        check_pod_status "Event Grouping Service" "aio-event"
        check_pod_status "Slack service" "slack"
        check_pod_status "Topology service" "aio-topology"
        # If the size is small, then you have only one task pod
        # If the size is medium, or large, then you have mutiple task pods (two)
        # If the size is medium, or large, then HA is enabled... (for these cases, we need additional logic -- Padma)
        # Assuming small configuration for now
        check_pod_status "Flink task service" "task"

        echo ""
}

create_kafka_topics () {
        echo "V. CREATING KAFKA TOPICS"

        pushd "$OUTPUT_DIR"
        pushd "topics"

        ### The app group and the app should still be present for all of this to work!
        for topic in "${TOPICS[@]}"
        do
                echo "Recreating Kafka Topic: ${topic}"
                oc create -f "${topic}.yaml"
        done

        popd
        popd

        echo ""
}

clear_db () {
        echo "VII: CLEARING DB (for similar incidents, alert groups, app states)"

        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/similar_incident_lists > /dev/null"
        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/alertgroups > /dev/null"
        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/app_states > /dev/null"

        sleep 20s

        local incidents=$(oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/similar_incident_lists")
        local alertgroups=$(oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/alertgroups")
        local app_states=$(oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/application_groups/$APP_GROUP_ID/app_states")

        sleep 20s

        echo ""

        if [ "$incidents" == "[]" ]; then
                echo "INFO: 'similar_incident_lists' cleared from DB"
        else
                echo "WARNING: 'similar_incident_lists' not cleared from DB ... PLS CHECK !!"
        fi

        if [ "$alertgroups" == "[]" ]; then
                echo "INFO: 'alertgroups' cleared from DB"
        else
                echo "WARNING: 'alertgroups' not cleared from DB ... PLS CHECK !!"
        fi

        if [ "$app_states" == "{}" ]; then
                echo "INFO: 'app_states' cleared from DB"
        else
                echo "WARNING: 'app_states' not cleared from DB ... PLS CHECK !!"
        fi

        echo ""
}

clear_db_stories () {
        echo "VIII. CLEARING DB (for stories)"

        oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k -X DELETE https://localhost:8443/v2/stories > /dev/null"

        sleep 30s

        local stories=$(oc exec $(oc get pods | grep persistence | awk '{print $1;}') -- bash -c "curl -k https://localhost:8443/v2/stories")

        sleep 20s

        echo ""

        if [ "$stories" == "[]" ]; then
                echo "INFO: 'stories' cleared from DB"
        else
                echo "WARNING: 'stories' not cleared from DB ... PLS CHECK !!"
        fi

        echo ""
}

refresh_flink_jobs () {
        echo "X. Refreshing flink jobs"

        local controller_pod=`oc get pods | grep aio-controller | awk '{print $1;}'`

        #https://ibm.ent.box.com/file/786518037502?s=h52y1rui6k9tc8ke3ykoeubssbr4g6gi
        #https://pages.github.ibm.com/watson-ai4it/zeno-connection-manager/#/Connections/refreshConnections
        #curl -w "%{http_code}" -k -X PUT "https://localhost:9443/v2/connections/application_groups1000/applications/1000/refresh?datasource_type=logs"
        #404 http return code?
        #Is this even valid?
        #404 more than likely happens because the integrations are disabled! -- need to validate this
        oc exec $controller_pod -- curl -k -X PUT "https://localhost:9443/v2/connections/application_groups/1000/applications/1000/refresh?datasource_type=logs"

        oc exec $controller_pod -- curl -k -X PUT "https://localhost:9443/v2/connections/application_groups1000/applications/1000/refresh?datasource_type=alerts"

        echo ""
}

create_connections () {
        # CPD connecitons REST API: https://pages.github.ibm.com/watson-ai4it/zeno-connection-manager/
        echo "XI. RECREATING CONNECTIONS"
        echo "INFO: All previous connections (e.g. Live Humio, Kafka NOI) for APP_ID '$APP_ID' will be created"

        pushd "${OUTPUT_DIR}"
        pushd "connections"

        dt=$(date '+%Y-%m-%dT%H:%M:%S')

        # CREATE CONNECTIONS
        export CPOD=`oc get pods | grep aio-controller | awk '{print $1;}'`

        # https://www.starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
        local no_connections=0
        for row in $(cat connections.json | jq -r '.[] | @base64'); do              
                local conn_record=$(echo ${row} | base64 --decode | jq -r 'del(.connection_id)' | jq -r 'del(.connection_updated_at)' | jq -r 'del(.global_id)' | jq -r 'del(.request_action)' | jq -r --arg connection_updated_at ${dt} '. + {connection_updated_at: $connection_updated_at}')
                local display_name=$(echo ${conn_record} | jq '.connection_config.display_name')
                echo "Creating Ops integration for ${display_name}"
                oc exec $CPOD -- curl -k -X POST "https://localhost:9443/v2/cpdconnections" -H "Content-Type: application/json" -d "${conn_record}"
                no_connections=$((no_connections+1))
        done

        # Verify connections were created
        connections_ids=($(oc exec $(oc get pods | grep aio-controller | awk '{print $1;}') -- bash -c "curl -k -X GET https://localhost:9443/v2/connections/application_groups/${APP_GROUP_ID}/applications/${APP_ID}" | jq '.[].global_id'))
     
        if [ "${#connections_ids[@]}" -lt ${no_connections}  ]; then
                echo ""
                echo "ERROR: Not all connections for APP_ID '$APP_ID' are not created ... PLS CHECK !!"
                echo "ERROR: One or more Ops connections are missing for APP_ID '$APP_ID'"
                echo ""
        else         
                echo "INFO: Connections for APP_ID '$APP_ID' created"
                for connection_id in "${connections_ids[@]}"
                do
                        echo "Created connection ID: $connection_id"
                done
        fi

        popd
        popd

        echo ""
}

echo ""
echo "Resetting AIOps vV3.1.1environment"
echo "--------------------------------"
echo ""

######## Create output directory ########
mkdir "${OUTPUT_DIR}"

######## Step 0: Save pods logs, DB data ########
save_data

######## Step 1: Delete connections ########
delete_connections

######## Step 2: Delete kafka topics ########
delete_kafka_topics

######## Step 3: Delete pods ########
echo "III. DELETING PODS"
delete_pods

######## Step 5: Create kafka topics ########
create_kafka_topics

######## Step 7: Clear database ########
clear_db

######## Step 8: Clear database (stories) ########
clear_db_stories

######## Step 9: Delete pods ########
echo "IX. DELETING PODS"
delete_pods

######## Step 10: Refresh flink jobs ########
refresh_flink_jobs

######## Step 11: Re-create connections ########
create_connections

echo "DONE !!"
