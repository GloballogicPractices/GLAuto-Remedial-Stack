#!/usr/bin/python
import json
import re
import requests
import os

fileName = "/opt/queue.out"
file = open(fileName, 'r')
inputData = file.read()

json_str = json.dumps(inputData)
alert_dict = json.loads(inputData)

regexMetric= re.compile('MetricName.[:]"(.*?)"')
metric = regexMetric.findall(alert_dict['Message'])
metric = metric
print "Metric is %s" %metric[0]
metric = str(metric[0])

regexNamespace= re.compile('Namespace.[:]"(.*?)"')
namespace = regexNamespace.findall(alert_dict['Message'])
namespace = str(namespace[0])
print "Namespace is %s" %namespace


regexId= re.compile('value.[:]"(.*?)"')
instanceId = regexId.findall(alert_dict['Message'])
instanceId = str(instanceId[0])
print "InstaneId is %s" %instanceId

regexRegion= re.compile('Region.[:]"(.*?)"')
region = regexRegion.findall(alert_dict['Message'])
region = str(region[0])
print "region is %s" %region

regexSubject= re.compile('AlarmName.[:]"(.*?)"')
subject = regexSubject.findall(alert_dict['Message'])
subject = str(subject[0])
print "subject is %s" %subject

regexHost = re.compile('HTTPD_(ip.*)')
host = regexHost.findall(subject)
host = str(host[0])

def createTicket():
  url = "http://<redmine url>/projects/<redmine project>/issues.json"
  headers = {'X-Redmine-Api-Key':'<redmine key>' , 'Content-Type': 'application/json'}
  payload = '{"issue": {"project_id": "<project Name>", "tracker_id": 4, "subject": "'+subject+'", "priority_id": 3, "custom_fields": [{"value":"'+metric+'", "id": 3} , {"value":"'+namespace+'", "id":6}, {"value":"'+region+'", "id":4} , {"value":"'+instanceId+'", "id":2} ]  } }'
  issue_id = requests.post(url, data=payload, headers=headers)
  response_data = issue_id.text

  regexId = re.compile('"issue":{"id".(\d+)')
  issueId = regexId.findall(issueId.text)
  issueId = str(issueId[0])
  return  issueId
issueId = createTicket()

os.system('/bin/bash /opt/rdexec.sh "'+host+'" "'+metric+'" "'+issueId+'"')
