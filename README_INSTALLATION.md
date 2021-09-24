# CP4WatsonAIOps V3.1.1 Demo Environment Installation


## ❗ THIS IS WORK IN PROGRESS
Please drop me a note on Slack or by mail nikh@ch.ibm.com if you find glitches or problems.


# Changes

| Date  | Description  | Files  | 
|---|---|---|
|  22 Apr 2021 | 3.1 Preview install  | This is experimental!  |
|  27 Apr 2021 | Prerequisites  | `jq` and `kubectl` not needed anymore  |
|  28 Apr 2021 | New CatalogSource  | CatalogSource adapted for AIOps Catalog  |
|  29 Apr 2021 | Improved Topology Match  |  |
|  30 Apr 2021 | Demo Events Injection  | New generic method to simulate Events |
|  30 Apr 2021 | Hack for Incident Similarity Demo Training  |  ❗ Not officially supported  |
|  03 May 2021 | Removed Bookinfo from Scripts  |  ❗RobotShop is the way forward  |
|  04 May 2021 | Added training instructions  |  |
|  07 May 2021 | Official beta version  |  |
|  19 May 2021 | Various improvements  |  |
|  20 May 2021 | Updated instructions for Slack with Secure Gateway  |  |
|  21 May 2021 | Minor bugfixes and documentation improvements |  |
|  26 May 2021 | Pre-canned events and logs | No need to install and configure Humio unless you want live integration |
|  27 May 2021 | Added ServiceNow Integration |  |
|  10 June 2021 | Load logs for training directly into Elasticsearch |  |
|  16 June 2021 | Improved directory structure |  |
|  18 June 2021 | Improved directory structure for training |  |
|  25 June 2021 | Corrected some bugs (gsed, base64,openldap, ...) | Thanks Lawrence Gaalswyk & Robert Hunt |
|  6 July 2021 | Added filter for Fluentbit | Filters out logs from robotshop load (Thanks Luca Floris) |
|  7 July 2021 | Added labels to robotshop for Turbonomic grouping |  |
|  12 July 2021 | Corrected error with training dates | Thanks Fei Al Li |
|  13 July 2021 | Major overhaul of logging and config files |  |
|  19 July 2021 | Added some additional checks to avoid install problems |  |
|  29 July 2021 | Added Turbonomic install script and tools | Thanks Luca Floris for reviewing this and finding bugs (a lot!) |
|  23 August 2021 | Tested for 3.1.1 | |
|  30 August 2021 |Updated and tested uninstall scripts  | |
|  31 August 2021 | Added new version of Turbo-->NOI gateway  | Thanks to Luca Floris for the cool enhancments|
|  01 September 2021 | New debug script  | 20_debug_install.sh |
|  02 September 2021 | Added script to install prerequisites  | For Mac and Ubuntu |
|  06 September 2021 | Bug fixes and stability improvement |  |
|  07 September 2021 | Adapted patching for IAF in install script | https://www.ibm.com/docs/en/cloud-paks/1.0?topic=issues-operator-pods-crashing-during-installation |
|  08 September 2021 | Fixed debug script | Crushed some bugs and the script can now check a stuck install and propose (some) solutions |
|  09 September 2021 | Changes to enforce oc 4.7 or greater | Thanks Leon Carvajal |
|  10 September 2021 | Corrected issues with IAF 1.2 |  |
|  13 September 2021 | Corrected issues with kafkacat/kcat | Thanks Eva Ramon |
|  22 September 2021 | Corrected some bugs in the debug script | Thanks Henning Sternkicker |
|  24 September 2021 | Corrected some bugs in the debug script | Thanks Philippe Thomas |
|  24 September 2021 | First beta release of Ansible version in the new repository | [https://github.ibm.com/NIKH/aiops-install-ansible](https://github.ibm.com/NIKH/aiops-install-ansible) |
|   |   |   | 

> ❗This demo supports pre-canned events and logs, so you don't need to install and configure Humio.


---------------------------------------------------------------
# Installation
---------------------------------------------------------------

1. [Prerequisites](#1-prerequisites)
1. [Architecture](#2-architecture)
1. [AI and Event Manager Base Install](#3-ai-and-event-manager-base-install)
1. [Configure Applications and Topology](#4-configure-applications-and-topology)
1. [Configure Event Manager](#5-configure-event-manager)
1. [Training](#6-training)
1. [Configure Runbooks](#7-configure-runbooks)
1. [Slack integration](#8-slack-integration)
1. [Service Now integration](#9-service-now-integration)
1. [Some Polishing](#10-some-polishing)
1. [Demo the Solution](#11-demo-the-solution)
1. [Installing Turbonomic](#12-installing-turbonomic)
1. [Check Installation](#13-check-installation)
1. [Troubleshooting](#14-troubleshooting)
1. [Uninstall CP4WAIOPS](#15-uninstall)
1. [Installing Humio (optional)](#16-humio)




1. [Connections from AI Manager (Ops Integration)](#4-connections-from-ai-manager-ops-integration)





1. [Service Now integration](#10-service-now-integration)


> ❗You can find a handy install checklist here: [INSTALLATION CHECKLIST](./README_INSTALLATION_CHECKLIST.md).



---------------------------------------------------------------
## Introduction
---------------------------------------------------------------

### ❗ I'm in the process of porting the scripts to Ansible in the following repo [https://github.ibm.com/NIKH/aiops-install-ansible](https://github.ibm.com/NIKH/aiops-install-ansible).

### ❗ In the near future I will stop updating the shell scripts in this repository and only be updating the Ansible scripts going forward.


This repository documents the progress of me learning to build a Watson AIOps demo environment.

This is provided `as-is`:

* I'm sure there are errors
* I'm sure it's not complete
* It clearly can be improved

So please if you have any feedback contact me 

- on Slack: Niklaus Hirt or
- by Mail: nikh@ch.ibm.com


**❗This has been tested for the new CP4WAIOPS 3.1.1 release on OpenShift 4.7.**



---------------------------------------------------------------
## 1. Prerequisites
---------------------------------------------------------------


### 1.1 OpenShift requirements

I installed the demo in a ROKS environment.

You'll need:

- ROKS 4.7 (4.6 should work also, but has not been tested)
- 5x worker nodes Flavor `b3c.16x64` (so 16 CPU / 64 GB)

You might get away with less if you don't install some components (Humio, Turbonomic,...)


### 1.2 Docker Pull secret

####  ❗⚠️ Make a copy of the secret before modifying  
We learnt this the hard way...

```bash
oc get secret -n openshift-config pull-secret -oyaml > pull-secret_backup.yaml
```

or more elegant

```bash
oc get Secret -n openshift-config pull-secret -ojson | jq 'del(.metadata.annotations, .metadata.creationTimestamp, .metadata.generation, .metadata.managedFields, .metadata.resourceVersion , .metadata.selfLink , .metadata.uid, .status)' > pull-secret_backup.json
```

In order to avoid errors with Docker Registry pull rate limits, you should add your Docker credentials to the Cluster.
This can occur especially with Rook/Ceph installation.

* Go to Secrets in Namespace `openshift-config`
* Open the `pull-secret`Secret
* Select `Actions`/`Edit Secret` 
* Scroll down and click `Add Credentials`
* Enter your Docker credentials

	![](./pics/dockerpull.png)

* Click Save

If you already have Pods in ImagePullBackoff state then just delete them. They will recreate and should pull the image correctly.
 

### 1.3 Tooling

You need the following tools installed in order to follow through this guide:

- gnu-sed (on Mac)
- oc (4.7 or greater)
- jq
- kubectl (Not needed anymore - replaced by `oc`)
- kafkacat
- elasticdump
- helm 3
- IBM cloudctl


#### 1.3.1 On Mac - Automated (preferred)
You can either run:

```
sudo ./13_install_prerequisites_mac.sh
```

##### 1.3.1.1 On Mac - Manual

Or install them manually:


```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gnu-sed
brew install kafkacat
brew install node
npm install elasticdump -g
brew install jq

curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-darwin-amd64.tar.gz -o cloudctl-darwin-amd64.tar.gz
tar xfvz cloudctl-darwin-amd64.tar.gz
sudo mv cloudctl-darwin-amd64 /usr/local/bin/cloudctl
rm cloudctl-darwin-amd64.tar.gz


wget -L https://get.helm.sh/helm-v3.6.3-darwin-amd64.tar.gz -O helm.tar.gz
tar xfvz helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo rm -r linux-amd64/
sudo rm helm.tar.gz


```


Get oc and kubectl (optional) from [here](https://github.com/openshift/okd/releases/)

or use :

```bash
wget https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-07-03-190901/openshift-client-mac-4.7.0-0.okd-2021-07-03-190901.tar.gz -O oc.tar.gz
tar xfzv oc.tar.gz
sudo mv oc /usr/local/bin
sudo mv kubectl /usr/local/bin.  (this is optional)
rm oc.tar.gz
rm README.md
```



I highly recomment installing the `k9s` tool :

```bash
wget https://github.com/derailed/k9s/releases/download/v0.24.15/k9s_Darwin_x86_64.tar.gz
tar xfzv k9s_Linux_x86_64.tar.gz
sudo mv k9s /usr/local/bin
rm LICENSE
rm README.md
```



#### 1.3.2 On Ubuntu Linux - Automated (preferred) 



For Ubuntu you can either run (for other distros you're on your own, sorry):

```
sudo ./14_install_prerequisites_ubuntu.sh
```


##### 1.3.2.1 On Ubuntu Linux - Manual

Or install them manually:


`sed` comes preinstalled

```bash
sudo apt-get install -y kafkacat

sudo apt-get install -y npm

sudo apt-get install -y jq

sudo npm install elasticdump -g

curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz -o cloudctl-linux-amd64.tar.gz
tar xfvz cloudctl-linux-amd64.tar.gz
sudo mv cloudctl-linux-amd64 /usr/local/bin/cloudctl
rm cloudctl-linux-amd64.tar.gz

wget -L https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz -O helm.tar.gz
tar xfvz helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo rm -r linux-amd64/
sudo rm helm.tar.gz
```

Get oc and oc from [here](https://github.com/openshift/okd/releases/)

or use :

```bash
wget https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-07-03-190901/openshift-client-linux-4.7.0-0.okd-2021-07-03-190901.tar.gz -O oc.tar.gz
tar xfzv oc.tar.gz
sudo mv oc /usr/local/bin
sudo mv kubectl /usr/local/bin
rm oc.tar.gz
rm README.md
```

I highly recomment installing the `k9s` tool :

```bash
wget https://github.com/derailed/k9s/releases/download/v0.24.15/k9s_Linux_x86_64.tar.gz
tar xfzv k9s_Linux_x86_64.tar.gz
sudo mv k9s /usr/local/bin
rm LICENSE
rm README.md
```



### 1.4 Get the scripts and code from GitHub


#### 1.4.1 Clone the GitHub Repository (preferred)

And obviosuly you'll need to download this repository to use the scripts.


```
git clone https://<YOUR GIT TOKEN>@github.ibm.com/NIKH/aiops-3.1.git 
```

You can create your GIT token [here](https://github.ibm.com/settings/tokens).

##### 1.4.1.1 Refresh the code from GitHub

Make sure you have the latest version:

```
git checkout origin/master -f | git checkout master -f | git pull origin master
```

Or create an alias for reuse:

```
alias gitrefresh='git checkout origin/master -f | git checkout master -f | git pull origin master'
```

#### 1.4.2 Download the GitHub Repository in a ZIP (not preferred)

Simply click on the green `CODE` button and select `Download Zip` to download the scripts and code.

❗ If there are updates you have to re-download the ZIP.




### 1.5 Specifically on Fyre

#### 1.5.1 Adapt Hosts file


When using IBM Fyre on Mac you have to adapt your Hosts file.

- Get the IP address of your Cluster 

	```bash
	ping api.<your-fyre-url>
	
		EXAMPLE: 
		ping api.dteocp-270003bu3k-vyvrs.cp.fyre.ibm.com -c1
		
		PING cp-console.apps.dteocp-270003bu3k-vyvrs.cp.fyre.ibm.com (9.30.91.173): 56 data bytes
		64 bytes from 9.30.91.173: icmp_seq=0 ttl=52 time=236.575 ms
	```

- Update Hosts file

	```bash
	vi /etc/hosts or
	nano /etc/hosts
	```
	
- Add the following
	
	```bash	
	<IP from above> cp-console.<your-fyre-url> api.<your-fyre-url>
	
	
		EXAMPLE: 
		9.30.91.173   cp-console.apps.dteocp-270003bu3k-vyvrs.cp.fyre.ibm.com api.dteocp-270003bu3k-vyvrs.cp.fyre.ibm.com
	```


#### 1.5.2 Storage Requirements

❗**The only officially supported storage solution for production installations is Portworx Enterprise
**
The instructions only apply for demo installations!


Please make sure that an appropriate StorageClass is available (you will have to parametrize those as described in [Adapt configuration](#adapt-configuration))

- On IBM ROKS use: ibmc-file-gold-gid
- On TEC use:      nfs-client
- On FYRE use:     rook-cephfs 

#### ❗Required for installations on IBM Fyre
⚠️ **If you don't have a StorageClass, you can install Rook/Ceph with `./22_install_rook.sh`.**
            

---------------------------------------------------------------
## 2. Architecture
---------------------------------------------------------------


### 2.1 Basic Architecture
 
The environement (Kubernetes, Applications, ...) create logs that are being fed into a Log Management Tool (Humio in this case).

![](./pics/aiops-demo.png)

1. External Systems generate Alerts and send them into the Event Manager (Netcool Operations Insight), which in turn sends them to the AI Manager for Event Grouping.
1. At the same time AI Manager ingests the raw logs coming from the Log Management Tool (Humio) and looks for anomalies in the stream based on the trained model.
1. If it finds an anomaly it forwards it to the Event Grouping as well.
1. Out of this, AI Manager creates a Story that is being enriched with Topology (Localization and Blast Radius) and with Similar Incidents that might help correct the problem.
1. The Story is then sent to Slack.
1. A Runbook is available to correct the problem but not launched automatically.


### 2.2 Optimized Demo Architecture

![](./pics/aiops-demo3.png)

For the this specific Demo environment:

* Humio is not needed as I am using pre-canned logs for training and for the anomaly detection (inception)
* The Events are also created from pre-canned content that is injected into Event Manager
* There is also pre-canned ServiceNow Incidents if you don’t want to do the live integration with SNOW
* The WebPages that are reachable from the Events are static and hosted on my GitHub
* The same goes for ServiceNow Incident pages if you don’t integrate with live SNOW

This allows us to:

* Install the whole Demo Environment in a self-contained OCP Cluster
* Trigger the Anomalies reliably
* Get Events from sources that would normally not be available (Instana, Turbonomic, Metrics Manager, ...)
* Show some examples of SNOW integration without a live system



---------------------------------------------------------------
## 3. AI and Event Manager Base Install
---------------------------------------------------------------

### 3.1 Adapt configuration

Adapt the 01_config-install.sh file with the desired parameters:

#### 3.1.1 Adapt Storage Class

```bash
# CP4WAIOPS Storage Class (ibmc-file-gold-gid, rook-cephfs, nfs-client, ...)
export WAIOPS_STORAGE_CLASS_FILE=ibmc-file-gold-gid         # ROKS
#export WAIOPS_STORAGE_CLASS_FILE=rook-cephfs               # FYRE
#export WAIOPS_STORAGE_CLASS_FILE=nfs-client                # TEC
    

# CP4WAIOPS Large Storage Class (ibmc-file-gold-gid, rook-cephfs, nfs-client, ...)
export WAIOPS_STORAGE_CLASS_LARGE_BLOCK=ibmc-file-gold-gid  # ROKS
#export WAIOPS_STORAGE_CLASS_LARGE_BLOCK=rook-cephfs        # FYRE
#export WAIOPS_STORAGE_CLASS_LARGE_BLOCK=nfs-client         # TEC

```

#### 3.1.1 Adapt Optional Components

> ❗This demo supports pre-canned events and logs, so you don't need to install and configure Humio unless you want to do a live integration (only partially covered in this document).


```bash
# Install Turbonomic (experimental - needs separate license)
export INSTALL_TURBO=false
        
# Install Humio (needs separate license)
export INSTALL_HUMIO=false

# Install LDAP Server
export INSTALL_LDAP=true

# Demo Applications
export INSTALL_DEMO=true

```

Make sure that you are logged into your cluster!


### 3.2 Get the installation token

You can get the installation (pull) token from [https://myibm.ibm.com/products-services/containerlibrary](https://myibm.ibm.com/products-services/containerlibrary).

This allows the CP4WAIOPS images to be pulled from the IBM Container Registry.

This token is being referred to as <PULL_SECRET_TOKEN> below and should look something like this (this is NOT a valid token):

```yaml
eyJhbGciOiJIUzI1NiJ9.eyJpc3adsgJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE1Nzg0NzQzMjgsImp0aSI6IjRjYTM3gsdgdMzExNjQxZDdiMDJhMjRmMGMxMWgdsmZhIn0.Z-rqfSLJA-R-ow__tI3RmLx4mssdggdabvdcgdgYEkbYY  
```


### 3.3 Start installation

Just run:

```bash
./10_install_aiops.sh -t <PULL_SECRET_TOKEN>


Example:
./10_install_aiops.sh -t eyJhbGciOiJIUzI1NiJ9.eyJpc3adsgJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE1Nzg0NzQzMjgsImp0aSI6IjRjYTM3gsdgdMzExNjQxZDdiMDJhMjRmMGMxMWgdsmZhIn0.Z-rqfSLJA-R-ow__tI3RmLx4mssdggdabvdcgdgYEkbYY
```

This will install:

- Knative
- Strimzi
- CP4WAIOPS


### 3.4 Post-installation 

The above script will automatically launch the post-installation:

- Turbonomic (if enabled)
- Humio (if enabled)
- OpenLDAP
- Demo Apps
- Register LDAP Users
- Gateway
- Housekeeping
	- Additional Routes (Topology, Flink, Strimzi)
	- Create OCP User (serviceaccount demo-admin)
	- Patch Ingress
	- Adapt NGINX Certificates
	- Adapt Slack Welcome message to /welcome






### 3.5 Re-running post-installation

In some cases it might be that the post-installation tasks does not run through for some reason (CRD not ready, Pod not running yet,...).

> ### ❗ **IMPORTANT:** You have to re-run the `11_postinstall_aiops.sh` script until it completes!

**It is safe to re-run the post-installation script as many times as needed**:

```bash
./11_postinstall_aiops.sh
```


### 3.6 Get Passwords and Credentials

At any moment you can run `./80_get_logins.sh` that will print out all the relevant passwords and credentials.

Usually it's a good idea to store this in a file for later use:

```bash
./80_get_logins.sh > my_credentials.txt
```

### 3.7 Check status of installation

At any moment you can run `./81_check-aiops-install.sh` to check on installation progress.




---------------------------------------------------------------
## 4. Configure Applications and Topology
---------------------------------------------------------------



### 4.1 Create Kubernetes Observer for the Demo Applications

Do this for your applications (RobotShop by default)

* In CP4WAIOPS go into `Define` / `Data and tool integrations` / `Advanced` / `Manage ObserverJobs` / `Add a new Job`
* Select `Kubernetes` / `Configure`
* Choose “local”
* Set Unique ID to `<app-namespace>` (robot-shop,...)
* Set Datacenter (I use "demo")
* Set `Correlate` to `true`
* Set Namespace to `<app-namespace>` (robot-shop, ...)
* Set Provider to whatever you like (usually I set it to “listenJob” as well)
* `Save`


### 4.2 Create REST Observer to Load Topologies

* In CP4WAIOPS go into `Define` / `Data and tool integrations` / `Advanced` / `Manage ObserverJobs` / `Add a new Job`
* Select `REST`/ `Configure`
* Choose “bulk_replace”
* Set Unique ID to “listenJob” (important!)
* Set Provider to whatever you like (usually I set it to “listenJob” as well)
* `Save`



### 4.3 Create Merge Rules for Kubernetes Observer

Launch the following:

```bash
./tools/5_topology/create-merge-rules.sh
```


### 4.4 Load Merge Topologies

This will load the overlay topology for RobotShop:

```bash
./tools/5_topology/create-merge-topology-robotshop.sh

```

This will create Merge Topologies for RobotShop.

❗ Please manually re-run the Kubernetes Observer to make sure that the merge has been done.


### 4.5 Create AIOps Application

#### Robotshop

* In CP4WAIOPS go into `Operate` / `Application Management` 
* Click `Create Application`
* Select `robot-shop` namespace
* Click `Add to Application`
* Name your Application (RobotShop)
* If you like check `Mark as favorite`
* Click `Save`







---------------------------------------------------------------
## 5. Configure Event Manager
---------------------------------------------------------------

### 5.1 Event Manager Webhooks

Create Webhooks in Event Manager for Event injection and incident simulation for the Demo.

The demo scripts (in the `demo` folder) give you the possibility to simulate an outage without relying on the integrations with other systems.

At this time it simulates:
- Git push event
- Log Events (Humio)
- Security Events (Falco)
- Instana Events
- Metric Manager Events (Predictive)
- Turbonomic Events
- CP4MCM Synthetic Selenium Test Events




#### 5.1.1 Generic Demo Webhook

You have to define the following Webhook in Event Manager (NOI): 

* `Administration` / `Integration with other Systems`
* `Incoming` / `New Integration`
* `Webhook`
* Name it `Demo Generic`
* Jot down the WebHook URL and copy it to the `NETCOOL_WEBHOOK_GENERIC` in the `00_config-secrets.sh`file
* Click on `Optional event attributes`
* Scroll down and click on the + sign for `URL`
* Click `Confirm Selections`



Use this json:

```json
{
  "timestamp": "1619706828000",
  "severity": "Critical",
  "summary": "Test Event",
  "nodename": "productpage-v1",
  "alertgroup": "robotshop",
  "url": "https://pirsoscom.github.io/grafana-robotshop.html"
}
```

Fill out the following fields and save:

* Severity: `severity`
* Summary: `summary`
* Resource name: `nodename`
* Event type: `alertgroup`
* Url: `url`
* Description: `"URL"`

Optionnally you can also add `Expiry Time` from `Optional event attributes` and set it to a convenient number of seconds (just make sure that you have time to run the demo before they expire.


### 5.2 Create custom Filter and View in NOI (optional)

#### 5.2.1 Filter

Duplicate the `Default` filter and set to global.

* Name: AIOPS
* Logic: **Any** (!)
* Filter:
	* AlertGroup = 'CEACorrelationKeyParent'
	* AlertGroup = 'robot-shop'

#### 5.2.2 View

Duplicate the `Example_IBM_CloudAnalytics` View and set to global.


* Name: AIOPS

Configure to your likings.


### 5.3 Create Templates for Topology Grouping (optional)

This gives you probale cause and is not strictly needed if you don't show Event Manager!

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`Topology Viewer`
* Then, in the top right corner, click on the icon with the three squares (just right of the cog)
* Select `Create a new Template`
* Select `Dynamic Template`

Create a template for RobotShop:

* Search for `web-deployment` (deployment)
* Create Topology 3 Levels
* Name the template (robotshop)
* Select `Namespace` in `Group type`
* Enter `robotshop_` for `Name prefix`
* Select `Application` 
* Add tag `namespace:robot-shop`
* Save




### 5.4 Create grouping Policy

* NetCool Web Gui --> `Insights` / `Scope Based Grouping`
* Click `Create Policy`
* `Action` select fielt `Alert Group`
* Toggle `Enabled` to `On`
* Save

### 5.5 Create NOI Menu item - Open URL

in the Netcool WebGUI

* Go to `Administration` / `Tool Configuration`
* Click on `LaunchRunbook`
* Copy it (the middle button with the two sheets)
* Name it `Launch URL`
* Replace the Script Command with the following code

	```javascript
	var urlId = '{$selected_rows.URL}';
	
	if (urlId == '') {
	    alert('This event is not linked to an URL');
	} else {
	    var wnd = window.open(urlId, '_blank');
	}
	```
* Save

Then 

* Go to `Administration` / `Menu Configuration`
* Select `alerts`
* Click on `Modify`
* Move Launch URL to the right column
* Save

---------------------------------------------------------------
## 6. Training
---------------------------------------------------------------
### 6.1 Train Log Anomaly - RobotShop


#### 6.1.1 Create Kafka Training Integration

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`Data and tool integrations`
* Under `Kafka`, click on `Add Integration`
* Name it `HumioInject`
* Select `Data Source` / `Logs`
* Select `Mapping Type` / `Humio`
* Paste the following in `Mapping` (the default is **incorrect**!:

	```json
	{
	"codec": "humio",
	"message_field": "@rawstring",
	"log_entity_types": "kubernetes.namespace_name,kubernetes.container_hash,kubernetes.host,kubernetes.container_name,kubernetes.pod_name",
	"instance_id_field": "kubernetes.container_name",
	"rolling_time": 10,
	"timestamp_field": "@timestamp"
	}
	```
	
* Toggle `Data Flow` to the `ON` position
* Select `Data feed for initial AI Training`
* Click `Save`

#### 6.1.2 Load Training Data into Kafka (Option 1: faster)

1. First unzip the file robotshop-12h.zip
	
	```bash
	cd ./training/TRAINING_FILES/KAFKA/robot-shop/logs
	unzip robotshop-12h.zip
	cd -
	```


1. Run the script to inject training data:
	
	```bash
	./training/robotshop-train-logs.sh
	```
	This takes some time (20-60 minutes depending on your Internet speed).




#### 6.1.2.1 Load Training Data directly into ElasticSearch (Option 2: Slower)

1. First unzip the file robotshop-logtrain.zip
	
	```bash
	cd ./training/TRAINING_FILES/ELASTIC/robot-shop/logs/
	unzip robotshop-logtrain.zip
	cd -
	```

1. Run this command in a separate terminal window to gain access to the Elasticsearch cluster:

	```bash
	while true; do oc port-forward statefulset/$(oc get statefulset | grep es-server-all | awk '{print $1}') 9200; done
	```


1. Run the script to inject training data:
	
	```bash
	./training/robotshop-train-logs-es.sh
	```
	This takes some time (40-90 minutes depending on your Internet speed).


If you want to check if the training data has been loaded you can execute (make sure you're on your aiops project/namespace):

```bash
oc exec -it $(oc get po |grep aimanager-aio-ai-platform-api-server|awk '{print$1}') -- bash


bash-4.4$ curl -u elastic:$ES_PASSWORD -XGET https://elasticsearch-ibm-elasticsearch-ibm-elasticsearch-srv.<YOUR WAIOPS NAMESPACE>.svc.cluster.local:443/_cat/indices  --insecure | grep logtrain | sort
```

You should get something like this (for 20210505 and 20210506):

```bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2716  100  2716    0     0   9769      0 --:--:-- --:--:-- --:--:--  9769
yellow open 1000-1000-20210505-logtrain      06XVqpPTTlCPYlIfZqr-bA 1 1 315652 0  94.2mb  94.2mb
yellow open 1000-1000-20210506-logtrain      slP32RncT-eCEPiUPWrDDg 1 1 385026 0 114.4mb 114.4mb
```


#### 6.1.3 Create Training Definition

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`AI model management`
* Select `Log anomaly detection`
* Select `Create Training Definition`
* Select `Add Data`
* Select `05/05/21` (May 5th 2021 - dd/mm/yy) to `07/05/21` (May 7th 2021) as date range (this is when the logs we're going to inject have been created)
* Click `Next`
* Name it "LogAnomaly"
* Click `Next`
* Click `Create`


#### 6.1.4 Train the model

* In the training definition click on `Actions` / `Start Training`
* This will start a precheck that should tell you after a while that you are ready for training
* Click on `Actions` / `Start Training` again

After successful training you should get: 

![](./pics/training1.png)

* In the training definition click on `Actions` / `Deploy`


⚠️ If the training shows errors, please make sure that the date range of the training data is set to May 5th 2021 through May 7th 2021 (this is when the logs we're going to inject have been created)

#### 6.1.5 Enable Log Anomaly detection


* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`Data and tool integrations`
* Under `Kafka`, click on `2 integrations`
* Select `HumioInject`
* Scroll down and select `Data feed for continuous AI training and anomaly detection`
* Switch `Data Flow` to `on`
* Click `Save`



### 6.2 Train Event Grouping



#### 6.2.1 Create Integration

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`Data and tool integrations`
* Under `Kafka`, click on `1 integration`
* Select `noi-default`
* Scroll down and select `Data feed for initial AI Training`
* Toggle `Data Flow` to the `ON` position
* Click `Save`

#### 6.2.2 Load Kafka Training Data

First we have to create some Events to train on.

* Make sure that you have pasted the Webhook (Generic Demo Webhook) from above into the file `./00_config-secrets.sh` for the variable `NETCOOL_WEBHOOK_GENERIC`.
* Run the Event Generation for 2-3 minutes. Then quit with `Ctrl-C`.
	
	```bash
	./training/robotshop-train-events.sh
	```

#### 6.2.3 Create Training Definition

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`AI model management`
* Select `Event grouping service`
* Select `Create Training Definition`
* Select `Add Data`
* Select `Last 90 Days` but set the end date to tomorrow
* Click `Next`
* Name it "EventGrouping"
* Click `Next`
* Click `Create`


#### 6.2.4 Train the model

* In the training definition click on `Actions` / `Start Training`

After successful training you should get: 

![](./pics/training2.png)

The "Needs improvement" is no concern for the time being.

* In the training definition click on `Actions` / `Deploy`

#### 6.2.5 Enable Event Grouping

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`Data and tool integrations`
* Under `Kafka`, click on `1 integration`
* Select `noi-default`
* Scroll down and select `Data feed for continuous AI training and anomaly detection`
* Switch `Data Flow` to `on`








### 6.3 Train Incident Similarity

### ❗ Only needed if you don't plan on doing the Service Now Integration

#### 6.3.1 Load Training Data directly into ElasticSearch



1. Run this command in a separate terminal window to gain access to the Elasticsearch cluster:

	```bash
	while true; do oc port-forward statefulset/$(oc get statefulset | grep es-server-all | awk '{print $1}') 9200; done
	```


1. Run the script to inject training data:
	
	```bash
	./training/robotshop-train-incidents.sh
	```
	This should not take more than 15-20 minutes.

	If you get asked if you want to Replace or Append, just choose Append.

If you want to check if the training data has been loaded you can execute (make sure you're on your aiops project/namespace):

```bash
oc exec -it $(oc get po |grep aimanager-aio-ai-platform-api-server|awk '{print$1}') -- bash


bash-4.4$ curl -u elastic:$ES_PASSWORD -XGET https://elasticsearch-ibm-elasticsearch-ibm-elasticsearch-srv.<YOUR WAIOPS NAMESPACE>.svc.cluster.local:443/_cat/indices  --insecure | grep incidenttrain | sort
```

You should get something like this (for 20210505 and 20210506):

```bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  4841  100  4841    0     0  28644      0 --:--:-- --:--:-- --:--:-- 28644
yellow open incidenttrain                        X6FAhONnRrGzHy9qOVIk8Q 1 1    139   0 142.9kb 142.9kb
```


#### 6.3.2 Create Training Definition

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`AI model management`
* Select `Similar incidents`
* Select `Create Training Definition`
* Click `Next`
* Name it "SimilarIncidents"
* Click `Next`
* Click `Create`


#### 6.3.3 Train the model

* In the training definition click on `Actions` / `Start Training`
* This will start a precheck that should tell you after a while that you are ready for training and start the training


After successful training you should get: 

![](./pics/training3.png)

* In the training definition click on `Actions` / `Deploy`











---------------------------------------------------------------
## 7. Configure Runbooks
---------------------------------------------------------------


### 7.1 Create Bastion Server

This creates a simple Pod with the needed tools (oc, kubectl) being used as a bastion host for Runbook Automation. 

```bash
oc apply -n default -f ./tools/6_bastion/create-bastion.yaml
```

### 7.2 Create the NOI Integration

#### 7.2.1 In NOI

* Go to  `Administration` / `Integration with other Systems` / `Automation Type` / `Script`
* Copy the SSH KEY


#### 7.2.2 Adapt SSL Certificate in Bastion Host Deployment. 

* Select the `bastion-host` Deployment in Namespace `default`
* Adapt Environment Variable SSH_KEY with the key you have copied above.



### 7.3 Create Automation


#### 7.3.1 Connect to Cluster
`Automation` / `Runbooks` / `Automations` / `New Automation`


```bash
oc login --token=$token --server=$ocp_url
```

Use these default values

```yaml
target: bastion-host-service.default.svc
user:   root
$token	 : Token from your login (from 80_get_logins.sh)	
$ocp_url : URL from your login (from 80_get_logins.sh, something like https://c102-e.eu-de.containers.cloud.ibm.com:32236)		
```


#### 7.3.2 RobotShop Mitigate MySql
`Automation` / `Runbooks` / `Automations` / `New Automation`


```bash
oc scale deployment --replicas=1 -n robot-shop ratings
oc delete pod -n robot-shop $(oc get po -n robot-shop|grep ratings |awk '{print$1}') --force --grace-period=0
```

Use these default values

```yaml
target: bastion-host-service.default.svc
user:   root		
```


### 7.4 Create Runbooks


* `Library` / `New Runbook`
* Name it `Mitigate RobotShop Problem`
* `Add Automated Step`
* Add `Connect to Cluster`
* Select `Use default value` for all parameters
* Then `RobotShop Mitigate Ratings`
* Select `Use default value` for all parameters
* Click `Publish`



-------
### 7.5 Add Runbook Triggers

* `Triggers` / `New Trigger`
* Name and Description: `Mitigate RobotShop Problem`
* Conditions
	* Name: RobotShop
	* Attribute: Node
	* Operator: Equals
	* Value: mysql-deployment or web
* Click `Run Test`
* You should get an Event `[Instana] Robotshop available replicas is less than desired replicas - Check conditions and error events - ratings`
* Select `Mitigate RobotShop Problem`
* Click `Select This Runbook`
* Toggle `Execution` / `Automatic` to `off`
* Click `Save`




---------------------------------------------------------------
## 8. Slack integration
---------------------------------------------------------------

### 8.1 Initial Slack Setup 

For the system to work you need to setup your own secure gateway and slack workspace. It is suggested that you do this within the public slack so that you can invite the customer to the experience as well. It also makes it easier for is to release this image to Business partners

You will need to create your own workspace to connect to your instance of CP4WAOps.

Here are the steps to follow:

1. [Create Slack Workspace](./tools/3_slack/1_slack_workspace.md)
1. [Create Slack App](./tools/3_slack/2_slack_app_create.md)
1. [Create Slack Channels](./tools/3_slack/3_slack_channel.md)
1. [Create Slack Integration](./tools/3_slack/4_slack_integrate.md)
1. [Get the Integration URL - Public Cloud - ROKS](./tools/3_slack/5_slack_url_public.md) OR 
1. [Get the Integration URL - Private Cloud - Fyre/TEC](./tools/3_slack/5_slack_url_private.md)
1. [Create Slack App Communications](./tools/3_slack/6_slack_app_integration.md)
1. [Prepare Slack Reset](./tools/3_slack/7_slack_reset.md)





### 8.2 NGNIX Certificate for V3.1.1 - If the integration is not working


In order for Slack integration to work, there must be a signed certicate on the NGNIX pods. The default certificate is self-signed and Slack will not accept that. The method for updating the certificate has changed between AIOps v2.1 and V3.1.1. The NGNIX pods in V3.1.1 mount the certificate through a secret called `external-tls-secret` and that takes precedent over the certificates staged under `/user-home/_global_/customer-certs/`.

For customer deployments, it is required for the customer to provide their own signed certificates. An easy workaround for this is to use the Openshift certificate when deploying on ROKS. **Caveat**: The CA signed certificate used by Openshift is automatically cycled by ROKS (I think every 90 days), so you will need to repeat the below once the existing certificate is expired and possibly reconfigure Slack.

#### 8.2.1 New Method (Preferred)

This method replaces the existing secret/certificate with the one that OpenShift ingress uses, not altering the NGINX deployment. An important note, these instructions are for configuring the certificate post-install. Best practice is to follow the installation instructions for configuring certificates during that time.

The custom resource `AutomationUIConfig/iaf-system` controls the certificates and the NGINX pods that use those certificates. Any direct update to the certificates or pods will eventually get overwritten, unless you first reconfigure `iaf-system`. It's a bit tricky post-install as you will have to recreate the `iaf-system` resource quickly after deleting it, or else the installation operator will recreate it. For this reason it's important to run all the commands one after the other. **Ensure that you are in the project for AIOps**, then paste all the code on your command line to replace the `iaf-system` resource.

```bash
NAMESPACE=$(oc project -q)
IAF_STORAGE=$(oc get AutomationUIConfig -n $NAMESPACE -o jsonpath='{ .items[*].spec.storage.class }')
oc get -n $NAMESPACE AutomationUIConfig iaf-system -oyaml > iaf-system-backup.yaml
oc delete -n $NAMESPACE AutomationUIConfig iaf-system
cat <<EOF | oc apply -f -
apiVersion: core.automation.ibm.com/v1beta1
kind: AutomationUIConfig
metadata:
  name: iaf-system
  namespace: $NAMESPACE
spec:
  description: AutomationUIConfig for cp4waiops
  license:
    accept: true
  version: v1.0
  storage:
    class: $IAF_STORAGE
  tls:
    caSecret:
      key: ca.crt
      secretName: external-tls-secret
    certificateSecret:
      secretName: external-tls-secret
EOF
```

Again, **ensure that you are in the project for AIOps** and run the following to replace the existing secret with a secret containing the OpenShift ingress certificate.

```bash
NAMESPACE=$(oc project -q)
# collect certificate from OpenShift ingress
ingress_pod=$(oc get secrets -n openshift-ingress | grep tls | grep -v router-metrics-certs-default | awk '{print $1}')
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.crt"}}' ${ingress_pod} | base64 -d > cert.crt
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.key"}}' ${ingress_pod} | base64 -d > cert.key
# backup existing secret
oc get secret -n $NAMESPACE external-tls-secret -o yaml > external-tls-secret.yaml
# delete existing secret
oc delete secret -n $NAMESPACE external-tls-secret
# create new secret
oc create secret generic -n $NAMESPACE external-tls-secret --from-file=cert.crt=cert.crt --from-file=cert.key=cert.key --dry-run=client -o yaml | oc apply -f -
# scale down nginx
REPLICAS=$(oc get pods -l component=ibm-nginx -o jsonpath='{ .items[*].metadata.name }' | wc -w)
oc scale Deployment/ibm-nginx --replicas=0
# scale up nginx
sleep 3
oc scale Deployment/ibm-nginx --replicas=${REPLICAS}
```


Wait for the nginx pods to come back up

```bash
oc get pods -l component=ibm-nginx
```

When the integration is running, remove the backup file

```bash
rm ./iaf-system-backup.yaml
```


The last few lines scales down the NGINX pods and scales them back up. It takes about 3 minutes for the pods to fully come back up.

Once those pods have come back up, you can verify the certificate is secure by logging in to AIOps. Note that the login page is not part of AIOps, but rather part of Foundational Services. So you will have to login first and then check that the certificate is valid once logged in. If you want to update the certicate for Foundational Services you can find instructions [here](https://www.ibm.com/docs/en/cpfs?topic=operator-replacing-foundational-services-endpoint-certificates).

#### 8.2.1.1 Old Method (deprecated)

This method alters the NGINX deployment to change the secret/certificate used. The install operator will reset the deployment and replace it with a reference to the original secret, hence reverting back to the default self-signed certificate. It is recommended to use the New Method above.

**Ensure that you are in the project for AIOps** and run the following to create a new secret based on the certificate from the OpenShift.

```
NAMESPACE=$(oc project -q)
ingress_pod=$(oc get secrets -n openshift-ingress | grep tls | grep -v router-metrics-certs-default | awk '{print $1}')
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.crt"}}' ${ingress_pod} | base64 -d | base64 -w 0 > cert.crt
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.key"}}' ${ingress_pod} | base64 -d | base64 -w 0 > cert.key
echo -n "apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: openshift-tls-secret
  namespace: $NAMESPACE
data:
  cert.crt: " > openshift-tls-secret.yaml
cat cert.crt >> openshift-tls-secret.yaml
echo >> openshift-tls-secret.yaml
echo -n "  cert.key: " >> openshift-tls-secret.yaml
cat cert.key >> openshift-tls-secret.yaml
oc create -f openshift-tls-secret.yaml
```
Now we have created a new secret in our AIOps project that matches the OpenShift ingress certicate. The next step is to replace the secret mount in the Nginx deployment. Run the following command to update the deployment with the new secret.

```
oc patch deployment ibm-nginx -p '{"spec":{"template":{"spec":{"volumes":[{"name":"external-tls-secret","secret":{"secretName": "openshift-tls-secret"}}]}}}}'
```
Now wait for the Nginx pods to restart. Once those pods have restarted, you can verify the certificate is secure by logging in to AIOps. Note that the login page is not part of AIOps, but rather part of Foundational Services. So you will have to login first and then check that the certificate is valid once logged in. If you want to update the certicate for Foundational Services you can find instructions [here](https://www.ibm.com/docs/en/cpfs?topic=operator-replacing-foundational-services-endpoint-certificates).


##### 8.2.1.2 If the integration is still not working:


```bash
export WAIOPS_NAMESPACE=aiops
ingress_pod=$(oc get secrets -n openshift-ingress | grep tls | grep -v  router-metrics-certs-default | awk '{print $1}')
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.crt"}}' ${ingress_pod} |  base64 -d > cert.crt
oc get secret -n openshift-ingress -o 'go-template={{index .data "tls.key"}}' ${ingress_pod} |  base64 -d > cert.key
ibm_nginx_pod=$(oc get -n $WAIOPS_NAMESPACE pods -l component=ibm-nginx -o jsonpath='{.items[0].metadata.name}')
oc -n $WAIOPS_NAMESPACE exec ${ibm_nginx_pod} -- mkdir -p "/user-home/_global_/customer-certs"
oc -n $WAIOPS_NAMESPACE cp cert.crt ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
oc -n $WAIOPS_NAMESPACE cp cert.key ${ibm_nginx_pod}:/user-home/_global_/customer-certs/
for i in `oc -n $WAIOPS_NAMESPACE get pods -l component=ibm-nginx -o jsonpath='{.items[*].metadata.name}' `; do oc -n $WAIOPS_NAMESPACE exec ${i} -- /scripts/reload.sh; done
rm -f cert.crt cert.key
```




### 8.3 Change the Slack Slash Welcome Message (optional)

If you want to change the welcome message

```bash
oc set env deployment/$(oc get deploy -l app.kubernetes.io/component=chatops-slack-integrator -o jsonpath='{.items[*].metadata.name }') SLACK_WELCOME_COMMAND_NAME=/aiops-help
```


---------------------------------------------------------------
## 9. Service Now integration
---------------------------------------------------------------



### 9.1 Integration 

1. Follow [this](./tools/9_servicenow/snow-Integrate.md) document to get and configure your Service Now Dev instance with CP4WAIOPS.
	Stop at `Testing the ServiceNow Integration`. 
	❗❗Don’t do the training as of yet.
2. Import the Changes from ./tools/9_servicenow/import_change.xlsx
	1. Select `Change - All` from the right-hand menu
	2. Right Click on `Number`in the header column
	3. Select Import
	![](./pics/snow3.png)
	3. Chose the ./tools/9_servicenow/import_change.xlsx file and click `Upload`
	![](./pics/snow4.png)
	3. Click on `Preview Imported Data`
	![](./pics/snow5.png)
	3. Click on `Complete Import` (if there are errors or warnings just ignore them and import anyway)
	![](./pics/snow6.png)
	
	
3. Import the Incidents from ./tools/9_servicenow/import_incidents.xlsx
	1. Select `Incidents - All` from the right-hand menu
	2. Proceed as for the Changes but for Incidents
	
4. Now you can finish configuring your Service Now Dev instance with CP4WAIOPS by [going back](./tools/9_servicenow/snow-Integrate.md#testing-the-servicenow-integration) and continue whre you left off at `Testing the ServiceNow Integration`. 






---------------------------------------------------------------
## 10. Some Polishing
---------------------------------------------------------------

### 10.1 Add LDAP Logins to CP4WAIOPS


* Go to CP4AIOps Dashboard
* Click on the top left "Hamburger" menu
* Select `User Management`
* Select `User Groups` Tab
* Click `New User Group`
* Enter demo (or whatever you like)
* Click Next
* Select `LDAP Groups`
* Search for `demo`
* Select `cn=demo,ou=Groups,dc=ibm,dc=com`
* Click Next
* Select Roles (I use Administrator for the demo environment)
* Click Next
* Click Create



### 10.2 Get Passwords and Credentials

At any moment you can run `./82_monitor_kafka.sh` this allows you to:

* List all Kafka Topics
* Monitor Derived Stories
* Monitor any specific Topic

You can monitor:

* **derived-stories**: Here you see the stories that get created and pushed to Slack/Teams
* **alerts-noi-1000-1000**: Check if Events from Event Manager are coming in and the Gateway is working as expected (only INSERTS are appearing here, so you might have to delete the Events in Event Manager first in order to recreate them)
* **windowed-logs-1000-1000**: Check log data flowing for log anomaly detection (NOT training)



---

# 11. Demo the Solution


 

## 11.1 Simulate incident

**Make sure you are logged-in to the Kubernetes Cluster first** 

In the terminal type 

```bash
./demo/incident_robotshop.sh
```

This will inject pre-canned event and logs to create a story.

ℹ️  Give it several minutes for all events and anomalies to arrive in Slack.

ℹ️  You might get several stories, this is due to how grouping works, just select the one you're better at ease with.



## 11.2 Simulate incident (silent)

**Make sure you are logged-in to the Kubernetes Cluster first** 

In the terminal type 

```bash
./demo/silent_robotshop.sh
```
 
  
   

-----------------------------------------------------------------------------------
# 12. Installing Turbonomic
---------------------------------------------------------------

## 12.1 Installing Turbonomic

You can install Turbonomic into the same cluster as CP4WAIOPS.

**❗ You need a license in order to use Turbonomic.**

1. Launch

	```bash
	./tools/0_global/44_addon_install_turbonomic.sh
	```
2. Wait for the pods to come up
3. Open Turbonomic
4. Enter the license
5. Add the default target (local Kubernetes cluster is already instrumented with `kubeturbo`)

It can take several hours for the Supply Chain to populate, so be patient.

## 12.2 Installing kubeturbo

In order to get other Kubernetes clusters to show up in Turbonomic, you have to install `kubeturbo` (your main cluster is already registered).

1. Adapt `./yaml/kubeturbo/my_kubeturbo_instance_cr.yaml` with the Turbonomic URL and the login
2. Launch

	```bash
	./tools/0_global/45_addon_install_kubeturbo.sh
	```

## 12.3 Turbo to WAIOPS Gateway

**❗This is not an officialy supported tool by any means and is still under heavy development!**

In order to push Turbonomic Actions into Event Manager you can use my tool.
This tool needs existing `Business Applications`, you can either integrate with Instana (or other APMs) or create one under Settings/Topology.

1. Adapt the `./tools/10_turbonomic/turbo-gateway/create-turbo-gateway.yaml` file 

	| Variable | Default Value | Description |
	| -------- | ------------- | ----------- |
	|POLLING_INTERVAL| '300' | Poll every X seconds |
	|NOI_SUMMARY_PREFIX| '[Turbonomic] ' | Prefix in the event summary |
	|NOI_WEBHOOK_URL| netcool-evtmanager.apps.clustername.domain | Event Manager hostname |
	|NOI_WEBHOOK_PATH| /norml/xxxx | Webhook URL from Event Manager (does not inclue the hostname, only `/norml/xxxx`) |
	|TURBO_API_URL| api-turbonomic.apps.clustername.domain | Turbonomic API URL |
	|TURBO_BA_NAME| 'RobotShop:robot-shop'| Turbonomic application name in the format APPNAME:ALERTGROUP. This links an event manager alertgroup with an application |
	|ACTION_STATES| 'SUCCEEDED,FAILED,READY,IN_PROGRESS' | The list of ACTION_STATES to filter on |
	|ACTION_TYPES| 'MOVE,RESIZE_FOR_PERFORMANCE,RESIZE_FOR_EFFICIENCY,RESIZE' | The list of ACTION_TYPES to filter on |
	|DEBUG_ENABLED| 'false' | Enable additional log output |
	|ENTITY_TYPES| 'VirtualMachine,Application,PhysicalMachine,ContainerSpec,WorkloadController,Container' | The list of ENTITY_TYPES to filter on |
	|ACTION_START_TIME| '-30m'| Period of time in which actions are retrieved. E.g. -5m, -30m, -1h, -1d, -3d, -7d | 

2. Create Turbonomic Credentials Secret

	You can either:
	
	- create the secret from the command line (which will throw a warning for the already existing Secret when installing)
	
		```
		oc -n default create secret generic turbo-creds --from-literal=TURBO_USER=<youruser> --from-literal=TURBO_PWD=<yourpw>
		```
	
	
	- replace the secret in the yaml file with
	
	
		```
		oc -n default create secret generic turbo-creds --from-literal=TURBO_USER=apiuser --from-literal=TURBO_PWD=turboadmin -o yaml --dry-run=client
		```
		
3. Create Generic Webhook in NOI with:

	```json
	{
	"timestamp": "1619706828000",
	"severity": "Critical",
	"summary": "Test Event",
	"nodename": "productpage-v1",
	"alertgroup": "robotshop",
	"url": "https://myturbo/something.html"
	}
	```
4. Launch 

	```shell
	oc apply -n default -f ./tools/10_turbonomic/turbo-gateway/create-turbo-gateway.yaml
	```


## 12.4 Generate Metrics

**❗This is not an officialy supported tool by any means and is still under heavy development!**

If you have manually created a `Business Applications` you won't get any ResponseTime and Transactions metrics.
With this tool you can you can add randomized ResponseTime and Transactions metrics to the `Business Application` through the `Data Integration Framework (DIF)`.

> Note: The metrics pod can also serve metrics for other `Entity` types (businessApplication, businessTransaction, service, databaseServer, application)
> 
> Note: There is also a Route being created by the installer, so that you can test the URLs.
> 

1. Launch

	```shell
	oc apply -n default -f ./tools/10_turbonomic/data-ingestion/create-data-ingestion.yaml
	```

1. Wait for the Pod to become available
1. Add the DIF Target
	2. Go to `Settings/Target Configurations`
	2. Click `New Target`
	2. Select `Custom/DataIngestionFramework`
	2. Put in the URL for the metrics (see below) and a name
	2. Click `Add`
	3. Make sure that Target is green and reads `Validated`

It takes some time for the metrics to start showing up. Polling is every 10 minutes 

### 12.4.1 Test URL

You can use the following URL to test if everything is working:

`http://turbo-dif-service.default:3000/helloworld`

This will create a standalone `Business Application` called `Hello World` without any other `Entities` attached to it. 
But with metrics being ingested.

### 12.4.2 Construct the URL

The URL has the format of:

```yaml
http://turbo-dif-service.default:3000/<TYPE>/<NAME>/<UUID>
```

where:

- TYPE: Type of the `Entity` (businessApplication/businessTransaction/service/databaseServer/application)
- NAME: The name of the `Entity`
- UUID: The UUID that you can find under `Entity Information / Show All / Vendor ID`

So an example might be:
`http://turbo-dif-service.default:3000/service/Service-robot-shop%2Fcatalogue/b2d6fd52-c895-469e-bb98-2a791faefce7`
`http://turbo-dif-service.default:3000/businessApplication/RobotShop/285215220007744`



 
---

# 13. Check installation

Launch the `./12_check-aiops-install.sh` script to check some elements of the installation

---

# 14. TROUBLESHOOTING


## 14.1 Check with script

❗ There is a new script that can help you automate some common problems in your CP4WAIOPS installation.

Just run:

```
./20_debug_install.sh
```


## 14.2 Pods in Crashloop

If the evtmanager-topology-merge and/or evtmanager-ibm-hdm-analytics-dev-inferenceservice are crashlooping, apply the following patches. I have only seen this happen on ROKS.

```bash
oc patch deployment evtmanager-topology-merge -n <YOUR WAIOPS NAMESPACE> --patch-file ./yaml/waiops/pazch/topology-merge-patch.yaml


oc patch deployment evtmanager-ibm-hdm-analytics-dev-inferenceservice -n <YOUR WAIOPS NAMESPACE> --patch-file ./yaml/waiops/patch/evtmanager-inferenceservice-patch.yaml
```

## 14.3 Slack integration not working

See [here](#ngnix-certificate-for-v31---if-the-integration-is-not-working)


## 14.4 Check if data is flowing



### 14.4.1 Check Log injection

To check if logs are being injected through the demo script:

1. Launch 

	```bash
	./82_monitor_kafka.sh
	```
2. Select option 4

You should see data coming in.

### 14.4.2 Check Events injection

To check if events are being injected through the demo script:

1. Launch 

	```bash
	./82_monitor_kafka.sh
	```
2. Select option 3

You should see data coming in.

### 14.4.3 Check Stories being generated

To check if stories are being generated:

1. Launch 

	```bash
	./82_monitor_kafka.sh
	```
2. Select option 2

You should see data being generated.


# 15. Uninstall

❗ The scritps are coming from here [https://github.com/IBM/cp4waiops-samples.git](https://github.com/IBM/cp4waiops-samples.git)

If you run into problems check back if there have been some updates.


I have tested those on 3.1.1 as well and it seemed to work (was able to do a complete reinstall afterwards).

Just run:

```
./tools/99_uninstall/3.1/uninstall-cp4waiops.sh
```

I have also added two scripts:

* `uninstall-niks-addons.sh` to delete the additional things that my script might have added (Routes, demo apps, LDAP, ...)
* `uninstall-prerequisites.sh` to delete the prerequisites (IBM, Strimzi and Knative Operators)

To uninstall everything:

```
./tools/99_uninstall/3.1/uninstall-cp4waiops.sh
./tools/99_uninstall/3.1/uninstall-niks-addons.sh
./tools/99_uninstall/3.1/uninstall-prerequisites.sh
```




---------------------------------------------------------------
## 16. HUMIO 
---------------------------------------------------------------

### This is optional 

> ❗This demo supports pre-canned events and logs, so you don't need to install and configure Humio unless you want to do a live integration (only partially covered in this document).

> ❗Humio is being installed by the installation script.


### 16.1 Configure Humio

* Create Repository `aiops`
* Get Ingest token (<TOKEN_FOR_HUMIO_AIOPS_REPOSITORY>) (`Settings` / `API tokens`)

### 16.2 Limit retention

This is important as your PVCs will fill up otherwise and Humio can become unavailable.

#### 16.2.1 Change retention size for aiops

You have to change the retention options for the aiops repository

![](./pics/humior1.png)

#### 16.2.2 Change retention size for humio

You have to change the retention options for the humio repository

![](./pics/humior2.png)


#### 16.2.3 Live Humio integration with AIManager (disabled by default)

##### 6.2.3.1 Humio URL

- Get the Humio Base URL from your browser
- Add at the end `/api/v1/repositories/aiops/query`


##### 6.2.3.2 Accounts Token

Get it from Humio --> `Owl` in the top right corner / `Your Account` / `API Token
`
##### 6.2.3.3 Create Humio Integration

* In the CP4WAIOPS "Hamburger" Menu select `Operate`/`Data and tool integrations`
* Under `Humio`, click on `Add Integration`
* Name it `Humio`
* Paste the URL from above (`Humio service URL`)
* Paste the Token from above (`API key`)
* In `Filters (optional)` put the following:

	```yaml
	"kubernetes.namespace_name" = /robot-shop/
	| "kubernetes.container_name" != load
	```
* Click `Test Connection`
* Switch `Data Flow` to the `ON` position ❗
* Select `Live data for continuous AI training and anomaly detection`
* Click `Save`




### 16.3 Humio Fluentbit

#### 16.3.1 Automatic installation

```bash
./12_install_fluentbit.sh -t <TOKEN_FOR_HUMIO_AIOPS_REPOSITORY>

```


#### 16.3.3 Manual installation (optional - old way)

```bash
export INGEST_TOKEN=<MY_TOKEN> (put your token from above)

oc adm policy add-scc-to-user privileged -n humio-logging -z humio-fluentbit-fluentbit-read


helm install humio-fluentbit humio/humio-helm-charts \
  --namespace humio-logging \
  --set humio-fluentbit.token=$INGEST_TOKEN \
  --values ./tools/4_integrations/humio/humio-agent.yaml

oc patch DaemonSet humio-fluentbit-fluentbit -n humio-logging -p '{"spec": {"template": {"spec": {"containers": [{"name": "humio-fluentbit","image": "fluent/fluent-bit:1.4.2","securityContext": {"privileged": true}}]}}}}' --type=merge

oc apply -n humio-logging -f ./tools/4_integrations/humio/FluentbitDaemonSet_CUSTOM.yaml


oc delete -n humio-logging pods -l k8s-app=humio-fluentbit


```

