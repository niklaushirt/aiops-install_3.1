#!/usr/bin/env python
import json
import os
import base64
import requests
from json import dumps
import urllib3
urllib3.disable_warnings()
apiServer=os.environ.get('ASM_TOPOLOGY_URL') + '/1.0/topology'
url = apiServer + '/mgmt_artifacts?_field=_id&_field=uniqueId&_type=observation'
username = os.environ.get('ASM_USERNAME')
password = os.environ.get('ASM_PASSWORD')


basicAuthString = username + ':' + password
basicAuthBytes = basicAuthString.encode("utf-8")
basicAuth64 = base64.b64encode(basicAuthBytes)
basicAuth = basicAuth64.decode("utf-8")

head = {
    'Authorization':'Basic ' + basicAuth,
    'Accept':'application/json',
    'X-TenantID': 'cfd95b7e-3bc7-4006-a4a8-a73a79c71255'
    }
# get a list of observations
r = requests.get(url, verify=False, headers=head).json()
print(dumps(r['_items'], indent=2))
# choose which observation to remove
jobId = input('🚀 Please enter the observation id you wish to delete resources for : ')
# see how many resources there are
print('searching for resources.....')
url = apiServer + '/mgmt_artifacts/' + jobId + '/references/out/observation?_include_count=true&_limit=1'
r = requests.get(url, verify=False, headers=head).json()
# do we really want to delete?
ans = input('❗ Found ' + str(r['_count']) + ' resources, are you sure you want to delete these ? (y or n) : ')
if 'y' in ans:
    url = apiServer + '/mgmt_artifacts/' + jobId + '/references/out/observation?_limit=' + str(r['_count'])
    r = requests.get(url, verify=False, headers=head).json()
    # loop over the resources deleting them
    for resource in r['_items']:
        print('Deleting: ' + resource['_id'])
        url = apiServer + '/resources/' + resource['_id']
        r = requests.delete(url, verify=False, headers=head)
        if (r.status_code != 204):
            print('problem deleting ' + resource['_id'])
    # and remove the observation
    url = apiServer + '/mgmt_artifacts/' + jobId
    print('Deleting Observer: ' + resource['_id'])
    r = requests.delete(url, verify=False, headers=head)
    if (r.status_code != 204):
        print('problem deleting observation ' + jobId)