# Watson AIOps Demo Environment Installation - Checklist


## Prerequisites

- [ ] Install Tooling
 
- [ ] Get the scripts and code from GitHub


## AI and Event Manager Base Install
- [ ] Adapt install configuration
 
- [ ] Start installation
 
- [ ] Start Post Installation



## HUMIO

   
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





 
## Connections from AI Manager (Ops Integration)

- [ ] Create Humio Ops Integration on Bookinfo App

- [ ] Create Humio Ops Integration on RobotShop App
 



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
 


## Slack integration
- [ ] Refresh ingress certificates (otherwise Slack will not validate link)
 
- [ ] Integration
 
- [ ] Change the Slash Welcome Message (optional)


## Some Polishing
 
- [ ] Check if data is flowing
 
 

## Check installation

- [ ] Check if installation is ok