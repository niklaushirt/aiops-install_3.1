oc scale --replicas=1  deployment catalogue -n robot-shop #>/dev/null 2>&1
oc delete pod -n robot-shop $(oc get po -n robot-shop|grep catalogue|awk '{print$1}') --force --grace-period=0 #>/dev/null 2>&1
oc delete pod -n robot-shop $(oc get po -n robot-shop|grep user|awk '{print$1}') --force --grace-period=0 #>/dev/null 2>&1
