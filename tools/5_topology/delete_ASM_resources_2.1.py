#!/usr/bin/env python
import json
import sys
import os
import base64
import requests
from json import dumps
import urllib3
urllib3.disable_warnings()
requests.packages.urllib3.disable_warnings()


tenantId = os.environ.get('ASM_TENANTID')
username = os.environ.get('ASM_USERNAME')
password = os.environ.get('ASM_PASSWORD')
apiServer=os.environ.get('ASM_TOPOLOGY_URL') + '/1.0/topology'


basicAuthString = username + ':' + password
basicAuthBytes = basicAuthString.encode("utf-8")
basicAuth64 = base64.b64encode(basicAuthBytes)
basicAuth = basicAuth64.decode("utf-8")




# We want to get the observer job--->the provider---->provided
#url = apiServer + '/mgmt_artifacts?_field=_id&_field=uniqueId&_type=observation'

url = apiServer + '/mgmt_artifacts?_field=_id&_field=name&_type=ASM_OBSERVER_JOB'
head = {
    'Authorization':'Basic ' + basicAuth,
    'Accept':'application/json',
    'X-TenantID': tenantId
    }
# get a list of observations
print('Available Observations')
print('----------------------')
r = requests.get(url, verify=False, headers=head).json()
if not r['_items']:
    print('No observations could be found.')
    sys.exit()
else:
    # choose which observation to remove
    print(dumps(r['_items'], indent=2))
    observationId = input('Enter observation _id to delete: ')
# get the provider...
url = apiServer + '/mgmt_artifacts/' + observationId + '/references/in/provided?_include_count=true&_limit=1&_field=*'
r = requests.get(url, verify=False, headers=head).json()
providerId = r['_items'][0]['_id']
# do we really want to delete?
ans = input('❗ Found ' + str(r['_count']) + ' resources, are you sure you want to delete these ? (y or n) : ')
if 'y' in ans:
    url = apiServer + '/mgmt_artifacts/' + providerId + '/references/out/provided?_return=links&_include_count=true'
    r = requests.get(url, verify=False, headers=head).json()
    print('Deleting ' + str(r['_count']) + ' resource(s) via provider ID ' + providerId)
    # loop over the resources deleting them
    for edge in r['_items']:
        print("Deleting '" + edge['_toId'] + "'...")
        # we first do a standard delete...
        url = apiServer + '/resources/' + edge['_toId'] + '?_type=resource'
        r = requests.delete(url, verify=False, headers=head)
        print(r)
        # then an immediate...
        url = apiServer + '/resources/' + edge['_toId'] + '?_immediate=true&_type=resource'
        r = requests.delete(url, verify=False, headers=head)
        print(r)
    # and remove the observation and provider
    print('Deleting provider id ' + providerId)
    url = apiServer + '/mgmt_artifacts/' + providerId
    requests.delete(url, verify=False, headers=head)
    print('Deleting observation id ' + observationId)
    url = apiServer + '/mgmt_artifacts/' + observationId
    requests.delete(url, verify=False, headers=head)