# Steps performed in the `./10_install_aiops.sh` script

- **Initializing**
   - Input Parameters
   - Prerequisites Checks

- **Install Prerequisites**
   - Storage Checks
   - Restart OCP Image Registry
   - Install Operators
      - Patch OCP Registry
      - Create Namespace $WAIOPS_NAMESPACE
      - Create Pull Secret
      - Adjust OCP Stuff
      - Install IBM Operator Catalog
      - Install IBM AIOps Catalog
      - Install IBM Common Services Catalog
      - AI OPS - Install Subscription

   - Install Strimzi
      - AI OPS - Create Subscription for Strimzi


   - Install Knative
      - Create Namespace knative-serving
      - Create Namespace knative-eventing
      - Create Namespace openshift-serverless
      - Install Knative Subscription
      - AI OPS - Create Knative Serving
      - AI OPS - Create Knative Eventing

- **Install CP4WAIOPS**
      - CP4WAIOPS - Create Template Files
      - Install CP4WAIOPS CR

- **Install CP4WAIOPS**

- **Post-Install**
   - Install HUMIO

   - Install LDAP

   - Create OCP User
   
   - Install Demo Apps
      - Install Bookinfo
      - Install Kubetoy
      - Install RobotShop

   - Patch Ingress

   - Create Gateway
      - Create Gateway for all Events Severity > 2

   - Create Topology Routes
      - Create Topology Merge Route
      - Create Topology Rest Route

   - Create Flink Job Manager Routes

   - Register LDAP

   - Create Strimzi Route

   - Housekeeping
      - Adapt Nginx Certs

