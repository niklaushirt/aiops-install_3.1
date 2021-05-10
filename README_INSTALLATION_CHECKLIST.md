# Watson AIOps Demo Environment Installation - Checklist


## Prerequisites

- [ ] OpenShift requirements

- [ ] Adapt Hosts file (Fyre only)

- [ ] Storage Requirements

- [ ] Docker Pull secret

- [ ] Install Tooling
 
- [ ] Get the scripts and code from GitHub


## AI and Event Manager Base Install
- [ ] Adapt install configuration
 
- [ ] Start installation

- [ ] Post-installation 

- [ ] Re-running post-installation

- [ ] Get Passwords and Credentials

- [ ] Check status of installation

## HUMIO

   
- [ ] Configure Humio
 
- [ ] Limit retention
 
	- [ ] Change retention size for aiops
 
	- [ ] Change retention size for humio

- [ ] Humio Fluentbit
 
	- [ ] Install DaemonSet
   
	- [ ] Modify DaemonSet




## Configure Applications and Topology

- [ ] Create Kubernetes Observer

- [ ] Create REST Observer to Load Topologies

- [ ] Create Merge Rules for Kubernetes Observer

- [ ] Load Merge Topologies

- [ ] Create AIOps Application



## Configure Event Manager

- [ ] Event Manager Webhooks

- [ ] Create custom Filter and View in NOI (optional)
 
- [ ] Create Templates (optional)
 
- [ ] Create grouping Policy



## Train Incident Similarity (big ugly HACK)

- [ ] Train Log Anomaly

- [ ] Train Event Grouping

- [ ] Train Incident Similarity (⚠️ **This is officially unsupported!**)



## Train Log Anomaly
- [ ]  Prerequisites
- [ ]  Create Humio Integration
- [ ]  Create Kafka Training Integration
- [ ]  Create Kafka Training Integration
- [ ]  Train the model
- [ ]  Enable Log Anomaly detection


## Train Event Grouping
- [ ]  Prerequisites
- [ ]  Create Integration
- [ ]  Create Training Definition
- [ ]  Train the model
- [ ]  Enable Event Grouping


## Train Incident Similarity
- [ ]  Create Dummy Service Now Integration
- [ ]  Prerequisite - install old (and unsupported) model-train-console
- [ ]  Incidents Similarity Training


## Configure Runbooks
- [ ] Create Bastion Server
 
- [ ] Create the NOI Integration
 
	- [ ] In NOI
   
	- [ ] Adapt SSL Certificate in Bastion Host Deployment.
   
- [ ] Create Automation
 
- [ ] Create Runbooks
 
- [ ] Add Runbook Triggers
 


## Slack integration
- [ ] Refresh ingress certificates (otherwise Slack will not validate link)
 
- [ ] Integration
 
- [ ] Change the Slash Welcome Message (optional)

- [ ] Create User OAUTH Token


## Some Polishing
 
- [ ] Add LDAP Logins to CP4WAIOPS

- [ ] Check if data is flowing
 
 

## Check installation

- [ ] Check if installation is ok