# Cleanup scripts

* [Cleanup AI Manager](#cleanup-ai-manager)
* [Reset training environment](#reset-training-environment)
* [Cleanup events in Event Manager](#cleanup-events-in-event-manager)
* [Cleanup ASM (in Event Manager)](#cleanup-asm-(in-event-manager))

## Cleanup AI Manager

The purpose of the [`cleanup_aimanager.sh`](cleanup_aimanager.sh) script is to reset your AI Manager vV3.1.1instance from an inference perspective (in other words, this script does **not** touch any of the trained models). Note that this script will delete all existing Ops integrations for your application along with stories and kafka queues. It will then recreate the Ops integrations it deleted along with the kafka queues. As of now, I highly discourage running this script in a production environment (this is meant to be used in test/PoC environments).

Even though it is not visible to the end user, you should know that the concept of App Groups and Apps is still a thing in AIOps v3.1. Behind the scenes, AIOps vV3.1.1creates one single App Group (with ID=`1000`) and one single App (with ID=`1000`) for your entire deployment/configuration. 

Please **review** the code in this script **before** you run it. It is highly recommended to **test** this script before you run it on your actual target environment. This script can be run as follows (in the example below, `aiops` is the namespace where AIOps vV3.1.1is installed on your OpenShift cluster):

```
oc project aiops

...

./cleanup_aimanager.sh
```

**Note:** The original version of this script was implemented by the AI Manager development team specifically for the DTE environment. I have made several modifications to this script to entirely decouple it from the DTE environment so it can be used anywhere.

As reference, running the `cleanup_aimanager.sh` script should generate output similar to this:

```
$ ./cleanup_aimanager.sh

Resetting AIOps vV3.1.1environment
--------------------------------

0. STORING DATA (pods logs, db data)
0.0 Storing pods logs data ...
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1/2021-06-02-17-13-11/logs ~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
I0602 17:13:13.471416   40788 request.go:621] Throttling request took 1.152032731s, request: GET:https://api.popcorn.cp.fyre.ibm.com:6443/apis/snapshot.storage.k8s.io/v1beta1?timeout=32s
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1
0.1 Storing db data ...
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1/2021-06-02-17-13-11/db ~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0     51      0 --:--:-- --:--:-- --:--:--    51
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0     21      0 --:--:-- --:--:-- --:--:--    21
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0     86      0 --:--:-- --:--:-- --:--:--    90
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0    142      0 --:--:-- --:--:-- --:--:--   142
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1

I. DELETING CONNECTIONS
INFO: All connections for APP_ID '1000' will be deleted
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1/2021-06-02-17-13-11/connections ~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2708  100  2708    0     0  20992      0 --:--:-- --:--:-- --:--:-- 20992
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2708  100  2708    0     0  24618      0 --:--:-- --:--:-- --:--:-- 24618
Deleting connection ID: "660477134381907971"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
Deleting connection ID: "660477332535672835"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0     58      0 --:--:-- --:--:-- --:--:--    58
INFO: Connections for APP_ID '1000' are deleted
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1

II. DELETING KAFKA TOPICS
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1/2021-06-02-17-13-11/topics ~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
Backing up Kafka Topic: windowed-logs-1000-1000
Deleting Kafka Topic: windowed-logs-1000-1000
kafkatopic.kafka.strimzi.io "windowed-logs-1000-1000" deleted
Backing up Kafka Topic: normalized-alerts-1000-1000
Deleting Kafka Topic: normalized-alerts-1000-1000
kafkatopic.kafka.strimzi.io "normalized-alerts-1000-1000" deleted
Backing up Kafka Topic: derived-stories
Deleting Kafka Topic: derived-stories
kafkatopic.kafka.strimzi.io "derived-stories" deleted
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1

III. DELETING PODS
pod "aimanager-aio-log-anomaly-detector-546bf6f5f8-mhjgm" deleted
pod "aimanager-aio-event-grouping-6b695ff8f8-4j2hp" deleted
pod "aimanager-aio-chatops-slack-integrator-6b9bc8f997-txcvm" deleted
pod "aimanager-aio-topology-565cfd5f7b-mmg8t" deleted
pod "aimanager-ibm-flink-task-manager-0" deleted
INFO: 'Log Anomaly Detector' pod running
INFO: 'Event Grouping Service' pod running
INFO: 'Slack service' pod running
INFO: 'Topology service' pod running
INFO: 'Flink task service' pod running

V. CREATING KAFKA TOPICS
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1/2021-06-02-17-13-11/topics ~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
Recreating Kafka Topic: windowed-logs-1000-1000
kafkatopic.kafka.strimzi.io/windowed-logs-1000-1000 created
Recreating Kafka Topic: normalized-alerts-1000-1000
kafkatopic.kafka.strimzi.io/normalized-alerts-1000-1000 created
Recreating Kafka Topic: derived-stories
kafkatopic.kafka.strimzi.io/derived-stories created
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1

VII: CLEARING DB (for similar incidents, alert groups, app states)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     4  100     4    0     0    307      0 --:--:-- --:--:-- --:--:--   307
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     4  100     4    0     0    235      0 --:--:-- --:--:-- --:--:--   235
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     4  100     4    0     0    266      0 --:--:-- --:--:-- --:--:--   266
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0    142      0 --:--:-- --:--:-- --:--:--   142
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0    117      0 --:--:-- --:--:-- --:--:--   117
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0    142      0 --:--:-- --:--:-- --:--:--   142

INFO: 'similar_incident_lists' cleared from DB
INFO: 'alertgroups' cleared from DB
INFO: 'app_states' cleared from DB

VIII. CLEARING DB (for stories)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     4  100     4    0     0    266      0 --:--:-- --:--:-- --:--:--   266
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0     51      0 --:--:-- --:--:-- --:--:--    51

INFO: 'stories' cleared from DB

IX. DELETING PODS
pod "aimanager-aio-log-anomaly-detector-546bf6f5f8-k7rg4" deleted
pod "aimanager-aio-event-grouping-6b695ff8f8-q7t66" deleted
pod "aimanager-aio-chatops-slack-integrator-6b9bc8f997-vbsnl" deleted
pod "aimanager-aio-topology-565cfd5f7b-bntkz" deleted
pod "aimanager-ibm-flink-task-manager-0" deleted
INFO: 'Log Anomaly Detector' pod running
INFO: 'Event Grouping Service' pod running
INFO: 'Slack service' pod running
INFO: 'Topology service' pod running
INFO: 'Flink task service' pod running

X. Refreshing flink jobs
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0

XI. RECREATING CONNECTIONS
INFO: All previous connections (e.g. Live Humio, Kafka NOI) for APP_ID '1000' will be created
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1/2021-06-02-17-13-11/connections ~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
Creating Ops integration for "asm-default"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2224    0     0  100  2224      0  11064 --:--:-- --:--:-- --:--:-- 11009{"application_group_id":"1000","application_id":"1000","connection_config":{"ui_service_url":"https://cpd-aiops.apps.popcorn.cp.fyre.ibm.com","connection_type":"asm","certificate":"-----BEGIN CERTIFICATE-----\nMIIDUTCCAjmgAwIBAgIIcPfulHOg+aQwDQYJKoZIhvcNAQELBQAwNjE0MDIGA1UE\nAwwrb3BlbnNoaWZ0LXNlcnZpY2Utc2VydmluZy1zaWduZXJAMTYyMTYyMTg3MzAe\nFw0yMTA1MjExODMxMTJaFw0yMzA3MjAxODMxMTNaMDYxNDAyBgNVBAMMK29wZW5z\naGlmdC1zZXJ2aWNlLXNlcnZpbmctc2lnbmVyQDE2MjE2MjE4NzMwggEiMA0GCSqG\nSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCnnPm11VfsSkJe7qBEHWb8jdBx/f442xJ5\nmBztJgszJcXTFKAHxr5TDHO5qMVmCcUUO61s/lW1Ke+/0gxwABSOzEc4Tq/u0crG\nG2r9OsMTLD1hhMJi9Enlb2GuRP6O9QUcQqJtA/1JxQnAMBM5zP78Mc63AnzsTgp+\n9XB5X/x9auZ88o4lYHSDRYVrWGnoYBmzdr6VK5BjmajAcGgnBzVGf/bE9uF+Lrsc\nXPX5rRIrDBMvb1UOIdstAgXnNJ7OltA0EdzhqNPOA8wBYHSJwM+MqBpafWYI44aJ\nA1uMYJHPD/qn+M+tcVpgkhGTgreM6KjEdAn24RU6b+JRgUDeuB+hAgMBAAGjYzBh\nMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSvgvsb\nkpCfhh/frXyYERr5toKvdjAfBgNVHSMEGDAWgBSvgvsbkpCfhh/frXyYERr5toKv\ndjANBgkqhkiG9w0BAQsFAAOCAQEAjCnqsjig09dD9UgNFJ/P6aRd6JvAKrGlQP8m\n3py5LRyF5xK38JPFdhvBlf3TO/z+YfExw/labsMfI1cg8vUg1au2EQC+27Z3OJa+\nyVrvr9lz5YTKEmroJxPvWEM+In0axNwyjIUvy0623boZ2H3gPNoJWK/kKdS4fKC7\nqW9pssYy9X9a6sPASv38M5rdjlxeK942ZgTOb0pnxlMHE3p1XYFiAC1en2ppQNEq\nvdSX9H0yvKjKPLilhVRbZZRvCSidpp+SVSkQRg6pktOs+hhVbn0XVZSUWhnm3b72\nk5vj1UwMIcKlGIEf82kT0/HvkBLn//0OlUYyQ/ryFItADWGmMw==\n-----END CERTIFICATE-----\n","description":"","search_service_url":"https://evtmanager-topology-search.aiops.svc:7080","layout_service_url":"https://evtmanager-topology-layout.aiops.svc:7084","display_name":"asm-default","check_box_url":true,"topology_service_url":"https://evtmanager-topology-topology.aiops.svc:8080","password":"ZMRqUufZfQpBYmUtF1G7k/QTMLCWj7PcCH2VEfFROg0=","creator_user_name":"","ui_api_service_url":"https://evtmanager-topology-ui-api.aiops.svc:3080","merge_service_url":"https://evtmanager-topology-merge.aiops.svc:7082","username":"aimanager-topology-aiops-user"},"connection_id":"a05f8615-73e8-4390-8f7e-3fb12412e7b2","connection_type":"asm","connection_updated_at":"2021-06-02T17:23:13","datasource_100  4437  100  2213  100  2224   5964   5994 --:--:-- --:--:-- --:--:-- 11927equest_action":"create"}
Creating Ops integration for "noi-default"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0{"application_group_id":"1000","application_id":"1000","connection_config":{"connection_type":"kafka","creator_user_name":"","description":"","topic":"alerts-noi-1000-1000","base_parallelism":1,"num_partitions":1,"display_name":"noi-default"},"connection_id":"107a0586-b835-45d2-b815-cdbfa9738bd7","connection_type":"kaf100   933  100   482  100   451    596    558 --:--:-- --:--:-- --:--:--  1154global_id":"663875091492601859","mapping":{"codec":"noi"},"request_action":"create"}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2707  100  2707    0     0  21830      0 --:--:-- --:--:-- --:--:-- 21830
INFO: Connections for APP_ID '1000' created
Created connection ID: "663875087820783619"
Created connection ID: "663875091492601859"
~/git/common-utils/v3.1/2021-06-02-17-13-11 ~/git/common-utils/v3.1
~/git/common-utils/v3.1

DONE !!
```

## Reset training environment
The [`reset_training_ai_manager`](reset_training_ai_manager.sh) script resets your AI Manager vV3.1.1instance from a **training** perspective. In other words, this script will delete any existing trained models, training definitions along with their data sets from your AIOps V3.1.1instance. As of now, I highly discourage running this script in a production environment (instead, this is meant to be used in test/PoC environments).

Please **review** the code in this script **before** you run it. It is highly recommended to **test** this script before you run it on your actual target environment. This script can be run as follows (in the example below, `aiops` is the namespace where AIOps vV3.1.1is installed on your OpenShift cluster):

```
oc project aiops

...

./reset_training_ai_manager.sh
```

## Cleanup events in Event Manager

Just like with the other scripts above, you should be very careful if you attempt to use the [cleanup_eventmanager.sh](cleanup_eventmanager.sh) script. This script will delete all events from Event Manager.

```
oc project aiops

...

./cleanup_eventmanager.sh
```

## Cleanup ASM (in Event Manager)

You should be very careful if you attempt to use the [cleanup_asm.sh](cleanup_asm.sh) script. This script will delete all topology information from Event Manager regardless of the Kubernetes observer jobs that were initially used to capture the topology information. Note that it will also delete your observer jobs as well.

```
oc project aiops

...

./cleanup_asm.sh <release name>
```