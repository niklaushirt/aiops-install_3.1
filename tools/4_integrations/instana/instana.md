issue.severity > 7 ? "Critical" : issue.severity > 4 ? "Major" : issue.severity > 0 ? "Minor"
"[Instana] " & issue.text & "  - "  & issue.suggestion
issue.entityLabel
issue.zone & " - " & issue.entity
issue.link
Instana

https://netcool.demo-noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/9dae5722-0129-4a1f-8755-1888054b8460/M1wYnPiynOvkOZuHsWvew314g2lME3xTCNqnWQQws9U

https://noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/9dae5722-0129-4a1f-8755-1888054b8460/M1wYnPiynOvkOZuHsWvew314g2lME3xTCNqnWQQws9U

{
  "issue": {
    "id": "Al2aTp4VSdWvYEnP8ljO1A",
    "type": "issue",
    "state": "OPEN",
    "start": 1615810374000,
    "severity": 9,
    "text": "Garbage Collection Activity High (20.63%)",
    "suggestion": "Tune your Garbage Collector, reduce allocation rate through code changes",
    "link": "https://ibmdevsandbox-instanaibm.instana.io/#/events;eventId=Al2aTp4VSdWvYEnP8ljO1A?&snapshotId=D-PJpJeTcS891D69oTLAyBKBqNE&timeline.ws=600000&timeline.to=1615810674000&timeline.fm=1615810374000",
    "entityType": "JVM",
    "customZone": "Hirt",
    "availabilityZone": "not available",
    "zone": "Hirt",
    "fqdn": "kube-bu79o6uf0e3b4ggdr5jg-demo215prod-default-000002e9.iks.ibm",
    "entity": "JVM",
    "entityLabel": "shipping service 1.0",
    "tags": "",
    "container": "not available",
    "service": "not available",
    "containerNames": []
  }
}





kind: Route
apiVersion: route.openshift.io/v1
metadata:
  name: demo-noi-ibm-cem-normalizer
  namespace: noi
spec:
  host: >-
    noi.aiops-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud
  path: /norml
  to:
    kind: Service
    name: demo-noi-ibm-cem-normalizer
    weight: 100
  port:
    targetPort: 3901
  tls:
    termination: edge
    insecureEdgeTerminationPolicy: Redirect
  wildcardPolicy: None


