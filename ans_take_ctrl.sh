#!/bin/bash
if [ $# -lt 1 ]
then
   echo "ERROR: mandatory argument missing"
   echo "   Usage: ./ans_take_ctrl.sh <ansible-inventory-name>"
   exit 1
fi
ansible-playbook -i hosts -l "${1}" ans-take-ctrl_v03.yml --ssh-extra-args='-o StrictHostKeyChecking=no' -k
