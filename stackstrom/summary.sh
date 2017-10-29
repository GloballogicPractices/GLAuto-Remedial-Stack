#!/bin/bash

file_name="/opt/summary.out"
status="$(cat $file_name | cut -d "|" -f2 |awk '{print $2}')"
color_code="#008000"
bot_user="StackStrom Remidation Summary"

if [[ "$status" == "Failed" ]]; then
color_code="#ff0000"
fi


host="$(cat $file_name | cut -d "|" -f5 |awk '{print $2}')"
process="$(cat $file_name | cut -d "|" -f1 |awk '{print $2}')"
ticket="$(cat $file_name | cut -d "|" -f3 |awk '{print $2}')"
exec_id="$(cat $file_name | cut -d "|" -f4 |awk '{print $2}')"
redmine_url="http://<redmine url>/issues/$ticket"
rd_url="http://<rundeck url>/project/<project name>/execution/show/$exec_id"
url="<slack webhook url>" #TGG
channel="<slack channel>"
content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \"Remedy action on: \`$host\`\", \"text\": \"StackStorm Autoremedial Summary \`$host\`\", \"fields\": [ { \"title\": \"Redmine Ticket\", \"value\": \"<$redmine_url|$ticket>\", \"short\": true }, { \"title\": \"Rundeck ExecID\", \"value\": \"<$rd_url|$exec_id>\", \"short\": true }, { \"title\": \"Impacted Component\", \"value\": \"$process\", \"short\": true }, { \"title\": \"Status\", \"value\": \"$status\", \"short\": true } ], \"color\": \"$color_code\" } ]"

curl --fail --silent --show-error -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"mrkdwn\": true, \"username\": \"$bot_user\", $content, \"icon_url\": \"http://i.imgur.com/sCc1GRI.jpg\"}" $url > /dev/null 2>&1
