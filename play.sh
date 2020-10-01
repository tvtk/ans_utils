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
if [ -d ".git" ]
then
   # record git info to the log
   echo "#------ GIT INFO BEGIN ------" >> "${LOG}"
   git status >> "${LOG}" 2>&1
   echo "#----------------------------" >> "${LOG}"
   git log -n 1 >> "${LOG}" 2>&1
   echo "#------ GIT INFO END ------" >> "${LOG}"
fi
ansible-playbook -vvv -l "${1}" -i hosts -e "ansible_user=ans_robot" "${2}.yml" | tee -a "${LOG}"
ENDTM="$(date +%s)"
echo "----------------" >> "${LOG}"
ELAPSED=$((${ENDTM} - ${TMSTAMP}))
echo "Finished in ${ELAPSED} sec/ $(date -u +"%H:%M:%S hms" --date=@${ELAPSED})" >> "${LOG}"
echo "----------------" >> "${LOG}"
echo "$(date +%Y%m%dT%H%M%S%z --date=@${ENDTM})" >> "${LOG}"
