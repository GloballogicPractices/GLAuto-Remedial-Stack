## StackStorm Auto Remedial Stack

This stack allows you to impliment auto remdiation on your infrastructure.

## Pre-Requisite
Before using this stack you need to have below things already in your infrastructure.

1. AWS envirnoment being monitoered by CloudWatch
2. Cloudwatch alerts needs to be enable to send notification on SNS topic
3. SNS topic should be subscribe with SQS
4. *Most Important* Your alert name should be match from the below pattern
      
      `MON_<Project>_<Module>_<NameSpace>_<Metric>_<Hostname>`




## Installation

1. StackStrom
      Install using `https://docs.stackstorm.com/install/index.html`
      
      Install Pack AWS - `st2 pack install aws`
      
      Configure Pack `st2 pack config aws`
      
      Add rule `st2 rule add -f rulefile.yaml`
      
      Install rundeck cli

2. Rundeck
      
      Install rundeck
      
      Create job and put `process.sh`

3. Install redmine follow Readme


