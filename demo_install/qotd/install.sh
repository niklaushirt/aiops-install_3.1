https://gitlab.com/quote-of-the-day/quote-of-the-day/-/blob/master/ocp4_deployment.md


git clone git@gitlab.com:quote-of-the-day/quote-of-the-day.git

cd quote-of-the-day

oc new-project qotd
oc project qotd
oc adm policy add-scc-to-user anyuid -z default
oc create -f k8s/


