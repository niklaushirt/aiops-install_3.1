# CP4WatsonAIOps 3.1 Demo Environment Installation



# Changes

| Date  | Description  | Files  | 
|---|---|---|
|  22 Apr 2021 | 3.1 Preview install  | This is experimental!  |
|   |   |   | 



---------------------------------------------------------------------------------------------------------------
# Installation
---------------------------------------------------------------------------------------------------------------

1. [Prerequisites](#prerequisites)
1. [Architecture](#architecture)
1. [AI and Event Manager Base Install](#ai-and-event-manager-base-install)
1. [Install Humio](#humio)
1. [Connections from AI Manager (Ops Integration)](#connections-from-ai-manager-ops-integration)
1. [Configure Event Manager / ASM Topology](#configure-event-manager--asm-topology)
1. [Configure Runbooks](#configure-runbooks)
1. [Slack integration](#slack-integration)
1. [Some Polishing](#some-polishing)
1. [Check Installation](#check-installation)


> ❗You can find a handy install checklist here: [INSTALLATION CHECKLIST](./README_INSTALLATION_CHECKLIST.md).



---------------------------------------------------------------------------------------------------------------
## Introduction
------------------------------------------------------------------------------

This repository documents the progress of me learning to build a Watson AIOps demo environment.

This is provided `as-is`:

* I'm sure there are errors
* I'm sure it's not complete
* It clearly can be improved

So please if you have any feedback contact me 

- on Slack: Niklaus Hirt or
- by Mail: nikh@ch.ibm.com






---------------------------------------------------------------------------------------------------------------
## Prerequisites
------------------------------------------------------------------------------

### OpenShift requirements

I installed the demo in a ROKS environment.

You'll need:

- ROKS 4.6
- 5x worker nodes Flavor `b3c.16x64` (so 16 CPU / 64 GB)

You might get away with less if you don't install some components (Humio,...)


### Tooling

You need the following tools installed in order to follow through this guide:

- gnu-sed (on Mac)
- oc
- jq
- kubectl
- kafkacat
- helm 3

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gnu-sed
brew install kafkacat
brew install jq
```


Get oc and kubectl from [here](https://github.com/openshift/okd/releases/)

or use :

```bash
wget https://github.com/openshift/okd/releases/download/4.6.0-0.okd-2021-02-14-205305/openshift-client-mac-4.6.0-0.okd-2021-02-14-205305.tar.gz -O oc.tar.gz
tar xfzv oc.tar.gz
mv kubectl /usr/local/bin
mv oc /usr/local/bin
```




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Architecture
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

The environement (Kubernetes, Applications, ...) create logs that are being fed into a Log Management Tool (Humio in this case).

![](./pics/aiops-demo.png)

The Log Management Tool (Humio) generates Alerts when it detects a problem and sends them into the Event Manager (Netcool Operations Insight), which in turn sends them to the AI Manager for Event Grouping.

At the same time AI Manager ingests the raw logs coming from the Log Management Tool (Humio) and looks for anomalies in the stream based on the trained model.
If it finds an anomaly it forwards it to the Event Grouping as well.

Out of this, AI Manager creates a Story that is being enriched with Topology (Localization and Blast Radius) and with Similar Incidents that might help correct the problem.

The Story is then sent to Slack.

At the same time Event Manager launches an automated Runbook to correct the problem (scale up the Bookinfo Ratings deployment).




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## AI and Event Manager Base Install
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Adapt configuration

Adapt the 01_config-modules.sh file with the desired parameters:

**Storage Class**

```bash
# WAIOPS Storage Class (ibmc-file-gold-gid, rook-cephfs, nfs-client, ...)
export WAIOPS_STORAGE_CLASS_FILE=ibmc-file-gold-gid
    

# WAIOPS Large Storage Class (ibmc-file-gold-gid, rook-cephfs, nfs-client, ...)
export WAIOPS_STORAGE_CLASS_LARGE_BLOCK=ibmc-file-gold-gid

```

**Optional Components**

```bash
# Install Humio and Fluentbit (not implemented yet)
export INSTALL_HUMIO=true

# Install LDAP Server
export INSTALL_LDAP=true

# Demo Applications
export INSTALL_DEMO=true

```

Make sure that you are logged into your cluster!

### Start installation

```bash
./10_install_aiops.sh -t <PULL_SECRET_TOKEN>
```

This will install 
- CP4WAIOPS
- Humio 
- OpenLDAP



### Post installation

```bash
./11_install_aiops_post_install.sh
```

This will install and configure some additional things:

- Register LDAP Users
- Demo Apps
- Gateway
- And some housekeeping







---------------------------------------------------------------------------------------------------------------
## HUMIO
------------------------------------------------------------------------------

> ❗Humio is being installed by the installation script.


### Configure Humio

* Create Repository `aiops`
* Get Ingest token (Settings --> API tokens)

### Limit retention

This is important as your PVCs will fill up otherwise and Humio can become unavailable.

#### Change retention size for aiops

You have to change the retention options for the aiops repository

![](./pics/humior1.png)

#### Change retention size for humio

You have to change the retention options for the humio repository

![](./pics/humior2.png)





### Humio Fluentbit

```bash
export INGEST_TOKEN=ZsXyuLJrdKnZFqtLaTldvqsNhRYCmhFikLLQ9mBM1tDQ (put your token from above)

```

#### Install DaemonSet

```bash
oc adm policy add-scc-to-user privileged -n humio-logging -z humio-fluentbit-fluentbit-read


helm install humio-fluentbit humio/humio-helm-charts \
  --namespace humio-logging \
  --set humio-fluentbit.token=$INGEST_TOKEN \
  --values ./tools/4_integrations/humio/humio-agent.yaml
```


#### Modify DaemonSet

```bash
kubectl patch DaemonSet humio-fluentbit-fluentbit -n humio-logging -p '{"spec": {"template": {"spec": {"containers": [{"name": "humio-fluentbit","image": "fluent/fluent-bit:1.4.2","securityContext": {"privileged": true}}]}}}}' --type=merge

kubectl apply -n humio-logging -f ./tools/4_integrations/humio/FluentbitDaemonSet_DEBUG.yaml


kubectl delete -n humio-logging pods -l k8s-app=humio-fluentbit


```


### Configure Humio Notifier 

**In Humio:**

Go to:

* `aiops` repository
* Alerts --> Notifiers 
* New Notifier with the Noi Webhook URL from [above](#humio-webhook) and Skip Cert Validation


### Create Alerts



Click on Alerts -> `+ New Alert`

Create the following Alerts as shown in the picture

![](./pics/humio2.png)

![](./pics/humio1.png)

❗**IMPORTANT**: Number `2` is especially important because otherwise the messages pushed to NOI get too big and NOI cannot ingest them.

#### BookinfoProblem

```yaml
"kubernetes.namespace_name" = bookinfo
| @rawstring = /Reviews Service: Error: Ratings Service is unavailable/

Last 5s

resource.name=\"ratings\" severity=Major resource.hostname=ratings type.eventType=\"bookinfo\"

Notification Frequency: 1 min
```

#### BookinfoRatingsDown

```yaml
"kubernetes.namespace_name" = bookinfo
| @rawstring = /Reviews Service: Error: Ratings Service is unavailable/

Last 5s

resource.name=\"ratings\" severity=Critical resource.hostname=ratings-v1 type.eventType=\"bookinfo\"

Notification Frequency: 1 min
```


#### BookinfoReviewsProblem

```yaml
"kubernetes.namespace_name" = bookinfo
| @rawstring = /Reviews Service: Error: Ratings Service is unavailable/

Last 5s

resource.name=\"reviews\" severity=Major resource.hostname=reviews-v2 type.eventType=\"bookinfo\"

Notification Frequency: 1 min
```

#### KubetoyLivenessProbe

```yaml
"kubernetes.namespace_name" = kubetoy | @rawstring = /I'm not feeling all that well./i


Last 20s

resource.name=\"kubetoy-deployment\" severity=Critical resource.hostname=kubetoy-deployment type.eventType=\"kubetoy\"

Notification Frequency: 1 min
```

#### KubetoyAvailabilityProblem

```yaml
"kubernetes.namespace_name" = kubetoy | @rawstring = /I'm not feeling all that well./i

Last 20s

resource.name=\"kubetoy-deployment\" severity=Major resource.hostname=kubetoy-service type.eventType=\"kubetoy\"

Notification Frequency: 1 min
```


#### RobotShopCataloguePodProblem

```yaml
"kubernetes.namespace_name" = "robot-shop"
| @rawstring = /"GET \/\/api\/catalogue\/categories HTTP\/1.1" 502 /i
| "kubernetes.container_name" = web-deployment

Last 5s

resource.name=\"catalogue\" severity=Critical resource.hostname=catalogue-pod type.eventType=\"robotshop\"

Notification Frequency: 1 min
```



#### RobotShopCatalogueProblem

```yaml
"kubernetes.namespace_name" = "robot-shop"
| @rawstring = /"GET \/\/api\/catalogue\/categories HTTP\/1.1" 502 /i
| "kubernetes.container_name" = web-deployment

Last 5s

resource.name=\"catalogue\" severity= Major resource.hostname=catalogue type.eventType=\"robotshop\"
Notification Frequency: 1 min
```


#### RobotShopWebProblem

```yaml
"kubernetes.namespace_name" = "robot-shop"
| @rawstring = /"GET \/\/api\/catalogue\/categories HTTP\/1.1" 502 /i
| "kubernetes.container_name" = web-deployment

Last 5s

resource.name=\"web\" severity=Minor resource.hostname=web-deployment type.eventType=\"robotshop\"

Notification Frequency: 1 min
```

#### RobotShopFrontendProblem

```yaml
"kubernetes.namespace_name" = "robot-shop"
| @rawstring = /"GET \/\/api\/catalogue\/categories HTTP\/1.1" 502 /i
| "kubernetes.container_name" = web-deployment

Last 5s

resource.name=\"web\" severity=Minor resource.hostname=web-deployment type.eventType=\"robotshop\"

Notification Frequency: 1 min
```


> You can test by creating a Notifier with https://webhook.site/


### Check Alerts

When you have defined your Alerts and Notifier you can test them by scaling down the pod:

1. Scale down:

	Bookinfo
	
	```bash
	oc scale --replicas=0  deployment ratings-v1 -n bookinfo
	```
	
	Robotshop
	
	```bash
	oc scale --replicas=0  deployment catalogue -n robot-shop
	```


2. Check Alerts:

	You should get some log lines matching the alert filter:
	
	![](./pics/humio3.png)
	
	If not, either you don't receive logs or your filters/alert definitions are wrong.
	
2. Check Notifications:

	You should get "Last triggered: ..." for each Alert:
	
	![](./pics/humio4.png)
	
	If not, your Notifier is incorrectly defined. Check the NOI Webhook URL.

3. Restore apps:

	Don't forget to scale them back up:
	
	Bookinfo
	
	```bash
	oc scale --replicas=0  deployment ratings-v1 -n bookinfo
	```
	
	Robotshop
	
	```bash
	oc scale --replicas=0  deployment catalogue -n robot-shop
	oc delete pod -n robot-shop $(oc get po -n robot-shop|grep catalogue|awk '{print$1}') --force --grace-period=0
	oc delete pod -n robot-shop $(oc get po -n robot-shop|grep user|awk '{print$1}') --force --grace-period=0
	
	```





---------------------------------------------------------------------------------------------------------------
## Connections from AI Manager (Ops Integration)
------------------------------------------------------------------------------


### ❗NEEDS UPDATING


### Create Humio Ops Integrations

Do this for Bookinfo and RobotShop

#### URL

Get the Humio Base URL from your browser

Add at the end `/api/v1/repositories/aiops/query`



#### Accounts Token

Get it from Humio --> Owl in the top right corner --> Your Account --> API Token

#### Filter

```yaml
"kubernetes.namespace_name" = bookinfo
| "kubernetes.container_name" = reviews
```

or

```yaml
 "kubernetes.namespace_name" = "robot-shop"
| "kubernetes.container_name" = web-deployment
```



#### Mapping

Check the mapping

```yaml
{
    "rolling_time": 10,
    "instance_id_field": "kubernetes.container_name",
    "log_entity_types": "kubernetes.namespace_name,kubernetes.container_hash,kubernetes.host,kubernetes.container_name,kubernetes.pod_name",
    "message_field": "@rawstring",
    "timestamp_field": "@timestamp"
}
```



---------------------------------------------------------------------------------------------------------------
## Configure Event Manager / ASM Topology
------------------------------------------------------------------------------

### ❗NEEDS UPDATING


### Create Observer to Load Topologies

* In NOI go into Administration --> Topology Management --> ObserverJobs --> Configure --> Add a new Job
* Select REST --> Configure
* Choose “listen”
* Set Unique ID to “listenJob” (important!)
* Set Provider to whatever you like (usually I set it to “listenJob” as well)
* Save

### Load Topologies for RobotShop and Bookinfo

```bash
cd demo
./load_topology.sh
```

Select option 1, 2 or 3.

This will create Topologies for one of the three Applications.


### Create Templates

Go to Netcool WebGUI
Administration-->Topology Template

Create a template for Bookinfo and RobotShop:

Bookinfo:
* Search for productpage-v1 (deployment)
* Create Topology 3 Levels
* Select Dynamic
* Enable "Correlate event groups on topologies from this template"
* Add tag `app:bookinfo`
* Save

RobotShop:
* Search for web (deployment)
* Create Topology 3 Levels
* Select Dynamic
* Enable "Correlate event groups on topologies from this template"
* Add tag `app:robotshop`
* Save

Kubetoy:
* Search for kubetoy (deployment)
* Create Topology 3 Levels
* Select Static
* Enable "Correlate event groups on topologies from this template"
* Save

> If you want to add templates to the Topology Dashboard just click the Star icon for the Topology you want included. 


### Create grouping Policy

* NetCool Web Gui --> Insights --> Scope Based Grouping
* Create Policy
* On `Alert Group`


---------------------------------------------------------------------------------------------------------------
## Configure Runbooks
------------------------------------------------------------------------------

### ❗NEEDS UPDATING

### Create Bastion Server

This creates a simple Pod with the needed tools (oc, kubectl) being used as a bastion host for Runbook Automation. 

```bash
kubectl apply -n default -f ./tools/6_bastion/create-bastion.yaml
```

### Create the NOI Integration

#### In NOI

* Go to  Administration --> Integration with other Systems --> Automation Type --> Script
* Copy the SSH KEY


#### Adapt SSL Certificate in Bastion Host Deployment. 

* Select the `bastion-host` Deployment in Namespace `default`
* Adapt Environment Variable SSH_KEY with the key you have copied above.



### Create Automation

Automation -->Runbooks --> Automations --> New Automation

Bookinfo

```bash
oc login --token=$token --server=$ocp_url
kubectl scale deployment --replicas=1 -n bookinfo ratings-v1
```


Robotshop

```bash
oc login --token=$token --server=$ocp_url
kubectl scale deployment --replicas=1 -n robot-shop mongodb
oc delete pod -n robot-shop $(oc get po -n robot-shop|grep catalogue|awk '{print$1}') --force --grace-period=0
oc delete pod -n robot-shop $(oc get po -n robot-shop|grep user|awk '{print$1}') --force --grace-period=0
```

Use these default values

```yaml
target: bastion-host-service.default.svc
user:   root
$token	 : Token from your login (ACCESS_DETAILS_XXX.md)	
$ocp_url : URL from your login (ACCESS_DETAILS_XXX.md, something like https://c102-e.eu-de.containers.cloud.ibm.com:32236)		
```


### Create Runbooks

**Kubetoy Liveness Probe**

```yaml
-------
Check if the Pod is still running
kubectl get pods -n NAMESPACE PODNAME 
If the return value is empty proceed with the next steps.

-------
Get the name of the Pod
kubectl get pods -n NAMESPACE | grep <your-pod-name>

-------
Check the logs
kubectl logs -n NAMESPACE kubetoy-deployment-<your-pod-id>

-------
Restart the pod if needed
kubectl delete pod -n NAMESPACE <your-pod-id>
```


**Bookinfo Reviews-Ratings**

Automated --> Use the Automation created above

** RobotShop Catalogue**

Automated --> Use the Automation created above




-------
### Add Runbook Triggers

Create new trigger for

* Kubetoy
* Bookinfo
* RobotShop

based on Alert Group




---------------------------------------------------------------------------------------------------------------
## Slack integration
------------------------------------------------------------------------------

### ❗NEEDS UPDATING

### Refresh ingress certificates (otherwise Slack will not validate link)

```bash
oc get secrets -n openshift-ingress | grep tls | grep -v router-metrics-certs-default | awk '{print $1}' | xargs oc get secret -n openshift-ingress -o yaml > tmpcert.yaml
cat tmpcert.yaml | grep " tls.crt" | awk '{print $2}' |base64 -d > cert.crt
cat tmpcert.yaml | grep " tls.key" | awk '{print $2}' |base64 -d > cert.key
ibm_nginx_pod=$(oc get pods -l component=ibm-nginx -o jsonpath='{ .items[0].metadata.name }')
oc exec ${ibm_nginx_pod} -- mkdir -p "/user-home/_global_/customer-certs"
oc cp cert.crt ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
oc cp cert.key ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
for i in `oc get pods -l component=ibm-nginx -o jsonpath='{ .items[*].metadata.name }' `; do oc exec ${i} -- /scripts/reload.sh; done
rm tmpcert.yaml cert.crt cert.key
```


### Integration 

More details are [here](https://pages.github.ibm.com/up-and-running/watson-aiops/End_to_End_Demo_2.1/setup_the_demo/slack/slack/) 

A copy of those instructions are here: ./4_integrations/slack

Thanks Robert Barron!

### Change the Slash Welcome Message (optional)

If you want to change the welcome message

```bash
oc set env deployment/$(oc get deploy -l app.kubernetes.io/component=chatops-slack-integrator -o jsonpath='{.items[*].metadata.name }') SLACK_WELCOME_COMMAND_NAME=/aiops-help
```





---------------------------------------------------------------------------------------------------------------
## Some Polishing
------------------------------------------------------------------------------


### Check if data is flowing

Get the kafkacat Certificate

```bash
mv ca.crt ca.crt.old
oc extract secret/strimzi-cluster-cluster-ca-cert -n zen --keys=ca.crt

oc get kafkatopic -n zen


export sasl_password=$(oc get secret token -n zen --template={{.data.password}} | base64 --decode)
export BROKER=$(oc get routes strimzi-cluster-kafka-bootstrap -n zen -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

kafkacat -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=token -X sasl.password=$sasl_password -b $BROKER -o beginning -C -t derived-stories 
```





# Check installation

Launch the `./12_check-aiops-install.sh` script to check some elements of the installation









