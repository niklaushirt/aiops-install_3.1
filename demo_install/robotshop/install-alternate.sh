oc create ns myrobot-shop
oc adm policy add-scc-to-user privileged -n myrobot-shop -z myrobot-shop
oc create clusterrolebinding default-myrobotinfo-admin --clusterrole=cluster-admin --serviceaccount=myrobot-shop:myrobot-shop
oc adm policy add-scc-to-user privileged -n myrobot-shop -z default                       
oc create clusterrolebinding default-myrobotinfo1-admin --clusterrole=cluster-admin --serviceaccount=myrobot-shop:default
oc apply -f ./demo_install/robotshop/robot-all-in-one-alternate.yaml -n myrobot-shop
oc apply -n myrobot-shop -f ./demo_install/robotshop/load-deployment-alternate.yaml






oc delete -f ./demo_install/robotshop/robot-all-in-one.yaml -n myrobot-shop
oc delete -n myrobot-shop -f ./demo_install/robotshop/load-deployment.yaml



oc delete -f ./demo_install/robotshop/robot-all-in-one.yaml -n robot-shop
oc delete -n robot-shop -f ./demo_install/robotshop/load-deployment.yaml