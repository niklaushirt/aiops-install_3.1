# Watson AIOps Demo Environment Installation - Checklist


## Prerequisites

- [ ] Install Tooling
 
- [ ] Get the scripts and code from GitHub


## AI and Event Manager Base Install
- [ ] Adapt install configuration
 
- [ ] Start installation
 
- [ ] Create NOI User that can see Topology

## Demo Apps in AI Manager
- [ ] Create Dummy Slack integration
 
- [ ] Create Apps

## Demo Apps
- [ ] Install Bookinfo
 
	- [ ] Install Bookinfo generate load
   
- [ ] Install Kubetoy
 
- [ ] Install RobotShop
 
	- [ ] Install RobotShop generate load
   
   
## NOI Webhooks
- [ ] Humio Webhook
 
- [ ] Falco Webhook (optional)
 
- [ ] Git Webhook (optional)
 
- [ ] Metrics Webhook (optional)
 
- [ ] Instana Webhook (optional)
 
- [ ] Copy the Webhook URLS into 01_config.sh
 
- [ ] Create NOI Menu item

## HUMIO
- [ ] Install HUMIO
 
	- [ ] Change developer password (optional)
   
- [ ] Configure Humio
 
- [ ] Limit retention
 
	- [ ] Change retention size for aiops
 
	- [ ] Change retention size for humio

- [ ] Humio Fluentbit
 
	- [ ] Install DaemonSet
   
	- [ ] Modify DaemonSet

- [ ] Configure Humio Notifier
 
- [ ] Create Alerts
 
	- [ ] BookinfoProblem
   
	- [ ] BookinfoRatingsDown
   
	- [ ] BookinfoReviewsProblem
   
	- [ ] KubetoyLivenessProbe
   
	- [ ] KubetoyAvailabilityProblem
   
	- [ ] RobotShopCataloguePodProblem
   
	- [ ] RobotShopCatalogueProblem

	- [ ] RobotShopWebProblem

	- [ ] RobotShopFrontendProblem

## Train the Models
- [ ] Prerequisite - adapt for ROKS S3 Storage
 
- [ ] Training - Bookinfo 
 
- [ ] Training - RobotShop 
 
- [ ] Training - Kubetoy 



 
## Connections from AI Manager (Ops Integration)

- [ ] Create Humio Ops Integration on Bookinfo App

- [ ] Create Humio Ops Integration on RobotShop App
 
- [ ] Create NOI Ops Integration on Bookinfo App
 
- [ ] Create NOI Ops Integration  on RobotShop App
 
- [ ] Create NOI Ops Integration  on Kubetoy App
 
   
- [ ] Create Log Ops Integration on Bookinfo App (optional)



## Configure Event Manager / ASM Topology
- [ ] Load Topologies for RobotShop and Bookinfo
 
- [ ] Create Templates
 
- [ ] Create grouping Policy


## Configure Runbooks
- [ ] Create Bastion Server
 
- [ ] Create the NOI Integration
 
	- [ ] In NOI
   
	- [ ] Adapt SSL Certificate in Bastion Host Deployment.
   
- [ ] Create Automation
 
- [ ] Create Runbooks
 
- [ ] Add Runbook Triggers
 


## Install Event Manager Gateway
- [ ] Create Strimzi route
 
- [ ] Copy secret strimzi-cluster-cluster-ca-cert
 
- [ ] Get needed info
 
- [ ] Modify Template
 
- [ ] Apply Manifest


## Create ASM Integration in AI Manager
- [ ] Create the Operations integration for the AppGroup
 
	- [ ] Get certificate
   
	- [ ] Input values
   
- [ ] Check ASM connection


## Slack integration
- [ ] Refresh ingress certificates (otherwise Slack will not validate link)
 
- [ ] Integration
 
- [ ] Change the Slash Welcome Message (optional)


## Some Polishing
- [ ] Make Flink Console accessible
 
- [ ] Check if installation is ok
 
- [ ] Check if data is flowing
 
- [ ] Create USER
 
- [ ] Change admin password AI Manager

## Check installation