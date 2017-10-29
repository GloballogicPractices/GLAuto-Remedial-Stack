#!/bin/bash
host=$1
process=$2
ticket=$3

export RD_PROJECT=<project name>
export RD_URL=<rundeck url>
export RD_TOKEN=<rundeck token>
export RD_COLOR_INFO=blue
export RD_COLOR_WARN=orange
export RD_COLOR_ERROR=cyan

#/bin/rd adhoc -F "Monitoring" whoami

/bin/rd run -j "<job name>" -p "<project name>" -- -host $host -process $process  -ticket $ticket
