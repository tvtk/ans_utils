#!/bin/bash

LOG_DIR="logs"

if [ $# -lt 2 ]
then
   echo "ERROR: mandatory argument missing"
   echo "   Usage: ./play.sh <inventory_host_name> <playbook_name>]"
   exit 1
fi

if [ ! -d "${LOG_DIR}/${1}" ]
then
   mkdir -p "${LOG_DIR}/${1}"
fi
if [ ! -f "${2}.yml" ]
then
   echo "ERROR: nonexistent playbook \"${2}.yml\""
   echo "   Usage: ./play.sh <inventory_host_name> <playbook_name>]"
   exit 1
fi

TMSTAMP="$(date +%s)"
LOG="logs/${1}/$(date +%Y%m%dT%H%M%S%z --date=@${TMSTAMP})_${2}.log"
ansible-playbook -vvv -l "${1}" -i hosts -e "ansible_user=ans_robot" "${2}.yml" | tee "${LOG}"
echo "----------------" >> "${LOG}"
date +%Y%m%dT%H%M%S%z >> "${LOG}"
