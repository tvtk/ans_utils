# ans_utils
Miscelaneous Ansible utilities

play.sh
=======
Bash utility to execute Ansible playbooks while generating verbous logs
for eventual debugging and preserving them under logs/
#
- initially imported version "play_v03.sh" from 2019/02/13

ans_take_ctrl.sh
ans-take-ctrl_v03.yml
ans_robot.conf
==============
Bash & Ansible tool, which
- generates new ssh key-pair (without passphrase) for selected target node
- creates "ans_robot" user account on target (no password is set)
- deploys created public key to "ans_robot" on target
- configures sudo on target to be allowed for "ans_robot" witout limitations and
   not to require password
Beware:
- it is assumed that Ansible inventory file name is "hosts" and it is present 
   in current working directory
- target needs to be properly specified within inventory
- "ident_files_dir" variable needs to be specified within inventory and
   it must point to existing (& writeable) directory
#
- initial imported version from 2018/03/06

