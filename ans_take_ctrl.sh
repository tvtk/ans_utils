#!/bin/bash
if [ $# -lt 1 ]
then
   echo "ERROR: mandatory argument missing"
   echo "   Usage: ./ans_take_ctrl.sh <ansible-inventory-name> [<remote-user-name>]"
   exit 1
fi
if [ $# -eq 2 ]
then
   RMT_USR="${2}" 
else
   # username not provided -> let's use default
   RMT_USR="root"
fi
echo "INFO: using \"${RMT_USR}\" as remote user"
ansible-playbook -i hosts -l "${1}" --user "${RMT_USR}" ans-take-ctrl.yml --ssh-extra-args='-o StrictHostKeyChecking=no' -k -K -e "{\"ansible_user\": \"${RMT_USR}\"}"
