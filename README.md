## StackStorm Auto Remedial Stack

This stack allows you to impliment auto remdiation on your infrastructure.


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


