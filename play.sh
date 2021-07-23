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
PB_NAME=$( basename "${2}" ".yml" )
if [ ! -f "${PB_NAME}.yml" ]
then
   echo "ERROR: nonexistent playbook \"${PB_NAME}.yml\""
   echo "   Usage: ./play.sh <inventory_host_name> <playbook_name>]"
   exit 1
fi

TMSTAMP="$(date +%s)"
LOG="logs/${1}/$(date +%Y%m%dT%H%M%S%z --date=@${TMSTAMP})_${PB_NAME}.log"
if [ -d ".git" ]
then
   # record git info to the log
   echo "#------ GIT INFO BEGIN ------" >> "${LOG}"
   git status >> "${LOG}" 2>&1
   echo "#----------------------------" >> "${LOG}"
   git log -n 1 >> "${LOG}" 2>&1
   echo "#------ GIT INFO END ------" >> "${LOG}"
fi
ansible-playbook -vvv -l "${1}" -i hosts -e "ansible_user=ans_robot" "${PB_NAME}.yml" 2>&1 | tee -a "${LOG}"
PB_RESULT="${PIPESTATUS[0]}"
ENDTM="$(date +%s)"
echo "----------------" >> "${LOG}"
ELAPSED=$((${ENDTM} - ${TMSTAMP}))
echo "Finished in ${ELAPSED} sec/$(date -u +"%H:%M:%S hms" --date=@${ELAPSED})" >> "${LOG}"
echo "----------------" >> "${LOG}"
echo "$(date +%Y%m%dT%H%M%S%z --date=@${ENDTM})" >> "${LOG}"
#
exit ${PB_RESULT}

