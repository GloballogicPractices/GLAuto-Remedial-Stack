#!/bin/bash
#
#  About                : Script to Test AutoRemidy Action
#
DIR=$(dirname $0);
SCRIPT_NAME='ProcessUp';
KEY=~/stanley.key
USERNAME="stanley"
file=/var/lib/rundeck/logs/rundeck/$RD_JOB_PROJECT/job/$RD_JOB_ID/logs/$RD_JOB_EXECID.rdlog

# Include configuration file
#source ${DIR}/../conf/plugin.conf;

# Help
usage() {
        echo "Usage: $0 [-h <Hostname>] [-p <Process>] [-t <Ticket>]" 1>&2;
        exit 1;
}

updateTicket(){
token=$(curl --fail --silent --show-error -X POST -H 'X-Redmine-Api-Key: <Redmine Key>' -H 'Content-Type: application/octet-stream' --data-binary @$file http://<redmine url>/uploads.json |jq '.upload.token')

curl --fail --silent --show-error \
     -H 'X-Redmine-Api-Key: <redmine key>' \
     -H "Content-Type: application/json" \
     -X PUT \
     -d '{ "issue": {"notes": "Attaching RunDeck Execution Logs", "uploads": [ { "token": '"$token"', "filename": "rundeck.log", "content_type": "application/octet-stream" }] } }' \
    http://<redmine url>/issues/$TICKET.json
}

while getopts ":h:p:t:" o; do
    case "${o}" in
        h)
            HOSTNAME=${OPTARG}
            if [ -z "${HOSTNAME}" ]; then
                usage;
            fi
            ;;
        p)
            PROCESS=${OPTARG}
            if [ -z "${PROCESS}" ]; then
                usage;
            fi
            ;;
        t)
            TICKET=${OPTARG}
            if [ -z "${TICKET}" ]; then
                usage;
            fi
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Input Validation
if [ -z "${HOSTNAME}" ] || [ -z "${PROCESS}" ] || [ -z "$TICKET" ]; then
                logger ERROR "Invalid argument passed";
    usage
fi      

PROCESSID=$(echo $PROCESS | cut -d '-' -f2 | perl -ne 'print lc')

/usr/bin/ssh -T -v -o StrictHostKeyChecking=no -i $KEY $USERNAME@$HOSTNAME << EOF
sudo systemctl restart $PROCESSID

EOF

if [ $? -eq 0 ]; then
        /bin/aws sqs send-message --queue-url https://<sqs url> --message-body "process: $PROCESS | status: Sucess | redmine_id: $TICKET | rd_ticket: $RD_JOB_EXECID | hostname: $HOSTNAME <queuename>" --delay-seconds 2
	updateTicket
else
        /bin/aws sqs send-message --queue-url https://<sqs url> --message-body "process: $PROCESS | status: Failed | redmine_id: $TICKET | rd_ticket: $RD_JOB_EXECID | hostname: $HOSTNAME <queuename>" --delay-seconds 2
	updateTicket
	exit 1
fi
